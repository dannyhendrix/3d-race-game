part of uihelper;

class UiTextHtml extends UiElement {
  UiTextHtml(ILifetime lifetime) : super(lifetime){
    element = lifetime.resolve<SpanElement>();
  }
  void changeText(String text){
    element.innerHtml = text;
  }
}