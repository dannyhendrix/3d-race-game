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
  PlayerControlState controlState = PlayerControlState();

  Player(this.player, this.theme, this.pathProgress);
}

class PlayerControlButtonState {
  bool pressed = false;
  double value = 0;
}

class PlayerControlState {
  Map<Control, PlayerControlButtonState> buttonStates = {
    Control.Accelerate: PlayerControlButtonState(),
    Control.Brake: PlayerControlButtonState(),
    Control.SteerLeft: PlayerControlButtonState(),
    Control.SteerRight: PlayerControlButtonState(),
  };
}
