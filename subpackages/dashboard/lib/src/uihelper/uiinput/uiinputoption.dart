part of uihelper;

typedef String ObjectToString<T>(T obj);

class UiInputOption<T> extends UiInput<T>{
  SelectElement el_in;
  List<T> _options;
  ObjectToString<T> objectToString = (T s) => s.toString();

  UiInputOption(ILifetime lifetime) : super(lifetime){
    el_in = lifetime.resolve();
  }

  @override
  void build(){
    super.build();
    el_in.onChange.listen((Event e){
      if(onValueChange != null)onValueChange(getValue());
    });
    if(_options != null) setOptions(_options);
    element.append(el_in);
  }

  void setOptions(List<T> newOptions){
    _options = newOptions;
    el_in.children.clear();
    for(T option in _options){
      el_in.append(new OptionElement(data:objectToString(option)));
    }
  }

  @override
  void setValue(T newValue) {
    int index = _options.indexOf(newValue);
    if(index == -1) return;
    el_in.selectedIndex = index;
  }

  @override
  T getValue() {
    return _options[el_in.selectedIndex];
  }
}