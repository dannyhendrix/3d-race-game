part of uihelper;

abstract class UiElement{
  UiElement(ILifetime lifetime);
  Element element;
  UiElement show(){
    element.style.display = "";
    return this;
  }
  void build(){}
  UiElement hide(){
    element.style.display = "none";
    return this;
  }
  void display(bool display){
    if(display) show(); else hide();
  }
  void addStyle(String style){
    element.classes.add(style);
  }
  void removeStyle(String style){
    element.classes.remove(style);
  }
  void setStyleId(String id){
    element.id = id;
  }
}

class ElementFactory{
  Element createTag(String tag){
    return Element.tag(tag);
  }
}