part of uihelper;

class UiTextHtml extends UiElement {
  String _text;
  UiTextHtml(this._text);
  Element createElement() {
    var el = new SpanElement();
    el.innerHtml = _text;
    return el;
  }
  void changeText(String text){
    element.innerHtml = text;
    _text = text;
  }
}