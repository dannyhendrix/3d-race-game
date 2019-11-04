part of uihelper;
class UiButtonToggleIcon extends UiButtonIcon{
  bool toggled = false;
  String _iconIdOn;
  String _iconIdOff;
  UiButtonToggleIcon(String iconIdOn, this._iconIdOff, OnButtonClick onClick) : super(iconIdOn,onClick){
    _iconIdOn = iconIdOn;
  }
  UiButtonToggleIcon.fromInjection() : super.fromInjection();
  void setToggled(bool value){
    if(toggled == value) return;
    _toggle();
    _onClick();
  }
  void _toggle(){
    toggled = !toggled;
    _setToggledIcon();
  }
  bool _onButtonClick(Event e){
    _toggle();
    return super._onButtonClick(e);
  }
  void _setToggledIcon(){
    changeIcon(toggled ? _iconIdOff : _iconIdOn);
  }
  void changeIconToggle(String iconIdOn, String iconIdOff){
    _iconIdOn = iconIdOn;
    _iconIdOff= iconIdOff;
    _setToggledIcon();
  }
}