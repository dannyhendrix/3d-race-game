part of micromachines;

enum VehicleSettingKeys {
  acceleration,
  acceleration_max,
  reverse_acceleration,
  reverse_acceleration_max,
  friction,
  brake_speed,
  steering_speed,
  standstill_delay,
  collision_force,
  collision_force_after_collision,
}

class VehicleSettings{
  Map data = {
    VehicleSettingKeys.acceleration.toString() :0.3,
    VehicleSettingKeys.acceleration_max.toString() : 7.0,
    VehicleSettingKeys.reverse_acceleration.toString() : 0.1,
    VehicleSettingKeys.reverse_acceleration_max.toString() : 2.0,
    VehicleSettingKeys.friction.toString() : 0.05,
    VehicleSettingKeys.brake_speed.toString() : 0.2,
    VehicleSettingKeys.steering_speed.toString() : 0.1,
    VehicleSettingKeys.standstill_delay.toString() : 6,
    VehicleSettingKeys.collision_force.toString() : 4.0,
    VehicleSettingKeys.collision_force_after_collision.toString() : 0.35,
  };
  dynamic getValue(VehicleSettingKeys key){
    return data[key.toString()];
  }
}

class Vehicle extends MoveableGameObject{
  Game game;
  Player player;
  bool _isBraking = false;
  bool _isAccelerating = false;
  Steer _isSteering = Steer.None;
  double _speed = 0.0;
  String info = "";
  int _currentStandStillDelay = 0;
  bool _isCollided = false;
  VehicleSettings vehicleSettings = new VehicleSettings();
  int theme = 0;

  Vehicle(this.game, this.player){
    position = new Point(150.0, 50.0);
    r = 0.0;
    w = 50.0;
    h = 30.0;
    collisionField = new Polygon([
      new Point(0.0,0.0),
      new Point(w,0.0),
      new Point(w,h),
      new Point(0.0,h),
    ]);
  }
  void setAccelarate(bool a){
    _isAccelerating = a;
  }
  void setBrake(bool a){
    _isBraking = a;
  }
  void setSteer(Steer a){
    _isSteering = a;
  }

  bool get isCollided => _isCollided;

  void update(){

    //Steering
    r = _applySteering(r,vehicleSettings.getValue(VehicleSettingKeys.steering_speed), _isSteering);

    //Apply Forces
    bool wasStandingStill = _speed == 0;
    _speed = _applyAccelerationAndBrake(_speed,
        vehicleSettings.getValue(VehicleSettingKeys.acceleration),
        vehicleSettings.getValue(VehicleSettingKeys.reverse_acceleration),
        vehicleSettings.getValue(VehicleSettingKeys.brake_speed),
        vehicleSettings.getValue(VehicleSettingKeys.acceleration_max),
        vehicleSettings.getValue(VehicleSettingKeys.reverse_acceleration_max),
        _currentStandStillDelay==0, _isAccelerating, _isBraking);
    _speed = _applyFriction(_speed,vehicleSettings.getValue(VehicleSettingKeys.friction));
    _currentStandStillDelay = _updateStandStillDelay(_currentStandStillDelay,vehicleSettings.getValue(VehicleSettingKeys.standstill_delay), wasStandingStill, _speed==0);

    vector = new Vector.fromAngleRadians(r,_speed);
    //position += vector;
    var collisionCorrection = vector;
    bool collide = false;
    //check collisions
    for(GameObject g in game.gameobjects){
      if(g == this) continue;
      /*if(g is Ball){
        Ball b = g;
        b.vector += new Vector.fromAngleRadians(this.r,10.0);
        print("hit");
        continue;
      }*/

      CollisionResult r = createPolygonOnActualLocation().collision(g.createPolygonOnActualLocation(), vector);

      if (r.willIntersect) {
        if(g is Ball){
          Ball b = g;
          b.onHit(this.r);
          continue;
        }
        else if(!g.onCollision(this)){
          collide = true;
          collisionCorrection += r.minimumTranslationVector;
        }
        //g.onCollision(this,polygonATranslation);
      }
    }
    if(collide) {
      if(_isCollided){
        double friction = vehicleSettings.getValue(VehicleSettingKeys.collision_force_after_collision);
        if(friction < _speed){
          _speed = _applyFriction(_speed, friction);
          vector = new Vector.fromAngleRadians(r,_speed);
        }
      }
      else{
        _speed = _applyFriction(_speed, vehicleSettings.getValue(VehicleSettingKeys.collision_force));
        vector = new Vector.fromAngleRadians(r,_speed);
      }
    }
    _isCollided = collide;
    position += vector + collisionCorrection;
  }

  bool onCollision(GameObject o){
    if(_speed != 0) _speed = -(_speed/2);
    /*
    _speed = -_speed/2;

    _acceleration = 0.0;
    _braking = 0.0;
    _steering = 0.0;
    */
    return false;
  }

  double _applyFriction(double V, double F){
    if(V > 0) V -= Math.min(V,F);
    else if(V < 0) V += Math.min(-V,F);
    return V;
  }
  double _applyAccelerationAndBrake(double V, double A, double R, double B, double MaxA, double MaxR, bool canStartFromZero, bool acc, bool brake){
    if(acc && brake){
      if(V>0) V -= B;
      else if(V<0) V += B;
    }else{
      if(V==0){
        if(canStartFromZero)
        {
          if (acc) V += A;
          if (brake) V -= R;
        }
      }
      else if(V>0){
        if(acc) V += A;
        if(brake) V -= Math.min(V,B);
      }
      else if(V<0){
        if(acc) V +=  Math.min(-V,B);
        if(brake) V -= R;
      }
    }
    if(V > MaxA) V = MaxA;
    if(V < -MaxR) V = -MaxR;
    return V;
  }
  int _updateStandStillDelay(int currentStandStillDelay, int standStillDelay, bool wasStandingStill, bool standingStill){
    if(!standingStill || !wasStandingStill) return standStillDelay;

    currentStandStillDelay -= 1;
    if(currentStandStillDelay < 0)
      currentStandStillDelay = 0;

    return currentStandStillDelay;
  }
  double _applySteering(double r, double S, Steer steering){
    switch(steering){
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