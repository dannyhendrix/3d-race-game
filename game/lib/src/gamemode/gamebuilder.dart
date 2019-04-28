part of game.gamemode;

class GameBuilder{
  GameSettings _settings;
  LevelManager _levelManager;
  AiPlayerProfileDatabase _aiplayers;
  Math.Random _random = new Math.Random();

  GameBuilder(this._settings, this._levelManager, this._aiplayers){

  }

  GameInput newRandomGame(){
    List<PlayerProfile> players = _aiplayers.getRandom(3);
    VehicleType vehicle = VehicleType.values[_random.nextInt(VehicleType.values.length)];
    TrailerType trailer = TrailerType.values[_random.nextInt(TrailerType.values.length)];

    List<int> levelIds = _levelManager.loadedLevels.keys.toList();
    int randomLevelId = levelIds[_random.nextInt(levelIds.length)];

    GameInput settings = _createSimpleGameSettings(players, -1, vehicle, trailer);
    settings.level = _levelManager.loadedLevels[randomLevelId];
    settings.level.path.laps = 1;
    return settings;
  }
  GameInput newRandomSoccerGame(){
    List<PlayerProfile> players = _aiplayers.getRandom(3);

    List<int> levelIds = _levelManager.loadedLevels.keys.toList();

    GameInput settings = _createSimpleGameSettings(players, 2, VehicleType.Formula, TrailerType.None);
    settings.level = _levelManager.loadedLevels[4];
    return settings;
  }
  GameInput newSoccerGame(int numberOfTeams, int playersPerTeam, VehicleType vehicle, TrailerType trailer, GameLevel level, int scorelimit){
    GameInput settings = _createSimpleGameSettings(_aiplayers.getRandom((playersPerTeam*numberOfTeams)-1), numberOfTeams, vehicle, trailer);

    settings.level = level;//_levelManager.loadedLevels[levelId];
    //settings.level.path.laps = laps;
    return settings;
  }

  GameInput newGame(List<PlayerProfile> players, VehicleType vehicle, TrailerType trailer, int levelId, int laps){
    GameInput settings = _createSimpleGameSettings(players, -1, vehicle, trailer);
    settings.level = _levelManager.loadedLevels[levelId];
    settings.level.path.laps = laps;
    return settings;
  }
  GameInput newGameRandomPlayers(int numberOfPlayers, VehicleType vehicle, TrailerType trailer, GameLevel level, int laps){
    GameInput settings = _createSimpleGameSettings(_aiplayers.getRandom(numberOfPlayers), -1, vehicle, trailer);
    settings.level = level;//_levelManager.loadedLevels[levelId];
    settings.level.path.laps = laps;
    return settings;
  }

  GameInput _createSimpleGameSettings(List<PlayerProfile> players, int teams, VehicleType vehicle, TrailerType trailer){
    GameInput settings = new GameInput();

    if(teams == -1) teams = players.length+1;
    if(teams > players.length+1) teams = players.length+1;

    settings.teams.add(new GameSettingsTeam.withTheme(new VehicleTheme.withColor(_settings.user_color1.v,_settings.user_color2.v)));
    for(int i = 0; i < teams-1; i++){
      settings.teams.add(new GameSettingsTeam.withTheme(players[i].theme));
    }

    settings.teams[0].players.add(new GameSettingsPlayer.asHumanPlayer(_settings.user_name.v,vehicle,trailer));

    var currTeam = 1;
    for(PlayerProfile player in players){
      if(currTeam >= teams) currTeam = 0;
      settings.teams[currTeam].players.add(new GameSettingsPlayer.asAiPlayer(player.id,player.name,vehicle,trailer));
      currTeam++;
    }

    return settings;
  }
}