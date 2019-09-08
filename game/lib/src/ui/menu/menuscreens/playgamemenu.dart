part of game.menu;


class GameInputMenuStatus extends GameMenuStatus{
  GameInput gameInput;
  OnGameFinished onFinished;
  GameDisplayType displayType;
  GameInputMenuStatus(String title, this.gameInput, this.onFinished, [this.displayType = null]) : super(title, GameMenuItem.Game, true);
}

class PlayGameMenu extends GameMenuScreen{
  GameMenuController menu;
  PlayGameMenu(this.menu);

  Element gameContent;
  Element el_game;
  WebglGame game;

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
  void hide(){
    if(game != null){
      game.stop();
      if(el_game !=null) el_game.remove();
    }


    super.hide();
  }

  void _startGame(GameInput gameSettings, OnGameFinished onFinished, [GameDisplayType displayType = null]){
    if(displayType == null){
      displayType = menu.settings.client_displayType.v;
    }
    var enableTextures = menu.settings.client_renderType.v == GameRenderType.Textures;
    game = displayType == GameDisplayType.Webgl2d ? new WebglGame2d(menu.settings) : new WebglGame3d(menu.settings, enableTextures);

    game.onGameFinished = (result){
      el_game.remove();
      game = null;
      onFinished(result);
    };
    el_game = game.initAndCreateDom(gameSettings, menu.settings);
    gameContent.append(el_game);
    //element.append(createButton("Pause",(e)=>game.pause()));
    game.start();
  }
}