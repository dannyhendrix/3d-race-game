part of game.menu;

class OptionMenu extends GameMenuScreen
{
  bool showStoreIncookie = true;

  Map<String, SettingInput> settingElementMapping = {};
  
  OptionMenu(GameMenuController m) : super(m, "Settings");

  Element setupFields()
  {
    Element el = super.setupFields();
    return el;
  }

  void storeSettings()
  {
    menu.settings.saveToCookie();
  }
  
  void loadSettings()
  {
  }
  
  void hide([int effect = 0])
  {
    storeSettings();
    super.hide(effect);
  }

  void show([int effect = 0])
  {
    loadSettings();
    super.show(effect);
  }
}

