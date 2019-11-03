part of uihelper;

typedef void OnButtonClick();

abstract class UIButton extends UiElement{
  Element _createButton()
  {
    var btn = new ButtonElement();
    btn.className = "button";
    btn.onClick.listen((MouseEvent e){ _onButtonClick(e); return false; });
    btn.onTouchStart.listen((TouchEvent e){ _onButtonClick(e); return false; });
    return btn;
  }
  Element _createIcon()
  {
    Element iel = new Element.tag("i");
    iel.className = "material-icons";
    return iel;
  }
  void _onButtonClick(Event e);
}

class UiIcon extends UiElement{
  String icon;
  UiIcon(this.icon);
  Element createElement() {
    Element iel = new Element.tag("i");
    iel.className = "material-icons";
    iel.text = icon;
    return iel;
  }

}

typedef void ToggleOnClick(bool isToggled);
class UIToggleIconButton extends UIButton{
  bool toggled = false;
  String _icon_default;
  String _icon_toggled;
  Element _el_icon;
  ToggleOnClick _onClick;
  UIToggleIconButton(this._icon_default, this._icon_toggled, this._onClick);
  void setToggled(bool value){
    if(toggled == value) return;
    _toggle();
    _onClick(toggled);
  }
  void _toggle(){
    toggled = !toggled;
    _el_icon.text = toggled ? _icon_toggled : _icon_default;
  }
  Element createElement(){
    _el_icon = _createIcon();
    _el_icon.text = _icon_default;
    var btn = _createButton();
    btn.append(_el_icon);
    return btn;
  }
  void _onButtonClick(Event e){
    e.preventDefault(); _toggle(); _onClick(toggled);
  }
}
class UIIconButton extends UIButton{
  String _icon_default;
  OnButtonClick _onClick;
  UIIconButton(this._icon_default, this._onClick);

  Element createElement(){
    var el_icon = _createIcon();
    el_icon.text = _icon_default;
    var btn = _createButton();
    btn.classes.add("buttonIcon");
    btn.append(el_icon);
    return btn;
  }
  void _onButtonClick(Event e){
    e.preventDefault();
    _onClick();
  }
}
class UiIconTextButton extends UIButton{
  String _icon_default;
  String _text;
  OnButtonClick _onClick;
  UiIconTextButton(this._text, this._icon_default, this._onClick);

  Element createElement(){
    var eltxt = new SpanElement();
    eltxt.text = _text;
    var el_icon = _createIcon();
    el_icon.text = _icon_default;
    var btn = _createButton();
    btn.classes.add("buttonIcon");
    btn.append(el_icon);
    btn.append(eltxt);
    return btn;
  }
  void _onButtonClick(Event e){
    e.preventDefault();
    _onClick();
  }
}
class UITextButton extends UIButton{
  String _text;
  OnButtonClick _onClick;
  UITextButton(this._text, this._onClick);

  Element createElement(){
    var btn = _createButton();
    btn.text = _text;
    return btn;
  }
  void _onButtonClick(Event e){
    e.preventDefault();
    _onClick();
  }
}