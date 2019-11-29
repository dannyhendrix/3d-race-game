part of game;

class VehicleControl {
  void controlToTarget(Vehicle vehicle, Vector target) {
    vehicle.setSteer(steerToPoint(vehicle.position, vehicle.r, target));
    vehicle.setAccelarate(true);
  }

  void onControl(Control control, bool active, Player player, Vehicle vehicle) {
    switch (control) {
      case Control.Accelerate:
        player._isAccelarating = active;
        break;
      case Control.Brake:
        player._isBreaking = active;
        break;
      case Control.SteerLeft:
        player._isSteeringLeft = active;
        break;
      case Control.SteerRight:
        player._isSteeringRight = active;
        break;
      default:
        break;
    }

    vehicle.setAccelarate(player._isAccelarating);
    vehicle.setBrake(player._isBreaking);
    if (player._isSteeringRight && !player._isSteeringLeft)
      vehicle.setSteer(Steer.Right);
    else if (!player._isSteeringRight && player._isSteeringLeft)
      vehicle.setSteer(Steer.Left);
    else
      vehicle.setSteer(Steer.None);
  }

  void controlAvoidance(Vehicle vehicle) {
    Steer steer = Steer.None;
    bool accelerate = true;
    double correction = 0.0;
    if (vehicle.sensorLeft.collides) correction -= 0.2;
    if (vehicle.sensorLeftFront.collides) correction -= 0.5;
    if (vehicle.sensorLeftFrontAngle.collides) correction -= 0.5;
    if (vehicle.sensorRight.collides) correction += 0.2;
    if (vehicle.sensorRightFront.collides) correction += 0.5;
    if (vehicle.sensorRightFrontAngle.collides) correction += 0.5;

    if (vehicle.sensorFront.collides) accelerate = false;

    if (correction > 0.0)
      steer = Steer.Left;
    else if (correction < 0.0)
      steer = Steer.Right;
    else if (vehicle.sensorFront.collides) steer = Steer.Right;

    vehicle.setSteer(steer);
    vehicle.setAccelarate(accelerate);
    /*
    bool leftCollision = vehicle.sensorLeft.collides || vehicle.sensorLeftFront.collides || vehicle.sensorLeftFrontAngle.collides;
    bool rightCollision = vehicle.sensorRight.collides || vehicle.sensorRightFront.collides || vehicle.sensorRightFrontAngle.collides;
    if(leftCollision && rightCollision) return Steer.None;
    if(leftCollision) return Steer.Right;
    if(rightCollision) return Steer.Left;
    return Steer.None;*/
  }

  Steer steerToPoint(Vector A, double RA, Vector B) {
    var dist = B - A;
    var normT = new Vector(dist.x, dist.y); //.normalized;
    var normA = new Vector.fromAngleRadians(RA, 1.0);
    var ra = normA.angleThis();
    var rt = normT.angleThis();
    if (ra == 0) {
      if (rt > 0) return Steer.Right;
      return Steer.Left;
    }
    if (rt == 0) {
      if (ra < 0) return Steer.Right;
      return Steer.Left;
    }
    if (ra < 0 && rt < 0) {
      if (ra < rt) return Steer.Right;
      return Steer.Left;
    }
    if (ra > 0 && rt > 0) {
      if (rt < ra) return Steer.Left;
      return Steer.Right;
    }
    if (ra < 0 && rt > 0) {
      if (rt - ra > pi) return Steer.Left;
      return Steer.Right;
    }
    if (ra > 0 && rt < 0) {
      if (ra - rt > pi) return Steer.Right;
      return Steer.Left;
    }
    return Steer.None;
  }

  void update(Vehicle vehicle, GameState game) {
    bool gameStateRacing = game.state == GameStatus.Racing;
    //bool gameStateRacingOrCountDown = game.state == GameState.Racing || game.state == GameState.Countdown;
    //Steering
    var oldr = vehicle.r;
    if (gameStateRacing) vehicle.r = _applySteering(vehicle.r, vehicle.vehicleSettings.getValue(VehicleSettingKeys.steering_speed), vehicle._isSteering);
    var newr = vehicle.r;
    vehicle.r = oldr;

    //Apply Forces
    bool wasStandingStill = vehicle._speed == 0;
    vehicle._speed = _applyAccelerationAndBrake(vehicle._speed, vehicle.vehicleSettings.getValue(VehicleSettingKeys.acceleration), vehicle.vehicleSettings.getValue(VehicleSettingKeys.reverse_acceleration), vehicle.vehicleSettings.getValue(VehicleSettingKeys.brake_speed), vehicle.vehicleSettings.getValue(VehicleSettingKeys.acceleration_max), vehicle.vehicleSettings.getValue(VehicleSettingKeys.reverse_acceleration_max), vehicle._currentStandStillDelay == 0, vehicle._isAccelerating && gameStateRacing, vehicle._isBraking && gameStateRacing);
    vehicle._speed = _applyFriction(vehicle._speed, vehicle.vehicleSettings.getValue(VehicleSettingKeys.friction));

    // slower off road
    // TODO: make this level dependant?
    if (!game.level.onRoad(vehicle.position)) {
      vehicle._speed *= 0.9;
    }
    vehicle._currentStandStillDelay = _updateStandStillDelay(vehicle._currentStandStillDelay, vehicle.vehicleSettings.getValue(VehicleSettingKeys.standstill_delay), wasStandingStill, vehicle._speed == 0);

    //Velocity *= 0.6;
    //Velocity += Vector.NewFromAngleRadians(R, Speed)*0.01;
    var rdif = newr - oldr;
    //position += vector;
    //base.Step();

    vehicle.isMoving = true;
    //VelocityRotation = rdif;
    vehicle.velocityRotation = rdif;

    var _friction = 0.5;

    vehicle.velocity.addVectorToThis(vehicle.collisionCorrection);
    vehicle.velocityRotation += vehicle.collisionCorrectionRotation;

    if (!vehicle.hasCollided) {
      vehicle.velocity.multiplyToThis(1 - _friction);
      //VelocityRotation *= (1 - _friction);
      vehicle.velocity.addVectorToThis(new Vector.fromAngleRadians(vehicle.r, vehicle._speed) * 0.5);
    }

    vehicle.applyOffsetRotation(vehicle.velocity, vehicle.velocityRotation);

    vehicle.resetCollisions();
  }

  double _applyFriction(double V, double F) {
    if (V > 0)
      V -= min(V, F);
    else if (V < 0) V += min(-V, F);
    return V;
  }

  double _applyAccelerationAndBrake(double V, double A, double R, double B, double MaxA, double MaxR, bool canStartFromZero, bool acc, bool brake) {
    if (acc && brake) {
      if (V > 0)
        V -= B;
      else if (V < 0) V += B;
    } else {
      if (V == 0) {
        if (canStartFromZero) {
          if (acc) V += A;
          if (brake) V -= R;
        }
      } else if (V > 0) {
        if (acc) V += A;
        if (brake) V -= min(V, B);
      } else if (V < 0) {
        if (acc) V += min(-V, B);
        if (brake) V -= R;
      }
    }
    if (V > MaxA) V = MaxA;
    if (V < -MaxR) V = -MaxR;
    return V;
  }

  int _updateStandStillDelay(int currentStandStillDelay, int standStillDelay, bool wasStandingStill, bool standingStill) {
    if (!standingStill || !wasStandingStill) return standStillDelay;

    currentStandStillDelay -= 1;
    if (currentStandStillDelay < 0) currentStandStillDelay = 0;

    return currentStandStillDelay;
  }

  double _applySteering(double r, double S, Steer steering) {
    switch (steering) {
      case Steer.Left:
        r -= S;
        break;
      case Steer.Right:
        r += S;
        break;
      default:
        break;
    }
    return r;
  }
}
