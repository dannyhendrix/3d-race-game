part of game.gamemode;

class PlayerProfile {
  int id;
  String name = "CPU";
  VehicleTheme theme = new VehicleTheme.withDefaults();

  PlayerProfile(this.id, this.name, this.theme);
  PlayerProfile.withColors(this.id, this.name, VehicleThemeColor c1, VehicleThemeColor c2) : theme = new VehicleTheme.withColor(c1,c2);
}

enum AiPlayersPredefined {Simple1, Simple2, Simple3, Medium1, Medium2, Medium3, Hard1, Hard2, Hard3}

class AiPlayerProfileDatabase{
  Map<int, PlayerProfile> _aiplayers = {};

  Math.Random random = new Math.Random();
  static int _idCounter = 0;
  void _addNewPlayer(String name,VehicleThemeColor c1, VehicleThemeColor c2){
    int id = _idCounter++;
    _aiplayers[id] = new PlayerProfile.withColors(id,name,c1,c2);
  }

  AiPlayerProfileDatabase(){
    _addNewPlayer("Dom",VehicleThemeColor.Black, VehicleThemeColor.Blue);
    _addNewPlayer("Sally",VehicleThemeColor.Green, VehicleThemeColor.Green);
    _addNewPlayer("Hank",VehicleThemeColor.White, VehicleThemeColor.White);
    _addNewPlayer("Mel",VehicleThemeColor.Pink, VehicleThemeColor.Pink);
    _addNewPlayer("Luke",VehicleThemeColor.Blue, VehicleThemeColor.Blue);
    _addNewPlayer("Jen",VehicleThemeColor.Blue, VehicleThemeColor.White);
    _addNewPlayer("Sam",VehicleThemeColor.Orange, VehicleThemeColor.Orange);
    _addNewPlayer("Jo",VehicleThemeColor.Yellow, VehicleThemeColor.Yellow);
    _addNewPlayer("Z",VehicleThemeColor.Red, VehicleThemeColor.White);
    _addNewPlayer("Ann",VehicleThemeColor.Green, VehicleThemeColor.Gray);
    _addNewPlayer("Seb",VehicleThemeColor.Red, VehicleThemeColor.Red);
    _addNewPlayer("Flora",VehicleThemeColor.White, VehicleThemeColor.Red);
    _addNewPlayer("Ric",VehicleThemeColor.White, VehicleThemeColor.Blue);
    _addNewPlayer("Uri",VehicleThemeColor.White, VehicleThemeColor.Green);
    _addNewPlayer("Cal",VehicleThemeColor.White, VehicleThemeColor.Black);
  }

  List<PlayerProfile> getRandom(int amount){
    List<PlayerProfile> results = [];
    List<int> indexes = [];
    for(int index in _aiplayers.keys){
      indexes.add(index);
    }
    for(int i = 0; i < amount; i++){
      int mapindex = indexes.removeAt(random.nextInt(indexes.length));
      results.add(_aiplayers[mapindex]);
    }
    return results;
  }
  PlayerProfile getPredefined(AiPlayersPredefined player){
    throw new Exception("Predefined players are not configured");
  }
  PlayerProfile getPlayerById(int playerId){
    return _aiplayers[playerId];
  }
}