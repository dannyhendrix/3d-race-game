part of uihelper;

class UiTitle extends UiElement {
  String _text;
  UiTitle(ILifetime lifetime) : super(lifetime){
    element = lifetime.resolve<ElementFactory>().createTag('h1');
  }
  void changeText(String text){
    element.text = text;
    _text = text;
  }
}