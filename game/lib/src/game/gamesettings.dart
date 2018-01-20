part of micromachines;

class GameSettingsInvalidException implements Exception{
  final String msg;
  GameSettingsInvalidException(this.msg);
  String toString() {
    return "Exception: Invalid game settings: $msg";
  }
}

class GameSettings{
  List<GameSettingsPlayer> players = new List<GameSettingsPlayer>();
  GameLevel level;

  void validate(){
    if(level == null) throw new GameSettingsInvalidException("Level is null");
    level.validate();
    players.forEach((p)=>p.validate());
  }
}

class GameSettingsPlayer{
  String name = "Player";
  bool isHuman = false;
  VehicleType vehicle = VehicleType.Car;
  TrailerType trailer = TrailerType.None;
  VehicleTheme vehicleTheme = new VehicleTheme.withDefaults();

  GameSettingsPlayer();
  GameSettingsPlayer.asHumanPlayer(this.name, this.vehicleTheme,this.vehicle,[this.trailer = TrailerType.None]) : isHuman = true;
  GameSettingsPlayer.asAiPlayer(this.name, this.vehicleTheme,this.vehicle,[this.trailer = TrailerType.None]) : isHuman = false;

  void validate(){
    if(vehicleTheme == null) throw new GameSettingsInvalidException("Player.vehicleTheme is null");
  }
}