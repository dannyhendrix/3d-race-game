part of game.menu;

class GameResultMenu extends GameMenuScreen{
  GameResultMenu(GameMenuController m) : super(m, "Game result");

  Element gameResultContent;

  Element setupFields()
  {
    Element el = super.setupFields();
    gameResultContent = new DivElement();

    el.append(gameResultContent);

    el.append(createOpenMenuButtonWithIcon("Continue","play_arrow",menu.MENU_MAIN));
    el.append(createOpenMenuButtonWithIcon("Main menu","menu",menu.MENU_MAIN));

    closebutton = false;
    backbutton = false;

    return el;
  }

  void setGameResult(GameResult gameresult){
    gameResultContent.text = gameresult.toString();
  }
}