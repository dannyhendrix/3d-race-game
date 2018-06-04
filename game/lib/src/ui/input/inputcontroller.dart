part of  game.input;

typedef void OnControlChange(Control control, bool active);

class InputController
{
  static Map<int,Control> defaultKeys = {
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
  static Map<int,Control> defaultUserKeys = {
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
  static Map<int,Control> alternativeKeys = {
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

  OnControlChange onControlChange = (Control control, bool active){};
  GeneralSettings settings;

  InputController(this.settings);

  void handleControl(Control key, [bool down = true])
  {
    onControlChange(key, down);
  }

  Control getKeyFromSettings(int index)
  {
    switch(settings.client_controlkeytype.v)
    {
      case ControlKeyType.Default:
        return defaultKeys[index];
      case ControlKeyType.Alternative:
        return alternativeKeys[index];
      default:
        return settings.client_keys.v[index];
    }
  }

  int getFirstKeyFromControl(int control)
  {
    Map<int, int> lookup;
    switch(settings.client_controlkeytype.v)
    {
      case ControlKeyType.Default:
        lookup = defaultKeys;
        break;
      case ControlKeyType.Alternative:
        lookup = alternativeKeys;
        break;
      default:
        lookup = settings.client_keys.v;
        break;
    }
    for(int key in lookup.keys)
    {
      if(lookup[key] == control)
        return key;
    }
    return KeycodeToString.undefined;
  }

  Control getKey(int index)
  {
    Control k = getKeyFromSettings(index);
    return (k == null)? Control.None : k;
  }

  Control getMouseKey(int index)
  {
    //mouse_button_left: -1;
    //mouse_button_middle: -2;
    //mouse_button_right: -3;
    index = -(index+1);
    Control k = getKeyFromSettings(index);
    return (k == null)? Control.None : k;
  }

  void handleKey(KeyboardEvent e)
  {
    e.preventDefault();
    int key = e.keyCode;
    bool down = e.type == "keydown";//event.KEYDOWN

    handleControl(getKey(key), down);
  }

  void mouseDown(MouseEvent e)
  {
  }

  void mouseUp(MouseEvent e)
  {
  }

  void windowResize(int w, int h)
  {
  }

  void mouseOver(MouseEvent e)
  {
  }

  void mouseOut(MouseEvent e)
  {
  }

  void mouseMove(MouseEvent e)
  {
  }


  void mouseMenu(MouseEvent e)
  {
    e.preventDefault();
  }
}