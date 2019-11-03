part of uihelper;

class UiPanel extends UiElement {
  Element createElement() {
    return new DivElement();
  }
  void append(UiElement el){
    element.append(el.element);
  }
  void appendElement(Element el){
    element.append(el);
  }
}
class UiPanelForm extends UiElement {
  Element createElement() {
    return new FormElement();
  }
  void append(UiElement el){
    element.append(el.element);
  }
  void appendElement(Element el){
    element.append(el);
  }
}