part of game.menu;

class PlayGameMenu extends GameMenuScreen{
  UiPanel gameContent;
  Element el_game;
  WebglGame game;
  ILifetime _lifetime;
  ILifetime _gamelifetime;
  GameSettings _settings;


  PlayGameMenu(ILifetime lifetime) : super(lifetime, GameMenuPage.Game){
    _lifetime = lifetime;
    gameContent = lifetime.resolve();
    _settings = lifetime.resolve();
  }

  @override
  void build()
  {
    super.build();
    gameContent.setStyleId("gamewrapper");
    append(gameContent);

    showClose = false;
    showBack = false;
  }

  @override
  void enterMenu(GameMenuStatus status)
  {
    if(status is GameInputMenuStatus) _startGame(status.gameInput, status.onFinished, status.displayType);
    super.enterMenu(status);
  }
  @override
  void exitMenu(){
    if(game != null){
      game.stop();
      if(el_game !=null) el_game.remove();
      _gamelifetime = null;
    }
    super.exitMenu();
  }

  void _startGame(GameInput gameSettings, OnGameFinished onFinished, [GameDisplayType displayType = null]){
    if(displayType == null){
      displayType = _settings.client_displayType.v;
    }
    //var enableTextures = menu.settings.client_renderType.v == GameRenderType.Textures;
    _gamelifetime = _lifetime.startNewLifetimeScope();
    //TODO: move this switch to composition
    game = displayType == GameDisplayType.Webgl2d ? _gamelifetime.resolve<WebglGame3d>() : _gamelifetime.resolve<WebglGame3d>();

    game.onGameFinished = (result){
      el_game.remove();
      game = null;
      onFinished(result);
    };
    el_game = game.initAndCreateDom(gameSettings, _settings);
    gameContent.appendElement(el_game);
    //element.append(createButton("Pause",(e)=>game.pause()));
    game.start();
  }
}