part of game.ui;

enum ControlKeyType {Default, Alternative, UserDefined}
enum GameDashboardTheme {Default, Red, Green, Blue}

class GeneralSettings extends SettingsStoredInCookie with GameSettings
{
  GameSettingWithEnum<ControlKeyType> client_controlkeytype = new GameSettingWithEnum("client_controlkeytype", ControlKeyType.Default, ControlKeyType.values, "Controls keys");
  GameSettingWithEnum<GameDashboardTheme> client_theme = new GameSettingWithEnum("client_theme", GameDashboardTheme.Default, GameDashboardTheme.values, "Theme");

  GameSetting<String> levels_location = new GameSetting("levels_location", null, "Location to levels");
  GameSetting<String> levels_definition_location = new GameSetting("levels_definition_location", null, "Location to levels file");

  GameSetting<bool> client_showStoreInCookie = new GameSetting("client_enablemouseaiming", true, "Enable mouse aiming");

  // list of key ids to movement
  IntMapSettings<int> client_keys = new IntMapSettings("client_keys", InputController.defaultUserKeys, "Keys");

  //GameSetting<Map> progress_locked = new GameSetting("progress_locked", {  }, "Progress");
  GameSetting<String> user_name = new GameSetting("user_name", "Player1", "Username");
  GameSetting<int> user_wins = new GameSetting("user_wins", 0, "Races won");
  GameSetting<int> user_races = new GameSetting("user_races", 0, "Races");
  GameSettingWithEnum<VehicleThemeColor> user_color1 = new GameSettingWithEnum("user_color1", VehicleThemeColor.Blue, VehicleThemeColor.values, "Theme color 1");
  GameSettingWithEnum<VehicleThemeColor> user_color2 = new GameSettingWithEnum("user_color2", VehicleThemeColor.Yellow, VehicleThemeColor.values, "Theme color 2");

  GeneralSettings([bool autoload = true])
  {
    if(autoload)
      loadFromCookie();
  }

  List<GameSetting> getStoredSettingsKeys()
  {
    return [user_characters,user_characters_name,progress_locked,client_theme, client_keys, client_controltype, client_controlkeytype,client_enablemouseaiming, camerapanning, camerascale, cameraborder, debug];
  }
  
  List<GameSetting> getMenuSettings()
  {
    if(debug.v == true)
      return [client_controltype, client_controlkeytype, client_enablemouseaiming, camerapanning, client_theme, cameraborder, camerascale, storeInCookie,debug];
    return [client_controltype, storeInCookie];
  }
}