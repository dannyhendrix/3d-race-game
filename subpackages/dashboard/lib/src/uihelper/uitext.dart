part of uihelper;

class UiText extends UiElement {
  UiText(ILifetime lifetime) : super(lifetime){
    element = lifetime.resolve<SpanElement>();
  }
  void changeText(String text) => element.text = text;
}