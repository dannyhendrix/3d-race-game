part of uihelper;

class UiInputText extends UiInput<String>{
  InputElement el_in;

  UiInputText(ILifetime lifetime) : super(lifetime){
    el_in = lifetime.resolve();
  }
  @override
  void build(){
    super.build();
    el_in.type = "text";
    el_in.onChange.listen((Event e){
      if(onValueChange != null)onValueChange(getValue());
    });
    element.append(el_in);
  }

  @override
  void setValue(String value) {
    el_in.value = value.toString();
  }

  @override
  String getValue() {
    return el_in.value;
  }
}