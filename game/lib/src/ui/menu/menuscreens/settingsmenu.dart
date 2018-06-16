part of game.menu;

class SettingsMenu extends GameMenuScreen
{
  bool showStoreIncookie = true;
  GameMenuController menu;

  Map<String, SettingInput> settingElementMapping = {};

  SettingsMenu(this.menu) : super(menu.MENU_OPTION);

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
  
  void hide()
  {
    storeSettings();
    super.hide();
  }

  void show(GameMenuStatus status)
  {
    loadSettings();
    super.show(status);
  }
}
