part of game.leveleditor;

typedef void OnValueChange<T>(T value);

abstract class InputForm<T>{
  String label;
  OnValueChange<T> onValueChange;

  InputForm(this.label);

  Element createElement(){
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

class InputFormInt extends InputForm<int>{
  InputElement el_in;

  InputFormInt(String label) : super(label);
  Element createElement(){
    Element el = super.createElement();
    el_in = new InputElement();
    el_in.type = "number";
    el_in.onChange.listen((Event e){
      onValueChange(getValue());
    });

    el.append(el_in);
    return el;
  }

  @override
  void setValue(int value) {
    el_in.value = value.toString();
  }

  @override
  int getValue() {
    return int.parse(el_in.value);
  }
}
class InputFormDouble extends InputForm<double>{
  InputElement el_in;

  InputFormDouble(String label) : super(label);
  Element createElement(){
    Element el = super.createElement();
    el_in = new InputElement();
    el_in.type = "number";
    el_in.onChange.listen((Event e){
      onValueChange(getValue());
    });

    el.append(el_in);
    return el;
  }
  @override
  void setValue(double value) {
    el_in.value = value.toString();
  }
  @override
  double getValue() {
    return double.parse(el_in.value);
  }
}
class InputFormDoubleSlider extends InputForm<double>{
  InputElement el_in;
  double min, max, steps;

  InputFormDoubleSlider(String label, this.min, this.max, this.steps) : super(label);
  Element createElement(){
    Element el = super.createElement();
    el_in = new InputElement();
    el_in.type = "range";
    el_in.min = min.toString();
    el_in.max = max.toString();
    if(steps > 0)
      el_in.step = ((max-min)/steps).toString();
    el_in.onChange.listen((Event e){
      onValueChange(getValue());
    });

    el.append(el_in);
    return el;
  }
  @override
  void setValue(double value) {
    el_in.value = value.toString();
  }
  @override
  double getValue() {
    return double.parse(el_in.value);
  }
}
class InputFormBool extends InputForm<bool>{
  CheckboxInputElement el_in;

  InputFormBool(String label) : super(label);
  Element createElement(){
    Element el = super.createElement();
    el_in = new CheckboxInputElement();
    el_in.onChange.listen((Event e){
      onValueChange(getValue());
    });

    el.append(el_in);
    return el;
  }
  @override
  void setValue(bool value) {
    el_in.checked = value;
  }
  @override
  bool getValue() {
    return el_in.checked;
  }
}