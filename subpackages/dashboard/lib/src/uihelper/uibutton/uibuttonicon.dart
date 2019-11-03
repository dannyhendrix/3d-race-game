part of uihelper;
class UiButtonIcon extends UiButton{
  String _icon_default;
  OnButtonClick _onClick;
  UiButtonIcon(this._icon_default, this._onClick);

  Element createElement(){
    var el_icon = UiIcon(_icon_default);
    var btn = _createButton();
    btn.classes.add("buttonIcon");
    btn.append(el_icon.element);
    return btn;
  }
  void _onButtonClick(Event e){
    e.preventDefault();
    _onClick();
  }
}