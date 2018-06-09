part of game.menu;

class GameResultMenu extends GameMenuScreen{
  GameMenuController menu;
  GameResultMenu(this.menu) : super("Game result");

  Element gameResultContent;

  Element setupFields()
  {
    Element el = super.setupFields();
    gameResultContent = new DivElement();

    el.append(gameResultContent);

    el.append(createOpenMenuButtonWithIcon(menu,"Continue","play_arrow",menu.MENU_MAIN));
    el.append(createOpenMenuButtonWithIcon(menu,"Main menu","menu",menu.MENU_MAIN));

    closebutton = false;
    backbutton = false;

    return el;
  }

  void setGameResult(GameOutput gameresult){
    gameResultContent.text = gameresult.toString();
  }
}