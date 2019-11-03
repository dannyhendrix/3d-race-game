part of uihelper;
typedef void ToggleOnClick(bool isToggled);
class UiButtonToggleIcon extends UiButton{
  bool toggled = false;
  String _icon_default;
  String _icon_toggled;
  UiIcon _el_icon;
  ToggleOnClick _onClick;
  UiButtonToggleIcon(this._icon_default, this._icon_toggled, this._onClick);
  void setToggled(bool value){
    if(toggled == value) return;
    _toggle();
    _onClick(toggled);
  }
  void _toggle(){
    toggled = !toggled;
    _el_icon.changeIcon(toggled ? _icon_toggled : _icon_default);
  }
  Element createElement(){
    _el_icon = UiIcon(_icon_default);
    var btn = _createButton();
    btn.append(_el_icon.element);
    return btn;
  }
  void _onButtonClick(Event e){
    e.preventDefault(); _toggle(); _onClick(toggled);
  }
}