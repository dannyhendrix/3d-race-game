part of game.menu;

class MainMenu extends GameMenuScreen
{
  GameSettings _settings;
  GameBuilder _gameBuilder;

  MenuButton _btnRandomRace;
  MenuButton _btnSingleRace;
  MenuButton _btnProfile;
  MenuButton _btnSettings;
  MenuButton _btnCredits;
  MenuButton _btnControls;
  MenuButton _btnSoccerRandom;
  MenuButton _btnSoccer;
  UiSwitchPanel _subpageview;
  UiPanel _panelLeft;
  UiPanel _panelRight;

  Map<GameMainMenuPage, GameMenuMainScreen> _menus = {};

  MainMenu(ILifetime lifetime) : super(lifetime, GameMenuPage.Main){
    _settings = lifetime.resolve();
    _gameBuilder = lifetime.resolve();

    _btnRandomRace = lifetime.resolve();
    _btnSingleRace = lifetime.resolve();
    _btnProfile = lifetime.resolve();
    _btnSettings = lifetime.resolve();
    _btnCredits = lifetime.resolve();
    _btnControls = lifetime.resolve();
    _btnSoccerRandom = lifetime.resolve();
    _btnSoccer = lifetime.resolve();
    _subpageview = lifetime.resolve();
    _panelLeft = lifetime.resolve();
    _panelRight = lifetime.resolve();


    pageId = GameMenuPage.Main;
    showClose = false;
    showBack = false;
    title = "Main menu";

    var menus = lifetime.resolveList<GameMenuMainScreen>();
    for(var menu in menus){
      _menus[menu.mainPageId] = menu;
    }
  }

  @override
  void build(){
    super.build();

    _panelLeft.addStyle("leftPanel");
    _panelRight..addStyle("rightPanel");
    append(_panelLeft);
    append(_panelRight);

    _panelLeft.append(_btnRandomRace);
    _panelLeft.append(_btnSingleRace);
    _panelLeft.append(_btnProfile);
    if(_settings.debug.v) _panelLeft.append(_btnSoccerRandom);
    if(_settings.debug.v) _panelLeft.append(_btnSoccer);
    if(_settings.debug.v) _panelLeft.append(_btnSettings);
    if(_settings.debug.v) _panelLeft.append(_btnCredits);
    _panelLeft.append(_btnControls);

    _btnRandomRace..changeText("Random race")..changeIcon("play_arrow")..setOnClick((){
      _menu.showMenu(new GameInputMenuStatus("Random race", _gameBuilder.newRandomGame(), (GameOutput result){
        _menu.showMenu(new GameOutputMenuStatus("Race results", result));
      }));
    });
    _btnSoccerRandom..changeText("Random soccer")..changeIcon("play_arrow")..setOnClick((){
      _menu.showMenu(new GameInputMenuStatus("Soccer", _gameBuilder.newRandomSoccerGame(), (GameOutput result){
        _menu.showMenu(new GameOutputMenuStatus("Race results", result));
      }));
    });
    _btnSingleRace..changeText("Single race")..changeIcon("play_arrow")..setOnClick((){
      _menu.showMenu(_menu.MENU_SINGLERACE);
    });
    _btnSoccer..changeText("Soccer")..changeIcon("play_arrow")..setOnClick((){
      _menu.showMenu(_menu.MENU_SOCCER);
    });
    _btnProfile..changeText("Profile")..changeIcon("account_circle")..setOnClick((){
      _menu.showMenu(_menu.MENU_PROFILE);
    });
    _btnSettings..changeText("Settings")..changeIcon("settings")..setOnClick((){
      _menu.showMenu(_menu.MENU_SETTINGS);
    });
    _btnControls..changeText("Controls")..changeIcon("videogame_asset")..setOnClick((){
      _menu.showMenu(_menu.MENU_CONTROLS);
    });
    _btnCredits..changeText("Credits")..changeIcon("info")..setOnClick((){
      _menu.showMenu(_menu.MENU_CREDITS);
    });

    for(var menu in _menus.values){
      _subpageview.setTab(menu.mainPageId.index,menu);
      menu.attachToMenu(_menu);
      menu.hide();
    }
    _panelRight.append(_subpageview);
  }

  @override
  void enterMenu(GameMenuStatus status){
    super.enterMenu(status);
    if(status is GameMenuMainStatus){
      var currentIndex = _subpageview.current;
      if(currentIndex != -1)
      {
        var current = GameMainMenuPage.values[currentIndex];
        _menus[current].exitMenu();
      }
      _menus[status.sidepage].enterMenu(status);
      _subpageview.showTab(status.sidepage.index);
    }
  }

  void _registerTabs(){
    //_subpageview.setTab("", GameMainMenuPage.Profile.index, content)
  }
}

