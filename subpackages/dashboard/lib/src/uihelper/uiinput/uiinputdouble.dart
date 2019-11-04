part of uihelper;

class UiInputDouble extends UiInput<double>{
  InputElement el_in;

  UiInputDouble(String label) : super(label);
  UiInputDouble.fromInjection() : super.fromInjection();
  Element createElement(){
    Element el = super._createElement();
    el_in = new InputElement();
    el_in.type = "number";
    el_in.onChange.listen((Event e){
      if(onValueChange != null)onValueChange(getValue());
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