part of game.menu;

enum GameDisplayType {Webgl3d, Webgl2d}

class PlayGameMenu extends GameMenuScreen{
  GameMenuController menu;
  PlayGameMenu(this.menu) : super("Play game");

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

  void startGame(GameInput gameSettings, OnGameFinished onFinished, [GameDisplayType displayType = GameDisplayType.Webgl3d]){
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