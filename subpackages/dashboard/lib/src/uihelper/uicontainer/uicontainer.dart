part of uihelper;

abstract class UiContainer extends UiElement{
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