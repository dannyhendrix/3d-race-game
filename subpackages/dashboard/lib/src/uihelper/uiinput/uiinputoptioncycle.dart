part of uihelper;

class UiInputOptionCycle<T> extends UiInput<T> {
  ILifetime _lifetime;
  //Map<T, UiElement> _valueToElement;
  List<T> _options;
  UiButtonIcon _btn_next;
  UiButtonIcon _btn_prev;
  UiPanel _el_content;
  int index = 0;
  ObjectToString<T> objectToString = (T s) => s.toString();

  UiInputOptionCycle(ILifetime lifetime) : super(lifetime) {
    _lifetime = lifetime;
    _btn_next = lifetime.resolve();
    _btn_prev = lifetime.resolve();
    _el_content = lifetime.resolve();
  }

  @override
  void build() {
    super.build();
    _btn_prev
      ..changeIcon("navigate_before")
      ..addStyle("navigate")
      ..setOnClick(() {
        index--;
        if (index < 0) index = _options.length - 1;
        setValue(_options[index]);
      });
    _btn_next
      ..changeIcon("navigate_next")
      ..addStyle("navigate")
      ..setOnClick(() {
        index++;
        if (index >= _options.length) index = 0;
        setValue(_options[index]);
      });
    _el_content.addStyle("content");
    element.append(_btn_prev.element);
    element.append(_el_content.element);
    element.append(_btn_next.element);
  }

  void setOptions(List<T> newOptions) {
    _options = newOptions;
    //_valueToElement = {};
  }

  @override
  T getValue() {
    return _options[index];
  }

  @override
  void setValue(T newValue) {
    //_valueToElement[_options[index]].removeStyle("selected");
    //_valueToElement[newValue].addStyle("selected");
    index = _options.indexOf(newValue);
  }

  void appendToContent(UiElement element) => _el_content.append(element);
  void appendElementToContent(Element element) => _el_content.appendElement(element);
}
/*
abstract class GameInputSelection<T> extends UiPanel{

  int index = 0;
  int optionsLength = 5;

  GameInputSelection(ILifetime lifetime) : super(lifetime){
    _btn_next = lifetime.resolve();
    _btn_prev = lifetime.resolve();
    el_content = lifetime.resolve();
  }

  void setOptions(int options){
    optionsLength = options;
  }

  @override
  void build(){
    super.build();

    addStyle("GameInputSelection");
/*
    if(label.isNotEmpty){
      var el_label = new UiText(label);
      el_label.addStyle("label");
      element.append(el_label);
    }
*/

  }
  void onIndexChanged(int oldIndex, int newIndex){
    el_content.element.text = newIndex.toString();
  }

  T getSelectedValue();
}*/
