part of uihelper;

class UiInputOptionCycle<T> extends UiInput<T>{
  ILifetime _lifetime;
  int value = null;
  Map<int, UiElement> _valueToElement;
  List<T> _options;
  UiButtonIcon _btn_next;
  UiButtonIcon _btn_prev;
  UiPanel _el_content;
  int index = 0;
  //TODO: remove
  int optionsLength = 0;
  ObjectToString<T> objectToString = (T s) => s.toString();

  UiInputOptionCycle(ILifetime lifetime) : super(lifetime){
    _lifetime = lifetime;
    _btn_next = lifetime.resolve();
    _btn_prev = lifetime.resolve();
    _el_content = lifetime.resolve();
  }

  @override
  void build(){
    super.build();
    _btn_prev..changeIcon("navigate_before")..addStyle("navigate")..setOnClick((){
      if(index < 0)
        index = optionsLength-1;
      setValueIndex(index);
    });
    _btn_next..changeIcon("navigate_next")..addStyle("navigate")..setOnClick((){
      if(index >= optionsLength)
        index = 0;
      setValueIndex(index);
    });
    _el_content.addStyle("content");
    element.append(_btn_prev.element);
    element.append(_el_content.element);
    element.append(_btn_next.element);
  }
/*
  void setOptions(List<T> newOptions){
    _options = newOptions;
    _valueToElement = {};
    _elButtons.children.clear();
    for(int i = 0; i < _options.length; i++){
      var el_item = _createOption(_options[i]);
      _valueToElement[i] = el_item;
      _elButtons.append(el_item.element);
    }
  }
*/
  @override
  T getValue() {
    return _options[value];
  }

  @override
  void setValue(T newValue) {
    setValueIndex(_options.indexOf(newValue));
  }

  void setValueIndex(int index){
    if(index == -1) return;
    if(value != null) _valueToElement[value].removeStyle("selected");
    value = index;
    _valueToElement[value].addStyle("selected");
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