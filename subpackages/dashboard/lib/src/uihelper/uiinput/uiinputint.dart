part of uihelper;

class UiInputInt extends UiInput<int>{
  InputElement el_in;

  UiInputInt(ILifetime lifetime) : super(lifetime){
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
  void setValue(int value) {
    el_in.value = value.toString();
  }

  @override
  int getValue() {
    return int.parse(el_in.value);
  }
}