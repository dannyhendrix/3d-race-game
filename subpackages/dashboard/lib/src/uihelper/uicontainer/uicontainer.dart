part of uihelper;

abstract class UiContainer extends UiElement{
  UiContainer();
  UiContainer.fromInjection() : super.fromInjection();
  void append(UiElement el){
    element.append(el.element);
  }
  void appendElement(Element el){
    element.append(el);
  }
  void clear(){
    element.children.clear();
  }
}