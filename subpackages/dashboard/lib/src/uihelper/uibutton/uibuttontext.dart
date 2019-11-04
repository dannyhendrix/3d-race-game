part of uihelper;
class UiButtonText extends UiButton{
  OnButtonClick _onClick;
  UiButtonText(String text, this._onClick){
    changeText(text);
  }
  UiButtonText.fromInjection() : super.fromInjection();

  Element createElement() => _createButton();
  void changeText(String text) => element.text = text;
}