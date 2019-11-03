part of uihelper;

class UiInputTextLarge extends UiInput<String>{
  TextAreaElement _el_in;

  UiInputTextLarge(String label) : super(label);
  Element createElement(){
    Element el = super._createElement();
    _el_in = new TextAreaElement();
    _el_in.onChange.listen((Event e){
      if(onValueChange != null)onValueChange(getValue());
    });
    el.append(_el_in);
    return el;
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