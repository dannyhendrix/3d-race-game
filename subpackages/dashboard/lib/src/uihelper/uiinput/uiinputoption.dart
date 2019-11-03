part of uihelper;

typedef String ObjectToString<T>(T obj);

class UiInputOption<T> extends UiInput<T>{
  SelectElement el_in;
  List<T> options;
  ObjectToString<T> objectToString = (T s) => s.toString();

  UiInputOption(String label, this.options) : super(label);
  Element createElement(){
    Element el = super._createElement();
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