part of uihelper;

class UiInputDoubleSlider extends UiInput<double>{
  InputElement el_in;
  double min, max, steps;

  UiInputDoubleSlider(String label, this.min, this.max, this.steps) : super(label);
  Element createElement(){
    Element el = super._createElement();
    el_in = new InputElement();
    el_in.type = "range";
    el_in.min = min.toString();
    el_in.max = max.toString();
    if(steps > 0)
      el_in.step = ((max-min)/steps).toString();
    el_in.onMouseMove.listen((Event e){
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