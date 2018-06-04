part of micromachines;

class GameSettingsInvalidException implements Exception{
  final String msg;
  GameSettingsInvalidException(this.msg);
  String toString() {
    return "Exception: Invalid game settings: $msg";
  }
}

class GameInput{
  List<GameSettingsTeam> teams = [];
  GameLevel level;

  void validate(){
    if(level == null) throw new GameSettingsInvalidException("Level is null");
    level.validate();
    teams.forEach((p)=>p.validate());
  }
}

class GameSettingsTeam{
  List<GameSettingsPlayer> players = [];
  VehicleTheme vehicleTheme = new VehicleTheme.withDefaults();

  GameSettingsTeam();
  GameSettingsTeam.withTheme(this.vehicleTheme);

  void validate(){
    if(players.length == 0) throw new GameSettingsInvalidException("Team has no players");
    players.forEach((p)=>p.validate());
    if(vehicleTheme == null) throw new GameSettingsInvalidException("Team.vehicleTheme is null");
  }
}
class GameSettingsPlayer{
  String name = "Player";
  int playerId = 0;
  bool isHuman = false;
  VehicleType vehicle = VehicleType.Car;
  TrailerType trailer = TrailerType.None;

  GameSettingsPlayer();
  GameSettingsPlayer.asHumanPlayer(this.name,this.vehicle,[this.trailer = TrailerType.None]) : isHuman = true;
  GameSettingsPlayer.asAiPlayer(this.name,this.vehicle,[this.trailer = TrailerType.None]) : isHuman = false;

  void validate(){

  }
}

class GameResult{
  GameResultTime gameTime= new GameResultTime();
  List<GamePlayerResult> playerResults = [];
  String toString() => "${playerResults.map((p)=>p.toString()).join("\n")}$gameTime";
}
class GamePlayerResult{
  GameResultTime raceTime = new GameResultTime();
  int position = -1;
  String name = "";
  int playerId = 0;// allows to relate the player to the player in the gameInput
  String toString() => "$position $name($playerId) $raceTime";
}
class GameResultTime{
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  int milliseconds = 0;
  String toString() => "$hours.$minutes.$seconds:$milliseconds";
}