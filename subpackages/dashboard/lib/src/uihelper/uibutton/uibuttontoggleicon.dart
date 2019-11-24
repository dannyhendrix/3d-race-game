part of uihelper;

class UiButtonToggleIcon extends UiButtonIcon {
  bool toggled = false;
  String _iconIdOn;
  String _iconIdOff;
  UiButtonToggleIcon(ILifetime lifetime) : super(lifetime);
  void setToggled(bool value) {
    if (toggled == value) return;
    _toggle();
    _onClick();
  }

  void _toggle() {
    toggled = !toggled;
    _setToggledIcon();
  }

  bool _onButtonClick(Event e) {
    _toggle();
    return super._onButtonClick(e);
  }

  void _setToggledIcon() {
    changeIcon(toggled ? _iconIdOff : _iconIdOn);
  }

  void changeIconToggle(String iconIdOn, String iconIdOff) {
    _iconIdOn = iconIdOn;
    _iconIdOff = iconIdOff;
    _setToggledIcon();
  }
}

class UiButtonToggleIconText extends UiButtonIconText {
  bool toggled = false;
  String _iconIdOn;
  String _iconIdOff;
  UiButtonToggleIconText(ILifetime lifetime) : super(lifetime);
  void setToggled(bool value) {
    if (toggled == value) return;
    _toggle();
    _onClick();
  }

  void _toggle() {
    toggled = !toggled;
    _setToggledIcon();
  }

  bool _onButtonClick(Event e) {
    _toggle();
    return super._onButtonClick(e);
  }

  void _setToggledIcon() {
    changeIcon(toggled ? _iconIdOff : _iconIdOn);
  }

  void changeIconToggle(String iconIdOn, String iconIdOff) {
    _iconIdOn = iconIdOn;
    _iconIdOff = iconIdOff;
    _setToggledIcon();
  }
}
