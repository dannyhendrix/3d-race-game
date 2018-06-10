part of game.menu;

class MainMenu extends GameMenuScreen
{
  GameMenuController menu;
  GameBuilder _gameBuilder;
  MainMenu(this.menu) : super("Main menu"){
    _gameBuilder = new GameBuilder(menu.settings);
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
      menu.showPlayGameMenu(_gameBuilder.newRandomGame());
    }));
    el_left.append(createOpenMenuButtonWithIcon(menu,"Single race","play_arrow",menu.MENU_SINGLERACE));
    el_left.append(createOpenMenuButtonWithIcon(menu,"Story mode","table_chart",menu.MENU_MAIN));
    /*
    el_left.append(createMenuButtonWithIcon("Result","play_arrow",(Event e){
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
*/
    //el_left.append(createOpenMenuButtonWithIcon(menu,"Settings","settings",menu.MENU_OPTION));
    el_left.append(createOpenMenuButtonWithIcon(menu,"Controls","videogame_asset",menu.MENU_CONTROLS));
    el_left.append(createOpenMenuButtonWithIcon(menu,"Credits","info",menu.MENU_CREDITS));

    GameMenuScreen profileMenu = new ProfileSideMenu(menu);
    profileMenu.init();
    profileMenu.show();
    el_right.append(profileMenu.element);

    closebutton = false;
    backbutton = false;

    return el;
  }
}

