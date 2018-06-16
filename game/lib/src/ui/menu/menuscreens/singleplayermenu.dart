part of game.menu;
/*
class SingleplayerMenu extends GameMenuScreen{
  GameMenuController menu;
  GameBuilder _gameBuilder;

  SingleplayerMenu(this.menu) : super("Singleplayer"){
    _gameBuilder = new GameBuilder(menu.settings);
  }

  Element setupFields()
  {
    Element el = super.setupFields();
    el.append(createMenuButtonWithIcon("Random race","play_arrow",(Event e){
      menu.showPlayGameMenu(_gameBuilder.newRandomGame());
    }));
    el.append(createOpenMenuButtonWithIcon(menu,"Single race","play_arrow",menu.MENU_SINGLERACE));
    el.append(createOpenMenuButtonWithIcon(menu,"Story mode","table_chart",menu.MENU_MAIN));
    /*
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
*/
    closebutton = false;

    //add(createOpenMenuButton("Options",TeamxMenuController.MENU_OPTION));
    return el;
  }
}*/