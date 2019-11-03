part of uihelper;

class UiInputText extends UiInput<String>{
  InputElement el_in;

  UiInputText(String label) : super(label);
  Element createElement(){
    Element el = super._createElement();
    el_in = new InputElement();
    el_in.type = "text";
    el_in.onChange.listen((Event e){
      if(onValueChange != null)onValueChange(getValue());
    });
    el.append(el_in);
    return el;
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