part of uihelper;

class UiInputBool extends UiInput<bool>{
  CheckboxInputElement el_in;

  UiInputBool(ILifetime lifetime) : super(lifetime){
    el_in = lifetime.resolve();
  }
  @override
  void build(){
    super.build();
    el_in.onChange.listen((Event e){
      if(onValueChange != null)onValueChange(getValue());
    });
    element.append(el_in);
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