part of game.menu;

class MainMenu extends GameMenuScreen
{
  Map<GameMainMenuItem, GameMenuScreen> _sideMenus;
  MenuScreen _currentMenu = null;
  GameMenuController menu;
  MainMenu(this.menu){
    GameMenuScreen settingsMenu = menu.settings.debug.v ? new SettingsMenuDebug(menu) : new SettingsMenu(menu);
    _sideMenus = {
      GameMainMenuItem.Profile : new ProfileMenu(menu),
      GameMainMenuItem.Credits : new CreditsMenu(menu),
      GameMainMenuItem.Controls : new ControlsMenu(menu),
      GameMainMenuItem.Settings : settingsMenu,
    };
  }

  void show(GameMenuStatus status)
  {
    if(_currentMenu != null){
      _currentMenu.hide();
    }
    if(status is GameMainMenuStatus){
      GameMainMenuStatus mainMenuStatus = status;
      _currentMenu = _sideMenus[mainMenuStatus.mainMenuItem];
    }else{
      _currentMenu = _sideMenus[GameMainMenuItem.Profile];
    }
    _currentMenu.show(status);
    super.show(status);
  }

  Element setupFields()
  {
    Element el = super.setupFields();
    Element el_right = new DivElement();
    Element el_left = new DivElement();
    el_right.className = "rightPanel";
    el_left.className = "leftPanel";
    el.append(el_left);
    el.append(el_right);

    //el_left.append(createOpenMenuButtonWithIcon(menu,"Singleplayer","account_circle",menu.MENU_SINGLEPLAYER));
    el_left.append(createMenuButtonWithIcon("Random race","play_arrow",(Event e){
      menu.showMenu(new GameInputMenuStatus("Random race", menu.gameBuilder.newRandomGame(), (GameOutput result){
        menu.showMenu(new GameOutputMenuStatus("Race results", result));
      }));
    }));
    el_left.append(createOpenMenuButtonWithIcon(menu,"Single race","play_arrow",menu.MENU_SINGLERACE));
    if(menu.settings.debug.v) el_left.append(createOpenMenuButtonWithIcon(menu,"Soccer","play_arrow",menu.MENU_SOCCER));
    //el_left.append(createOpenMenuButtonWithIcon(menu,"Story mode","table_chart",menu.MENU_MAIN));
    el_left.append(createOpenMenuButtonWithIcon(menu,"Profile","account_circle",menu.MENU_PROFILE));
  /*
    el_left.append(createMenuButtonWithIcon("Result","play_arrow",(Event e){
      var a = new GameOutput();
      var p1 = new GamePlayerResult(new GameSettingsPlayer.asAiPlayer(3,"player1",VehicleType.Car));
      p1.position = 1;
      a.playerResults.add(p1);
      p1 = new GamePlayerResult(new GameSettingsPlayer.asAiPlayer(2,"player2",VehicleType.Truck));
      p1.position = 2;
      a.playerResults.add(p1);
      p1 = new GamePlayerResult(new GameSettingsPlayer.asHumanPlayer("playerUser",VehicleType.Formula));
      p1.position = 3;
      a.playerResults.add(p1);
      p1 = new GamePlayerResult(new GameSettingsPlayer.asAiPlayer(4,"player3",VehicleType.Car));
      p1.position = 4;
      a.playerResults.add(p1);
      p1 = new GamePlayerResult(new GameSettingsPlayer.asAiPlayer(6,"player5",VehicleType.Car));
      p1.position = 5;
      a.playerResults.add(p1);
      menu.showMenu(new GameOutputMenuStatus("Race results", a));
    }));
    */

    if(menu.settings.debug.v) el_left.append(createMenuButtonWithIcon("Soccer random","play_arrow",(Event e){
      menu.showMenu(new GameInputMenuStatus("Soccer", menu.gameBuilder.newRandomSoccerGame(), (GameOutput result){
        menu.showMenu(new GameOutputMenuStatus("Game results", result));
      }));
    }));

    if(menu.settings.debug.v) el_left.append(createOpenMenuButtonWithIcon(menu,"Settings","settings",menu.MENU_SETTINGS));
    el_left.append(createOpenMenuButtonWithIcon(menu,"Controls","videogame_asset",menu.MENU_CONTROLS));
    //el_left.append(createOpenMenuButtonWithIcon(menu,"Credits","info",menu.MENU_CREDITS));

    for(GameMainMenuItem menuItem in _sideMenus.keys){
      _sideMenus[menuItem].init();
      el_right.append(_sideMenus[menuItem].element);
    }

    closebutton = false;
    backbutton = false;

    return el;
  }
}

