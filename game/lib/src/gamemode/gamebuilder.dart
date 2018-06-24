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

    GameInput settings = _createSimpleGameSettings(players, vehicle, trailer);
    settings.level = _levelManager.loadedLevels[randomLevelId];
    settings.level.path.laps = 1;
    return settings;
  }

  GameInput newGame(List<PlayerProfile> players, VehicleType vehicle, TrailerType trailer, int levelId, int laps){
    GameInput settings = _createSimpleGameSettings(players, vehicle, trailer);
    //TODO: select random map
    settings.level = _levelManager.loadedLevels[levelId];
    settings.level.path.laps = laps;
    return settings;
  }
  GameInput newGameRandomPlayers(int numberOfPlayers, VehicleType vehicle, TrailerType trailer, GameLevel level, int laps){
    GameInput settings = _createSimpleGameSettings(_aiplayers.getRandom(numberOfPlayers), vehicle, trailer);
    //TODO: select random map
    settings.level = level;//_levelManager.loadedLevels[levelId];
    settings.level.path.laps = laps;
    return settings;
  }

  GameInput _createSimpleGameSettings(List<PlayerProfile> players, VehicleType vehicle, TrailerType trailer){
    GameInput settings = new GameInput();
    GameSettingsTeam team = new GameSettingsTeam.withTheme(new VehicleTheme.withColor(_settings.user_color1.v,_settings.user_color2.v));
    team.players.add(new GameSettingsPlayer.asHumanPlayer(_settings.user_name.v,vehicle,trailer));
    settings.teams.add(team);

    for(PlayerProfile player in players){
      team = new GameSettingsTeam.withTheme(player.theme);
      team.players.add(new GameSettingsPlayer.asAiPlayer(player.id,player.name,vehicle,trailer));
      settings.teams.add(team);
    }

    return settings;
  }
}