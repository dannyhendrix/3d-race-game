part of uihelper;

class UiInputOptionRadio<T> extends UiInput<T>{
  int value = null;
  Map<int, UiElement> _valueToElement;
  List<T> options;
  ObjectToString<T> objectToString = (T s) => s.toString();

  UiInputOptionRadio(String label, this.options) : super(label);

  Element createElement(){
    Element el = super._createElement();
    _valueToElement = {};
    for(int i = 0; i < options.length; i++){
      var el_item = _createOption(options[i]);
      _valueToElement[i] = el_item;
      el.append(el_item.element);
    }
    return el;
  }

  UiElement _createOption(T optionValue){
    var el = UITextButton(objectToString(optionValue), (){
      setValue(optionValue);
      if(onValueChange != null)onValueChange(getValue());
    });
    return el;
  }

  @override
  T getValue() {
    return options[value];
  }

  @override
  void setValue(T newValue) {
    setValueIndex(options.indexOf(newValue));
  }

  void setValueIndex(int index){
    if(index == -1) return;
    if(value != null) _valueToElement[value].removeStyle("selected");
    value = index;
    _valueToElement[value].addStyle("selected");
  }
}