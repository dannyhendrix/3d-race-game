part of uihelper;

class UiText extends UiElement {
  UiText(String text){
    changeText(text);
  }
  UiText.fromInjection() : super.fromInjection();
  Element createElement() =>  new SpanElement();
  void changeText(String text) => element.text = text;
}