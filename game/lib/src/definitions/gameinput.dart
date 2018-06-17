part of game.definitions;

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
  int playerId;
  bool isHuman = false;
  VehicleType vehicle = VehicleType.Car;
  TrailerType trailer = TrailerType.None;

  GameSettingsPlayer();
  GameSettingsPlayer.asHumanPlayer(this.name,this.vehicle,[this.trailer = TrailerType.None]) : isHuman = true, playerId = -1;
  GameSettingsPlayer.asAiPlayer(this.playerId, this.name,this.vehicle,[this.trailer = TrailerType.None]) : isHuman = false;

  void validate(){

  }
}