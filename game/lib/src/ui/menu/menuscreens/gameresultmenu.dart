part of game.menu;

class GameResultMenu extends GameMenuScreen{
  GameMenuController menu;
  GameResultMenu(this.menu);

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

  void show(GameMenuStatus status)
  {
    if(status is GameOutputMenuStatus)
    {
      GameOutputMenuStatus resultStatus = status;
      _setGameResult(resultStatus.gameOutput);
    }
    super.show(status);
  }

  void _setGameResult(GameOutput gameresult){
    gameResultContent.text = gameresult.toString();
  }
}