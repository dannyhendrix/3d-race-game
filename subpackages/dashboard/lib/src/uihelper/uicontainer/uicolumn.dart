part of uihelper;

class UIColumn extends UiContainer{
  Element createElement(){
    var el = new SpanElement();
    el.className = "column";
    return el;
  }
}