part of game.menu;

enum GameMenuPage {Main, SingleGame, Soccer, Game, GameResult, Loading}
enum GameMainMenuPage {Profile, Settings, SettingsDebug, Credits, Controls}

//enum GameMenuItem {Main, SingleGame, Soccer, Game, GameResult, Loading, Controls, Settings, Credits, Profile, None}

class GameMenuStatus{
  GameMenuPage page;
  GameMenuStatus(this.page);
}

class GameMenuMainStatus extends GameMenuStatus{
  GameMainMenuPage sidepage;
  GameMenuMainStatus(this.sidepage) : super(GameMenuPage.Main);
}

class GameOutputMenuStatus extends GameMenuStatus{
  GameOutput gameOutput;
  GameOutputMenuStatus(String title, this.gameOutput) : super(GameMenuPage.GameResult);
}

class GameInputMenuStatus extends GameMenuStatus{
  GameInput gameInput;
  OnGameFinished onFinished;
  GameDisplayType displayType;
  GameInputMenuStatus(String title, this.gameInput, this.onFinished, [this.displayType = null]) : super(GameMenuPage.Game);
}

class GameMenuController extends UiPanel{
  final MENU_LOADING = new GameMenuStatus(GameMenuPage.Loading);
  final MENU_MAIN = new GameMenuMainStatus(GameMainMenuPage.Profile);

  final MENU_CONTROLS = new GameMenuMainStatus(GameMainMenuPage.Controls);
  final MENU_SETTINGS = new GameMenuMainStatus(GameMainMenuPage.SettingsDebug);
  final MENU_CREDITS = new GameMenuMainStatus(GameMainMenuPage.Credits);

  final MENU_PROFILE = new GameMenuMainStatus(GameMainMenuPage.Profile);
  final MENU_SINGLERACE = new GameMenuStatus(GameMenuPage.SingleGame);
  //final MENU_GAME = new GameMenuStatusSingle(GameMenuItem.Game);
  //final MENU_GAMERESULT = new GameMenuStatusSingle(GameMenuItem.GameResult);
  final MENU_SOCCER = new GameMenuStatus(GameMenuPage.Soccer);

  UiSwitchPanel content;
  UiPanel titleContent;
  UiButtonIcon btn_back;
  UiTitle txt_title;
  UiPanel el_credits;
  UiText el_creditsText;

  MenuHistory<GameMenuStatus> _history;
  Map<GameMenuPage, GameMenuScreen> _menus = {};
  GameSettings settings;
  GameBuilder gameBuilder;

  GameMenuController(ILifetime lifetime) : super(lifetime){
    settings = lifetime.resolve();
    gameBuilder = lifetime.resolve();

    _history = lifetime.resolve();
    btn_back = lifetime.resolve();
    txt_title = lifetime.resolve();
    content = lifetime.resolve();
    titleContent = lifetime.resolve();
    el_credits = lifetime.resolve();
    el_creditsText = lifetime.resolve();

    var menus = lifetime.resolveList<GameMenuScreen>();
    for(var menu in menus){
      _menus[menu.pageId] = menu;
    }
  }
  void build()
  {
    setStyleId("menu_bg");
    content.setStyleId("menu_wrapper");

    // title
    txt_title.changeText("Menu");
    titleContent.append(txt_title);
    titleContent.append(btn_back);
    titleContent.setStyleId("menu_title");
    _createBackButton();

    append(titleContent);
    append(content);
    for(var menu in _menus.values){
      content.setTab(menu.pageId.index,menu);
      menu.attachToMenu(this);
      menu.hide();
    }
    el_creditsText.changeText("Created by Danny Hendrix");
    el_credits.append(el_creditsText);
    append(el_credits);
  }
  void showMenu(GameMenuStatus id){
    var current = _history.any() ? _history.current() : null;
    _showMenu(id,current, true);
  }
  void _showMenu(GameMenuStatus id, GameMenuStatus current, bool storeInHistory){
    if(current != null){
      _hideScreen(current);
    }
    _showScreen(id);
    if(storeInHistory) _history.goTo(id);
  }
  void _hideScreen(GameMenuStatus id){
    _menus[id.page].exitMenu();
    _menus[id.page].hide();
  }
  void _showScreen(GameMenuStatus id){
    var screen = _menus[id.page];
    txt_title.changeText(screen.title);
    btn_back.display(screen.showBack && _history.any());
    screen.enterMenu(id);
    content.showTab(id.page.index);
  }
  void _createBackButton()
  {
    btn_back.changeIcon("navigate_before");
    btn_back.setOnClick((){
      var prev = _history.goBack();
      if(_history.any())
        _showMenu(_history.current(),prev, false);
    });
    btn_back.setStyleId("menu_back");
  }
}

class GameLoader{
  ResourceManager resourceManager;
  LevelManager levelManager;
  GameLoader(ILifetime lifetime){
    resourceManager = lifetime.resolve();
    levelManager = lifetime.resolve();
  }
  void preLoad(Function onComplete){
    resourceManager.loadResources(GameConstants.resources, (){
      _loadLevelsInLevelManager(levelManager);
      onComplete();
    });
  }
  void _loadLevelsInLevelManager(LevelManager levelManager){
    for(var key in resourceManager.getLevelKeys()){
      levelManager.loadLevel(key, resourceManager.getLevel(key));
    }
  }
}

