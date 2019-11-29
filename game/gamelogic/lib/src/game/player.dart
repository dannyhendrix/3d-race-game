part of game;

class HumanPlayer extends Player {
  HumanPlayer(GameSettingsPlayer player, VehicleTheme theme, PathProgress pathProgress) : super(player, theme, pathProgress) {}
}

class AiPlayer extends Player {
  TrackProgress trackProgress;
  AiPlayer(GameSettingsPlayer player, VehicleTheme theme, PathProgress pathProgress, this.trackProgress) : super(player, theme, pathProgress) {}
}

abstract class Player {
  int position = 0;
  Vehicle vehicle;
  PathProgress pathProgress;
  GameSettingsPlayer player;
  VehicleTheme theme;

  bool _isSteeringLeft = false;
  bool _isSteeringRight = false;
  bool _isAccelarating = false;
  bool _isBreaking = false;
  VehicleControl _vehicleControl = new VehicleControl();

  Player(this.player, this.theme, this.pathProgress);
}
