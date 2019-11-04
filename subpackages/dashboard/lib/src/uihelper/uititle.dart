part of uihelper;

class UiTitle extends UiElement {
  String _text;
  UiTitle(this._text);
  Element createElement() {
    var el = new HeadingElement.h1();
    el.text = _text;
    return el;
  }
  void changeText(String text){
    element.text = text;
    _text = text;
  }
}