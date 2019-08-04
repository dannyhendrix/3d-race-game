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
  LevelManager levelManager;
  AiPlayerProfileDatabase aiPlayerProfileDatabase;

  GameMenuController(this.settings) : super()
  {
    levelManager = new LevelManager();
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
    levelManager.preLoadLevels(onComplete);
  }

  @override
  Element setupFields()
  {
    Element el = new DivElement();
    el.id = "menu_bg";
    Element ell = new DivElement();
    ell.id = "menu_wrapper";

    ell.append(createTitleElement(createBackButton(),createCloseButton()));
    //ell.append(createCookieElement());

    for(GameMenuItem menuItem in menus.keys){
      menus[menuItem].init();
      ell.append(menus[menuItem].element);
    }
    el.append(ell);

    Element el_credits = new DivElement();
    el_credits.text = "Created by Danny Hendrix";
    el.append(el_credits);

    return el;
  }
/*
  Element createCookieElement()
  {
    DivElement el = new DivElement();
    el.id = "menu_store_cookie";

    Element chk_cookie = new SpanElement();
    chk_cookie.className = "material-icons";

    var changeStoreCookie = (bool store)
    {
      settings.storeInCookie.v = store;
      if(store)
      {
        el.classes.add("selected");
        chk_cookie.text = "check_box_outline";
        settings.saveToCookie();
      }
      else
      {
        el.classes.remove("selected");
        chk_cookie.text = "check_box_outline_blank";
      }
    };
    el.onClick.listen((Event e){ changeStoreCookie(!settings.storeInCookie.v);});
    changeStoreCookie(settings.storeInCookie.v);

    SpanElement txt_cookie = new SpanElement();
    txt_cookie.text = "Store settings in cookie.";

    el.append(chk_cookie);
    el.append(txt_cookie);
    el_storeCookie = el;
    return el;
  }
  */
  Element createBackButton()
  {
    ButtonElement btn = super.createBackButton();
    btn.text = "";
    btn.append(UIHelper.createIcon("navigate_before"));
    return btn;
  }

  void showMenu(GameMenuStatus m, [bool storeInHistory = true])
  {
    super.showMenu(m,storeInHistory);
    if(_currentMenu != null){
      _currentMenu.hide();
    }

    _currentMenu = menus[m.menuItem];
    _currentMenu.show(m);

    /*
    if(menus[m].showStoreIncookie && settings.client_showStoreInCookie.v)
    {
      el_storeCookie.style.display = "block";
      menus[m].element.classes.add("withcookie");
    }
    else
    {
      el_storeCookie.style.display = "none";
      menus[m].element.classes.remove("withcookie");
    }
    */
  }

  void hideMenu()
  {
    super.hideMenu();
  }
}

