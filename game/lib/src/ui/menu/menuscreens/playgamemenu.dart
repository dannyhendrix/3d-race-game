part of game.menu;

enum GameDisplayType {Webgl3d, Webgl2d}

class GameInputMenuStatus extends GameMenuStatus{
  GameInput gameInput;
  OnGameFinished onFinished;
  GameDisplayType displayType;
  GameInputMenuStatus(String title, this.gameInput, this.onFinished, [this.displayType = GameDisplayType.Webgl3d]) : super(title, GameMenuItem.Game, false);
}

class PlayGameMenu extends GameMenuScreen{
  GameMenuController menu;
  PlayGameMenu(this.menu);

  Element gameContent;

  Element setupFields()
  {
    Element el = super.setupFields();

    gameContent = new DivElement();
    gameContent.id = "gamewrapper";
    el.append(gameContent);

    closebutton = false;
    backbutton = false;

    return el;
  }

  void show(GameMenuStatus status)
  {
    if(status is GameInputMenuStatus)
    {
      GameInputMenuStatus inputStatus = status;
      _startGame(inputStatus.gameInput, inputStatus.onFinished, inputStatus.displayType);
    }
    super.show(status);
  }

  void _startGame(GameInput gameSettings, OnGameFinished onFinished, [GameDisplayType displayType = GameDisplayType.Webgl3d]){
    WebglGame game = displayType == GameDisplayType.Webgl2d ? new WebglGame2d(menu.settings) : new WebglGame3d(menu.settings);
    Element element;
    game.onGameFinished = (result){
      element.remove();
      game = null;
      onFinished(result);
    };
    element = game.initAndCreateDom(gameSettings, menu.settings);
    gameContent.append(element);
    //element.append(createButton("Pause",(e)=>game.pause()));
    game.start();
  }
}