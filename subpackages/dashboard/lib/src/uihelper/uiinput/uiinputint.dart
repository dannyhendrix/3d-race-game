part of uihelper;

class UiInputInt extends UiInput<int>{
  InputElement el_in;

  UiInputInt(String label) : super(label);
  Element createElement(){
    Element el = super._createElement();
    el_in = new InputElement();
    el_in.type = "number";
    el_in.onChange.listen((Event e){
      if(onValueChange != null)onValueChange(getValue());
    });
    el.append(el_in);
    return el;
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