part of game.menu;

class SingleplayerMenu extends GameMenuScreen{
  SingleplayerMenu(GameMenuController m) : super(m, "Singleplayer");

  Element setupFields()
  {
    Element el = super.setupFields();
    el.append(createMenuButtonWithIcon("Random race","play_arrow",(Event e){
      GameSettings settings = createGameSettingsTemp();
      settings.level = createGameLevelTemp();
      settings.level.path.laps = 1;
      menu.showPlayGameMenu(settings);
    }));
    el.append(createOpenMenuButtonWithIcon("Single race","play_arrow",menu.MENU_MAIN));
    el.append(createOpenMenuButtonWithIcon("Story mode","table_chart",menu.MENU_MAIN));
    el.append(createMenuButtonWithIcon("Result","play_arrow",(Event e){
      var a = new GameResult();
      var p1 = new GamePlayerResult();
      p1.name = "Player1";
      p1.position = 1;
      a.playerResults.add(p1);
      var p2 = new GamePlayerResult();
      p2.name = "Player2";
      p2.position = 2;
      a.playerResults.add(p2);
      menu.showGameResultMenu(a);
    }));

    closebutton = false;

    //add(createOpenMenuButton("Options",TeamxMenuController.MENU_OPTION));
    return el;
  }

  GameLevel createGameLevelTemp(){
    GameLevelLoader levelLoader = new GameLevelLoader();
    return levelLoader.loadLevelJson(leveljson);
  }
  GameSettings createGameSettingsTemp(){
    GameSettings settings = new GameSettings();
    GameSettingsTeam team = new GameSettingsTeam.withTheme(new VehicleTheme.withColor(VehicleThemeColor.Yellow,VehicleThemeColor.Blue));
    team.players.add(new GameSettingsPlayer.asHumanPlayer("Player1",VehicleType.Truck,TrailerType.TruckTrailer));
    settings.teams.add(team);

    team = new GameSettingsTeam.withTheme(new VehicleTheme.withColor(VehicleThemeColor.Red,VehicleThemeColor.White));
    team.players.add(new GameSettingsPlayer.asAiPlayer("CPU1",VehicleType.Truck,TrailerType.TruckTrailer));
    settings.teams.add(team);

    team = new GameSettingsTeam.withTheme(new VehicleTheme.withColor(VehicleThemeColor.Blue,VehicleThemeColor.Blue));
    team.players.add(new GameSettingsPlayer.asAiPlayer("CPU2",VehicleType.Truck,TrailerType.TruckTrailer));
    settings.teams.add(team);

    team = new GameSettingsTeam.withTheme(new VehicleTheme.withColor(VehicleThemeColor.Pink,VehicleThemeColor.White));
    team.players.add(new GameSettingsPlayer.asAiPlayer("CPU3",VehicleType.Car,TrailerType.Caravan));
    settings.teams.add(team);

    team = new GameSettingsTeam.withTheme(new VehicleTheme.withColor(VehicleThemeColor.Black,VehicleThemeColor.Green));
    team.players.add(new GameSettingsPlayer.asAiPlayer("CPU4",VehicleType.Car,TrailerType.Caravan));
    settings.teams.add(team);

    team = new GameSettingsTeam.withTheme(new VehicleTheme.withColor(VehicleThemeColor.Orange,VehicleThemeColor.Orange));
    team.players.add(new GameSettingsPlayer.asAiPlayer("CPU5",VehicleType.Car,TrailerType.Caravan));
    settings.teams.add(team);

    return settings;
  }
}