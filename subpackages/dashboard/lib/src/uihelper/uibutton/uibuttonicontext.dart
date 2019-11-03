part of uihelper;
class UiButtonIconText extends UiButton{
  String _icon_default;
  String _text;
  OnButtonClick _onClick;
  UiButtonIconText(this._text, this._icon_default, this._onClick);

  Element createElement(){
    var eltxt = new SpanElement();
    eltxt.text = _text;
    var el_icon = UiIcon(_icon_default);
    var btn = _createButton();
    btn.classes.add("buttonIcon");
    btn.append(el_icon.element);
    btn.append(eltxt);
    return btn;
  }
  void _onButtonClick(Event e){
    e.preventDefault();
    _onClick();
  }
}