part of game.menu;

enum GameMenuItem {Main, SingleGame, Soccer, Game, GameResult, Loading}
enum GameMainMenuItem {Controls, Settings, Credits, Profile}

class GameMenuStatus extends MenuStatus{
  GameMenuItem menuItem;
  GameMenuStatus(String title, this.menuItem, [bool showBack]) : super(title, showBack, false);
}

class GameMainMenuStatus extends GameMenuStatus{
  GameMainMenuItem mainMenuItem;
  GameMainMenuStatus(String title, this.mainMenuItem, [bool showBack]) : super(title, GameMenuItem.Main, showBack);
}

class GameOutputMenuStatus extends GameMenuStatus{
  GameOutput gameOutput;
  GameOutputMenuStatus(String title, this.gameOutput) : super(title, GameMenuItem.GameResult, false);
}

class GameMenuController extends Menu<GameMenuStatus>
{
  final MENU_LOADING = new GameMenuStatus("Loading", GameMenuItem.Loading,false);
  final MENU_MAIN = new GameMainMenuStatus("Main menu", GameMainMenuItem.Profile,false);

  final MENU_CONTROLS = new GameMainMenuStatus("Controls", GameMainMenuItem.Controls, true);
  final MENU_SETTINGS = new GameMainMenuStatus("Settings", GameMainMenuItem.Settings, true);
  final MENU_CREDITS = new GameMainMenuStatus("Credits", GameMainMenuItem.Credits, true);

  final MENU_PROFILE = new GameMainMenuStatus("Profile", GameMainMenuItem.Profile, true);
  final MENU_SINGLERACE = new GameMenuStatus("Single race", GameMenuItem.SingleGame, true);
  final MENU_GAME = new GameMenuStatus("Game", GameMenuItem.Game, false);
  final MENU_GAMERESULT = new GameMenuStatus("Game result", GameMenuItem.GameResult, false);
  final MENU_SOCCER = new GameMenuStatus("Soccer", GameMenuItem.Soccer, true);

  Element el_storeCookie;
  GameResultMenu menu_gameresult;
  PlayGameMenu menu_playgame;
  GameSettings settings;
  Map<GameMenuItem, GameMenuScreen> menus;
  MenuScreen _currentMenu = null;

  GameBuilder gameBuilder;
  ResourceManager resourceManager = new ResourceManager();
  LevelManager levelManager = new LevelManager();
  AiPlayerProfileDatabase aiPlayerProfileDatabase;

  GameMenuController(this.settings) : super()
  {
    aiPlayerProfileDatabase = new AiPlayerProfileDatabase();
    gameBuilder = new GameBuilder(settings, levelManager, aiPlayerProfileDatabase);
    menus = {
      GameMenuItem.Main : new MainMenu(this),
      GameMenuItem.SingleGame : new SingleRaceMenu(this),
      GameMenuItem.Soccer : new SoccerGameMenu(this),
      GameMenuItem.Game : new PlayGameMenu(this),
      GameMenuItem.GameResult : new GameResultMenu(this),
      GameMenuItem.Loading : new LoadingMenu(this),
    };
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

  @override
  UiElement setupFields()
  {
    var el = new UiPanel();
    el.element.id = "menu_bg";
    var ell = new UiPanel();
    ell.element.id = "menu_wrapper";

    ell.append(createTitleElement(btn_back, btn_close));

    for(GameMenuItem menuItem in menus.keys){
      menus[menuItem].init();
      ell.append(menus[menuItem].element);
    }
    el.append(ell);

    var el_credits = new UiPanel();
    var el_creditsText = new UiText("Created by Danny Hendrix");
    el_credits.append(el_creditsText);
    el.append(el_credits);

    return el;
  }

  void showMenu(GameMenuStatus m, [bool storeInHistory = true])
  {
    super.showMenu(m,storeInHistory);
    if(_currentMenu != null){
      _currentMenu.hide();
    }
    _currentMenu = menus[m.menuItem];
    _currentMenu.show(m);
  }

  void hideMenu()
  {
    super.hideMenu();
  }
}

