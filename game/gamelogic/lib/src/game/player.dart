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
