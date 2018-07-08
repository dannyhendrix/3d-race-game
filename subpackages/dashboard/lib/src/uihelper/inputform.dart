part of uihelper;

typedef void OnValueChange<T>(T value);

abstract class InputForm<T>{
  String label;
  OnValueChange<T> onValueChange;

  InputForm(this.label);

  Element createElement(){
    Element el = new DivElement();
    Element el_label = new SpanElement();
    el_label.className = "label";
    el_label.text = label;
    el.append(el_label);
    return el;
  }
  void setValue(T value);
  T getValue();
}

class InputFormString extends InputForm<String>{
  InputElement el_in;

  InputFormString(String label) : super(label);
  Element createElement(){
    Element el = super.createElement();
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

class InputFormInt extends InputForm<int>{
  InputElement el_in;

  InputFormInt(String label) : super(label);
  Element createElement(){
    Element el = super.createElement();
    el_in = new InputElement();
    el_in.type = "number";
    el_in.onChange.listen((Event e){
      if(onValueChange != null)onValueChange(getValue());
    });

    Element el_label = new SpanElement();
    el_label.className = "label";
    el_label.text = label;

    el.append(el_label);
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

class InputFormDouble extends InputForm<double>{
  InputElement el_in;

  InputFormDouble(String label) : super(label);
  Element createElement(){
    Element el = super.createElement();
    el_in = new InputElement();
    el_in.type = "number";
    el_in.onChange.listen((Event e){
      if(onValueChange != null)onValueChange(getValue());
    });
    el.append(el_in);
    return el;
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

class InputFormBool extends InputForm<bool>{
  Element el_checked;
  Element el_unchecked;
  bool checked = false;

  InputFormBool(String label) : super(label);
  Element createElement(){
    Element el = super.createElement();
    el_checked = UIHelper.createButtonWithIcon("check_box", (Event e){
      checked = false;
      _setValueInElement(checked);
      if(onValueChange != null)onValueChange(getValue());
    });
    el_unchecked = UIHelper.createButtonWithIcon("check_box_outline_blank", (Event e){
      checked = true;
      _setValueInElement(checked);
      if(onValueChange != null)onValueChange(getValue());
    });
    el.append(el_checked);
    el.append(el_unchecked);
    _setValueInElement(false);
    return el;
  }

  void _setValueInElement(bool checked){
    print(checked);
    if(checked){
      el_checked.style.display = "";
      el_unchecked.style.display = "none";
    }else{
      el_checked.style.display = "none";
      el_unchecked.style.display = "";
    }
  }

  @override
  void setValue(bool value) {
    checked = value;
    _setValueInElement(checked);
  }

  @override
  bool getValue() {
    return checked;
  }
}

class InputFormBoolCheckbox extends InputForm<bool>{
  CheckboxInputElement el_in;

  InputFormBoolCheckbox(String label) : super(label);
  Element createElement(){
    Element el = super.createElement();
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

typedef String ObjectToString<T>(T obj);

class InputFormOption<T> extends InputForm<T>{
  SelectElement el_in;
  List<T> options;
  ObjectToString<T> objectToString = (T s) => s.toString();

  InputFormOption(String label, this.options) : super(label);
  Element createElement(){
    Element el = super.createElement();
    el_in = new SelectElement();
    el_in.onChange.listen((Event e){
      if(onValueChange != null)onValueChange(getValue());
    });
    for(T option in options){
      el_in.append(new OptionElement(data:objectToString(option)));
    }
    el.append(el_in);
    return el;
  }

  @override
  void setValue(T newValue) {
    int index = options.indexOf(newValue);
    if(index == -1) return;
    el_in.selectedIndex = index;
  }

  @override
  T getValue() {
    return options[el_in.selectedIndex];
  }
}

class InputFormRadio<T> extends InputForm<T>{
  int value = null;
  Map<int, Element> _valueToElement;
  List<T> options;
  ObjectToString<T> objectToString = (T s) => s.toString();

  InputFormRadio(String label, this.options) : super(label);

  Element createElement(){
    Element el = super.createElement();
    _valueToElement = {};
    for(int i = 0; i < options.length; i++){
      Element el_item = _createOption(options[i]);
      _valueToElement[i] = el_item;
      el.append(el_item);
    }
    return el;
  }

  Element _createOption(T optionValue){
    Element el = UIHelper.createButtonWithText(objectToString(optionValue), (MouseEvent e){
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
    int index = options.indexOf(newValue);
    if(index == -1) return;
    if(value != null) _valueToElement[value].classes.remove("selected");
    value = index;
    print(index);
    _valueToElement[value].classes.add("selected");
  }
}