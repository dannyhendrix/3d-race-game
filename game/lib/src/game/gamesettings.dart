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
  int playerId = 0;
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

class GameResult{
  GameResultTime gameTime;
  List<GamePlayerResult> playerResults;
  String toString() => "${playerResults.map((p)=>p.toString()).join("\n")}$gameTime";
}
class GamePlayerResult{
  GameResultTime raceTime;
  int position;
  String name;
  int playerId;// allows to relate the player to the player in the gameInput
  String toString() => "$position $name($playerId) $raceTime";
}
class GameResultTime{
  int hours;
  int minutes;
  int seconds;
  int milliseconds;
  String toString() => "$hours.$minutes.$seconds:$milliseconds";
}