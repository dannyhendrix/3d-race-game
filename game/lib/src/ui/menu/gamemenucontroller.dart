part of game.menu;

class GameMenuController extends Menu
{
  final MENU_MAIN = 0;
  final MENU_MESSAGE = 1;

  final MENU_CONTROLS = 10;
  final MENU_OPTION = 11;
  final MENU_CREDITS = 12;

  final MENU_PROFILE = 20;

  final MENU_SINGLEPLAYER = 30;
  final MENU_GAMEPLAY = 31;
  final MENU_GAMERESULT = 32;
  final MENU_SINGLERACE = 33;
  final MENU_MULTIPLAYER = 40;

  Element el_storeCookie;
  GameResultMenu menu_gameresult;
  PlayGameMenu menu_playgame;
  GameSettings settings;

  GameMenuController(this.settings) : super()
  {

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

    for(int k in menus.keys)
    {
      menus[k].init();
      ell.append(menus[k].element);
    }

    el.append(ell);
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
  /*
   *  Element createButtonWithIcon(String icon, Function callback)
  {
    //<i class="material-icons">menu</i>
    Element btn = super.createButton("", callback);
    Element iel = new Element.tag("i");
    iel.className = "material-icons";
    iel.text = icon.toLowerCase();
    btn.append(iel);
    return btn;
  }
   */
  Element createBackButton()
  {
    ButtonElement btn = super.createBackButton();
    btn.text = "";
    Element iel = new Element.tag("i");
    iel.className = "material-icons";
    iel.text = "navigate_before";
    btn.append(iel);
    return btn;
  }
/*
  @override
  void init()
  {
    super.init();
    DivElement logo = new DivElement();
    logo.id="logo";
    document.body.append(logo);
    document.body.append(document.querySelector("#share"));
    _setupMenus();
  }
  */
  
  Map<int,GameMenuScreen> getMenus()
  {
    menu_gameresult = new GameResultMenu(this);
    menu_playgame = new PlayGameMenu(this);
    return {
      MENU_MAIN : new MainMenu(this),
      MENU_CONTROLS: new ControlsMenu(this),
      MENU_CREDITS: new CreditsMenu(this),
      MENU_SINGLEPLAYER: new SingleplayerMenu(this),
      MENU_SINGLERACE: new SingleRaceMenu(this),
      MENU_GAMERESULT: menu_gameresult,
      MENU_GAMEPLAY: menu_playgame,
      /*MENU_CHARACTER: new CharacterMenu(this),
      MENU_LEVEL: new LevelMenu(this),
      MENU_CHARACTER : new CharacterMenu(this),*/
      MENU_OPTION : settings.debug.v ? new OptionMenuDebug(this) : new OptionMenu(this),
      /*MENU_LEVEL_MESSAGE : new LevelMessageMenu(this)*/
    };
  }

  void showMenu(int m, [int effect = 0, bool storeInHistory = true])
  {
    super.showMenu(m,effect,storeInHistory);
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

  void hideMenu([int effect = 0])
  {
    super.hideMenu(effect);
  }

  void showPlayGameMenu(GameInput settings, [int effect = 0, bool storeInHistory = true]){
    menu_playgame.startGame(settings,(GameOutput result){
      showGameResultMenu(result);
    });
    showMenu(MENU_GAMEPLAY,effect,storeInHistory);
  }

  void showGameResultMenu(GameOutput result, [int effect = 0, bool storeInHistory = true]){
    menu_gameresult.setGameResult(result);
    showMenu(MENU_GAMERESULT,effect,storeInHistory);
  }
}

