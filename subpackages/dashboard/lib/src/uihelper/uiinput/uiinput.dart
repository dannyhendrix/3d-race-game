part of uihelper;

typedef void OnValueChange<T>(T value);

abstract class UiInput<T> extends UiElement{
  String label;
  OnValueChange<T> onValueChange;

  UiInput(this.label);

  Element _createElement(){
    Element el = new DivElement();
    Element el_label = new SpanElement();
    el_label.className = "label";
    el_label.text = label;
    el.append(el_label);
    return el;
  }
  void setValue(T value);
  T getValue();
}