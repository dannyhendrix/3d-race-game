part of uihelper;

abstract class UiElement{
  UiElement(ILifetime lifetime);
  Element element;
  void show(){
    element.style.display = "";
  }
  void build(){}
  void hide(){
    element.style.display = "none";
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