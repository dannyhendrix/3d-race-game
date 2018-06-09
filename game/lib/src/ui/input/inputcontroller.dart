part of  game.input;

typedef bool OnControlChange(Control control, bool active);

class InputController
{
  OnControlChange onControlChange = (Control control, bool active){};
  GameSettings settings;

  InputController(this.settings);

  Control getKeyFromSettings(int index)
  {
    return _getCurrentLookup()[index];
  }

  Map<int, Control> _getCurrentLookup() {
    switch(settings.client_controlkeytype.v)
    {
      case ControlKeyType.Default:
        return settings.getDefaultKeys();
        break;
      case ControlKeyType.Alternative:
        return settings.getAlternativeKeys();
        break;
      default:
        return settings.client_keys.v;
        break;
    }
  }

  int getFirstKeyFromControl(int control)
  {
    Map<int, Control> lookup = _getCurrentLookup();
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
    int key = e.keyCode;
    bool down = e.type == "keydown";//event.KEYDOWN

    if(onControlChange(getKey(key), down))
      e.preventDefault();
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