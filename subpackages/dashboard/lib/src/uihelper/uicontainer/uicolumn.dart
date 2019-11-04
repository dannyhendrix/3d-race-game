part of uihelper;

class UiColumn extends UiContainer{
  Element createElement(){
    var el = new SpanElement();
    el.className = "column";
    return el;
  }
}