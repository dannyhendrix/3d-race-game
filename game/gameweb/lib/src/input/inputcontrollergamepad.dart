part of game.input;
/*
class GamePadButtonState {
  bool pressed = false;
  double value = 0;
}

class GamepadState {
  Gamepad gamepad;
  Map<Control, bool> buttonState = {Control.None: false, Control.Accelerate: false, Control.Brake: false, Control.SteerLeft: false, Control.SteerRight: false};
  GamepadState(this.gamepad);
}
*/

class InputControllerGamepad {
  Map<int, Gamepad> _gamepads = {};
  int activePad = -1;

  InputControllerGamepad() {
    window.addEventListener("gamepadconnected", (e) => _connecthandler(e));
    window.addEventListener("gamepaddisconnected", (e) => _disconnecthandler(e));
  }

  void update(PlayerControlState controlState) {
    _scangamepads();
    _updateButtons(controlState);
  }

  void _connecthandler(GamepadEvent e) {
    var pad = e.gamepad;
    _gamepads[pad.index] = pad;
  }

  void _disconnecthandler(GamepadEvent e) {
    _gamepads.remove(e.gamepad.index);
  }

  void _scangamepads() {
    var pads = window.navigator.getGamepads();
    for (var i = 0; i < pads.length; i++) {
      var pad = pads[i];
      if (pad == null) continue;
      _gamepads[pad.index] = pad;
    }
  }

  Control _buttonToControl(int control) {
    switch (control) {
      case 0:
        return Control.Accelerate;
      case 7:
        return Control.Accelerate;
      case 1:
        return Control.Brake;
      case 6:
        return Control.Brake;
      case 14:
        return Control.SteerLeft;
      case 15:
        return Control.SteerRight;
    }
    return Control.None;
  }

  void _updateButtons(PlayerControlState controlState) {
    for (int k = 0; k < _gamepads.length; k++) {
      if (activePad != -1 && activePad != k) continue;
      var pad = _gamepads[k];
      for (int i = 0; i < pad.buttons.length; i++) {
        var button = pad.buttons[i];
        var btn = _buttonToControl(i);
        if (btn == Control.None) continue;
        if (button.pressed && activePad == -1) activePad = k;
        controlState.buttonStates[btn].pressed = button.pressed;
        controlState.buttonStates[btn].value = button.value;
      }
      for (int i = 0; i < pad.axes.length; i++) {}
    }
  }
}
