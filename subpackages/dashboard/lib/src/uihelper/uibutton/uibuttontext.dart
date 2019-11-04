part of uihelper;
class UiButtonText extends UiButton{
  String _text;
  OnButtonClick _onClick;
  UiButtonText(this._text, this._onClick);

  Element createElement(){
    var btn = _createButton();
    btn.text = _text;
    return btn;
  }
  void _onButtonClick(Event e){
    e.preventDefault();
    e.stopPropagation();
    _onClick();
  }
}