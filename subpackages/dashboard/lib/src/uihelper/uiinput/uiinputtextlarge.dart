part of uihelper;

class UiInputTextLarge extends UiInput<String>{
  TextAreaElement _el_in;

  UiInputTextLarge(ILifetime lifetime) : super(lifetime){
    _el_in = lifetime.resolve();
  }
  @override
  void build(){
    super.build();
    _el_in.onChange.listen((Event e){
      if(onValueChange != null)onValueChange(getValue());
    });
    element.append(_el_in);
  }

  @override
  void setValue(String value) {
    _el_in.value = value.toString();
  }

  @override
  String getValue() {
    return _el_in.value;
  }
}