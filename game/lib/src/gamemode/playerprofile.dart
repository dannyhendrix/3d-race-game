part of game.gamemode;

class PlayerProfile {
  String name = "CPU";
  VehicleTheme theme = new VehicleTheme.withDefaults();

  PlayerProfile(this.name, this.theme);
  PlayerProfile.withColors(this.name, VehicleThemeColor c1, VehicleThemeColor c2) : theme = new VehicleTheme.withColor(c1,c2);
}

enum AiPlayersPredefined {Simple1, Simple2, Simple3, Medium1, Medium2, Medium3, Hard1, Hard2, Hard3}

class AiPlayerProfileDatabase{

  List<PlayerProfile> _aiplayers = [
    new PlayerProfile.withColors("Dom",VehicleThemeColor.Black, VehicleThemeColor.Blue),
    new PlayerProfile.withColors("Sally",VehicleThemeColor.Green, VehicleThemeColor.White),
    new PlayerProfile.withColors("Hank",VehicleThemeColor.White, VehicleThemeColor.White),
    new PlayerProfile.withColors("Mel",VehicleThemeColor.Pink, VehicleThemeColor.White),
    new PlayerProfile.withColors("Luke",VehicleThemeColor.Blue, VehicleThemeColor.Yellow),
    new PlayerProfile.withColors("Jen",VehicleThemeColor.Blue, VehicleThemeColor.Gray),
    new PlayerProfile.withColors("Sam",VehicleThemeColor.Orange, VehicleThemeColor.Black),
    new PlayerProfile.withColors("Jo",VehicleThemeColor.Yellow, VehicleThemeColor.Blue),
    new PlayerProfile.withColors("Z",VehicleThemeColor.Red, VehicleThemeColor.Gray),
  ];

  Math.Random random = new Math.Random();
  List<PlayerProfile> getRandom(int amount){
    List<PlayerProfile> results = [];
    List<int> indexes = [];
    for(int i =0; i < _aiplayers.length; i++){
      indexes.add(i);
    }
    for(int i = 0; i < amount; i++){
      int mapindex = indexes.removeAt(random.nextInt(indexes.length));
      results.add(_aiplayers[mapindex]);
    }
    return results;
  }
  PlayerProfile getPredefined(AiPlayersPredefined player){}
}