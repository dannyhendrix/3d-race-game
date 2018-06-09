part of game.gamemode;

//TODO: load levels from JSON
Map leveljson = {"w":2400,"d":1280,"walls":[{"x":1200.0,"z":8.0,"r":0.0,"w":2400.0,"d":16.0,"h":16.0},{"x":1200.0,"z":1272.0,"r":0.0,"w":480.0,"d":16.0,"h":16.0},{"x":8.0,"z":768.0,"r":0.0,"w":16.0,"d":960.0,"h":16.0},{"x":2392.0,"z":640.0,"r":0.0,"w":16.0,"d":1248.0,"h":16.0},{"x":1184.0,"z":344.0,"r":0.0,"w":1280.0,"d":16.0,"h":16.0},{"x":1856.0,"z":576.0,"r":1.4,"w":480.0,"d":16.0,"h":16.0},{"x":512.0,"z":576.0,"r":1.7,"w":480.0,"d":16.0,"h":16.0},{"x":1168.0,"z":992.0,"r":1.6,"w":560.0,"d":16.0,"h":16.0}],"staticobjects":[{"id":0,"x":70.0,"z":80.0,"r":0.5},{"id":0,"x":40.0,"z":150.0,"r":0.2},{"id":0,"x":30.0,"z":250.0,"r":0.8},{"id":0,"x":780.0,"z":500.0,"r":0.2},{"id":0,"x":850.0,"z":450.0,"r":0.1},{"id":0,"x":680.0,"z":510.0,"r":0.0},{"id":0,"x":1500.0,"z":500.0,"r":0.0},{"id":0,"x":1600.0,"z":560.0,"r":0.2},{"id":0,"x":1650.0,"z":800.0,"r":0.6},{"id":0,"x":1400.0,"z":1200.0,"r":0.2},{"id":0,"x":1260.0,"z":1100.0,"r":0.5}],"path":{"circular":true,"laps":5,"checkpoints":[{"x":944.0,"z":176.0,"radius":160.0},{"x":2080.0,"z":160.0,"radius":160.0},{"x":2080.0,"z":1024.0,"radius":160.0},{"x":1520.0,"z":1008.0,"radius":160.0},{"x":1200.0,"z":496.0,"radius":96.0},{"x":752.0,"z":960.0,"radius":160.0},{"x":288.0,"z":1040.0,"radius":160.0},{"x":304.0,"z":576.0,"radius":160.0},{"x":304.0,"z":176.0,"radius":160.0}]}};

class GameBuilder{
  GameSettings _settings;
  AiPlayerProfileDatabase _aiplayers;
  Math.Random _random = new Math.Random();

  GameBuilder(this._settings){
    _aiplayers = new AiPlayerProfileDatabase();
  }

  GameInput newRandomGame(){
    List<PlayerProfile> players = _aiplayers.getRandom(3);
    VehicleType vehicle = VehicleType.values[_random.nextInt(VehicleType.values.length)];
    TrailerType trailer = TrailerType.values[_random.nextInt(TrailerType.values.length)];

    GameInput settings = _createSimpleGameSettings(players, vehicle, trailer);
    //TODO: select random map
    settings.level = _createGameLevelTemp();
    settings.level.path.laps = 1;
    return settings;
  }

  GameInput newGame(List<PlayerProfile> players, VehicleType vehicle, TrailerType trailer, String gameLevel, int laps){
    GameInput settings = _createSimpleGameSettings(players, vehicle, trailer);
    //TODO: select random map
    settings.level = _createGameLevelTemp();
    settings.level.path.laps = laps;
    return settings;
  }
  GameInput newGameRandomPlayers(int numberOfPlayers, VehicleType vehicle, TrailerType trailer, String gameLevel, int laps){
    GameInput settings = _createSimpleGameSettings(_aiplayers.getRandom(numberOfPlayers), vehicle, trailer);
    //TODO: select random map
    settings.level = _createGameLevelTemp();
    settings.level.path.laps = laps;
    return settings;
  }

  GameLevel _createGameLevelTemp(){
    GameLevelLoader levelLoader = new GameLevelLoader();
    return levelLoader.loadLevelJson(leveljson);
  }
  GameInput _createSimpleGameSettings(List<PlayerProfile> players, VehicleType vehicle, TrailerType trailer){
    GameInput settings = new GameInput();
    GameSettingsTeam team = new GameSettingsTeam.withTheme(new VehicleTheme.withColor(_settings.user_color1.v,_settings.user_color2.v));
    team.players.add(new GameSettingsPlayer.asHumanPlayer(_settings.user_name.v,vehicle,trailer));
    settings.teams.add(team);

    for(PlayerProfile player in players){
      team = new GameSettingsTeam.withTheme(player.theme);
      team.players.add(new GameSettingsPlayer.asAiPlayer(player.name,vehicle,trailer));
      settings.teams.add(team);
    }

    return settings;
  }
}