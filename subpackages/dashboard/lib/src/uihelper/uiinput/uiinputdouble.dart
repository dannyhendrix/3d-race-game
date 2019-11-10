part of uihelper;

class UiInputDouble extends UiInput<double>{
  InputElement el_in;

  UiInputDouble(ILifetime lifetime) : super(lifetime){
    el_in = lifetime.resolve();
  }
  @override
  void build(){
    super.build();
    el_in.type = "number";
    el_in.onChange.listen((Event e){
      if(onValueChange != null)onValueChange(getValue());
    });
    element.append(el_in);
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