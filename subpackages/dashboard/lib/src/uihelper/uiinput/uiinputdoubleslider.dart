part of uihelper;

class UiInputDoubleSlider extends UiInput<double>{
  InputElement el_in;
  double _min, _max, _steps;

  UiInputDoubleSlider(ILifetime lifetime) : super(lifetime){
    el_in = lifetime.resolve();
  }
  @override
  void build(){
    super.build();
    el_in.type = "range";
    el_in.onMouseMove.listen((Event e){
      if(onValueChange != null)onValueChange(getValue());
    });
    if(_min != null) setMin(_min);
    if(_max != null) setMin(_max);
    if(_steps != null) setMin(_steps);
    element.append(el_in);
  }
  void setMin(double newMin){
    _min = newMin;
    el_in.min = _min.toString();
  }
  void setMax(double newMax){
    _max = newMax;
    el_in.max = _max.toString();
  }
  void setSteps(double newSteps){
    _steps = newSteps;
    el_in.step = _steps > 0 ? ((_max-_min)/_steps).toString() : "";
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