part of game.definitions;

enum ControlKeyType {Default, Alternative, UserDefined}
enum GameDashboardTheme {Default, Red, Green, Blue}
enum GameDisplayType {Webgl3d, Webgl2d}
enum GameRenderType {Colors, Textures}
enum GameCameraType {BirdView, VehicleView}

class GameSettings extends SettingsStoredInCookie
{
  static Map<int,Control> _defaultKeys = {
    /*
    Base
    */
    65 : Control.SteerLeft,//a
    68 : Control.SteerRight,//d
    87 : Control.Accelerate,//w
    83 : Control.Brake,//s

    /*
    Shared
    */
    /*
    9 : GameControls.CONTROL_SWITCH_CARACTER,//tab
    27 : GameControls.CONTROL_MENU,//esc
    36 : GameControls.CONTROL_CAMERA_HOME,//home
    107 : GameControls.CONTROL_ZOOM_IN,//+
    109 : GameControls.CONTROL_ZOOM_OUT,//-
    */
  };
  static Map<int,Control> _defaultUserKeys = {
    /*
    Base
    */
    37 : Control.SteerLeft,//left
    39 : Control.SteerRight,//right
    38 : Control.Accelerate,//up
    40 : Control.Brake,//down

    65 : Control.SteerLeft,//a
    68 : Control.SteerRight,//d
    87 : Control.Accelerate,//w
    83 : Control.Brake,//s

    /*
    Shared
    */
    /*
    9 : GameControls.CONTROL_SWITCH_CARACTER,//tab
    27 : GameControls.CONTROL_MENU,//esc
    36 : GameControls.CONTROL_CAMERA_HOME,//home
    107 : GameControls.CONTROL_ZOOM_IN,//+
    109 : GameControls.CONTROL_ZOOM_OUT,//-
    */
  };
  static Map<int,Control> _alternativeKeys = {
    /*
    Base
    */
    37 : Control.SteerLeft,//left
    39 : Control.SteerRight,//right
    38 : Control.Accelerate,//up
    40 : Control.Brake,//down

    /*
    Shared
    */
    /*
    9 : GameControls.CONTROL_SWITCH_CARACTER,//tab
    27 : GameControls.CONTROL_MENU,//esc
    36 : GameControls.CONTROL_CAMERA_HOME,//home
    107 : GameControls.CONTROL_ZOOM_IN,//+
    109 : GameControls.CONTROL_ZOOM_OUT,//-
    */
  };

  GameSetting<bool> debug = new GameSetting("debug", false);

  GameSettingWithEnum<ControlKeyType> client_controlkeytype = new GameSettingWithEnum("client_controlkeytype", ControlKeyType.UserDefined, ControlKeyType.values, "Controls keys");
  GameSettingWithEnum<GameDashboardTheme> client_theme = new GameSettingWithEnum("client_theme", GameDashboardTheme.Default, GameDashboardTheme.values, "Theme");
  GameSetting<bool> client_showUIControls = new GameSetting("client_showuicontrols", false, "Show control buttons");

  GameSetting<String> editor_location = new GameSetting("editor_location", "leveleditor.html", "Location to leveleditor");
  GameSetting<bool> levels_allowJsonInput = new GameSetting("levels_location", true, "Allow users to enter json level in level selection");
  GameSetting<String> levels_location = new GameSetting("levels_location", null, "Location to levels");
  GameSetting<String> levels_definition_location = new GameSetting("levels_definition_location", null, "Location to levels file");

  GameSetting<bool> client_showStoreInCookie = new GameSetting("client_showStoreInCookie", true, "Show cookie message");
  GameSetting<bool> client_changeCSSWithThemeChange = new GameSetting("client_changeccswiththemechange", true, "Match theme with user colors");
  GameSettingWithEnum<GameDisplayType> client_displayType = new GameSettingWithEnum("client_displaytype", GameDisplayType.Webgl3d, GameDisplayType.values, "Display type");
  GameSettingWithEnum<GameRenderType> client_renderType = new GameSettingWithEnum("client_rendertype", GameRenderType.Colors, GameRenderType.values, "Render type");
  GameSettingWithEnum<GameCameraType> client_cameraType = new GameSettingWithEnum("client_cameratype", GameCameraType.BirdView, GameCameraType.values, "Camera type");
  // list of key ids to movement
  IntMapSettings<Control> client_keys = new IntMapSettings("client_keys", _defaultUserKeys, "Keys");

  //GameSetting<Map> progress_locked = new GameSetting("progress_locked", {  }, "Progress");
  GameSetting<String> user_name = new GameSetting("user_name", "Player1", "Username");
  GameSetting<int> user_wins = new GameSetting("user_wins", 0, "Races won");
  GameSetting<int> user_races = new GameSetting("user_races", 0, "Races");
  GameSettingWithEnum<VehicleThemeColor> user_color1 = new GameSettingWithEnum("user_color1", VehicleThemeColor.Blue, VehicleThemeColor.values, "Theme color 1");
  GameSettingWithEnum<VehicleThemeColor> user_color2 = new GameSettingWithEnum("user_color2", VehicleThemeColor.Yellow, VehicleThemeColor.values, "Theme color 2");
  GameSetting<int> user_texture = new GameSetting("user_texture", 0, "Theme texture");


  GameSettings([bool autoload = true])
  {
    if(autoload)
      loadFromCookie();
  }

  List<GameSetting> getStoredSettingsKeys()
  {
    return [user_name,user_wins,user_races,user_color1,user_color2,user_texture,client_theme, client_controlkeytype,client_displayType,client_renderType,client_cameraType, debug];
  }

  List<GameSetting> getMenuSettings()
  {
    if(debug.v == true)
      return [user_name, user_color1, user_color2,user_texture, client_theme, client_changeCSSWithThemeChange,client_showUIControls, client_displayType,client_renderType,client_cameraType, storeInCookie, debug];
    return [storeInCookie];
  }

  Map<int,Control> getDefaultKeys() => _defaultKeys;
  Map<int,Control> getAlternativeKeys() => _alternativeKeys;
}

