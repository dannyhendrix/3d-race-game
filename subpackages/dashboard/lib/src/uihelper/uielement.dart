part of uihelper;

abstract class UiElement{
  Element element;
  UiElement(){
    element = createElement();
  }
  Element createElement();
  UiElement show(){
    element.style.display = "";
    return this;
  }
  UiElement hide(){
    element.style.display = "none";
    return this;
  }
  UiElement display(bool display){
    if(display) return show(); else return hide();
  }
  UiElement addStyle(String style){
    element.classes.add(style);
    return this;
  }
  UiElement removeStyle(String style){
    element.classes.remove(style);
    return this;
  }
}