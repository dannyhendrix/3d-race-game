part of game.gamemode;

class GameBuilder{
  GeneralSettings _settings;
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