part of uihelper;

class UiText extends UiElement {
  String _text;
  UiText(this._text);
  Element createElement() {
    var el = new SpanElement();
    el.text = _text;
    return el;
  }
  void changeText(String text){
    element.text = text;
    _text = text;
  }
}