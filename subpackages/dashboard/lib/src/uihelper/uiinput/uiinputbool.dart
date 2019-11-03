part of uihelper;

class UiInputBool extends UiInput<bool>{
  CheckboxInputElement el_in;

  UiInputBool(String label) : super(label);
  Element createElement(){
    Element el = super._createElement();
    el_in = new CheckboxInputElement();
    el_in.onChange.listen((Event e){
      if(onValueChange != null)onValueChange(getValue());
    });
    el.append(el_in);
    return el;
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