part of game.definitions;

class GameOutput{
  GameResultTime gameTime= new GameResultTime();
  List<GamePlayerResult> playerResults = [];
  String toString() => "${playerResults.map((p)=>p.toString()).join("\n")}$gameTime";
}
class GamePlayerResult{
  GameResultTime raceTime = new GameResultTime();
  int position = -1;
  GameSettingsPlayer player;
  GamePlayerResult(this.player);
  String toString() => "$position ${player.name} $raceTime";
}
class GameResultTime{
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  int milliseconds = 0;
  String toString() => "$hours.$minutes.$seconds:$milliseconds";
}