part of game;

class HumanPlayer extends Player {
  HumanPlayer(GameSettingsPlayer player, VehicleTheme theme) : super(player, theme) {}

  void update() {}
}

class AiPlayerControl {
  VehicleControl _vehicleControl = new VehicleControl();
  void update(Game game, Vehicle vehicle, AiPlayer player) {
    if (player.pathProgress.finished) {
      vehicle.setSteer(Steer.Left);
      vehicle.setAccelarate(false);
      return;
    }
    if (game.state != GameStatus.Racing) return;

    if (vehicle.sensorCollision) {
      _vehicleControl.controlAvoidance(vehicle);
    } else {
      if (game.gamelevelType == GameLevelType.Checkpoint) {
        var target = game.level.trackPoint(player.trackProgress.currentIndex);
        if (vehicle.position.distanceToThis(target.vector) < target.width / 2) player.trackProgress.next();
        _vehicleControl.controlToTarget(vehicle, target.vector);
      }
    }
  }
}

class AiPlayer extends Player {
  TrackProgress trackProgress;
  AiPlayerControl _control = new AiPlayerControl();
  AiPlayer(GameSettingsPlayer player, VehicleTheme theme) : super(player, theme) {}
  void init(Game game, Vehicle v, GameLevelPath path) {
    super.init(game, v, path);
    trackProgress = new TrackProgress(game.level.trackLength());
  }

  void update() {
    _control.update(_game, vehicle, this);
  }
}

abstract class Player {
  Game _game;
  Vehicle vehicle;
  PathProgress pathProgress;
  GameSettingsPlayer player;
  VehicleTheme theme;

  bool _isSteeringLeft = false;
  bool _isSteeringRight = false;
  bool _isAccelarating = false;
  bool _isBreaking = false;
  VehicleControl _vehicleControl = new VehicleControl();

  Player(this.player, this.theme);

  bool get finished => pathProgress.finished;

  void init(Game game, Vehicle v, GameLevelPath path) {
    _game = game;
    vehicle = v;
    if (_game.gamelevelType == GameLevelType.Checkpoint)
      pathProgress = new PathProgressCheckpoint(path.checkpoints.length, path.laps, path.circular);
    else
      pathProgress = new PathProgressScore();
  }

  void update();
  void onControl(Control control, bool active) => _vehicleControl.onControl(control, active, this, vehicle);
}

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
}
