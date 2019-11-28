part of game.menu;

class SettingsMenuDebug extends GameMenuMainScreen
{
  ILifetime _lifetime;
  GameSettings _settings;
  UiPanelForm _form;
  UiButtonText _btnResetCookie;
  bool showStoreIncookie = true;
  Map<String, UiInput> settingElementMapping = {};

  SettingsMenuDebug(ILifetime lifetime) : super(lifetime, GameMainMenuPage.SettingsDebug){
    _lifetime = lifetime;
    _settings = lifetime.resolve();
    _form = lifetime.resolve();
    _btnResetCookie = lifetime.resolve();
  }

  @override
  void build()
  {
    super.build();
    for(var s in _settings.getMenuSettings()){
      var input = createSettingElement(s);
      _form.append(input);
      settingElementMapping[s.k] = input;
    }
    _form.append(_btnResetCookie);
    _btnResetCookie..changeText("Reset cookie")..setOnClick((){
      _settings.emptyCookie();
    });
    append(_form);
  }
  
  UiElement createSettingElement(GameSetting s)
  {
    if(s is GameSettingWithAllowedValues) return _lifetime.resolve<UiInputOption>()..changeLabel(s.description)..setOptions(s.allowedValues);
    else if(s is GameSettingWithEnum) return _lifetime.resolve<UiInputOption>()..changeLabel(s.description)..setOptions(s.allowedValues)..objectToString = s.convertTo;
    else if(s.v is int) return _lifetime.resolve<UiInputInt>()..changeLabel(s.description);
    else if(s.v is double) return _lifetime.resolve<UiInputDouble>()..changeLabel(s.description);
    else if(s.v is bool) return _lifetime.resolve<UiInputBoolIcon>()..changeLabel(s.description);
    else return _lifetime.resolve<UiInputText>()..changeLabel(s.description);
  }
  
  void _storeSettings()
  {
    for(GameSetting s in _settings.getMenuSettings())
    {
      var gs = settingElementMapping[s.k];
      s.v = gs.getValue();
    }
    _settings.saveToCookie();
  }
  
  void _loadSettings()
  {
    for(GameSetting s in _settings.getMenuSettings())
      settingElementMapping[s.k].setValue(s.v);
  }

  @override
  void enterMenu(GameMenuStatus status){
    _loadSettings();
    super.enterMenu(status);
  }
  @override
  void exitMenu()
  {
    _storeSettings();
    super.exitMenu();
  }
}

