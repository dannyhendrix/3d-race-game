part of uihelper;

class UiInputOptionRadio extends UiInput<dynamic> {
  ILifetime _lifetime;
  SpanElement _elButtons;
  int value = null;
  Map<int, UiElement> _valueToElement;
  List<dynamic> _options;
  ObjectToString<dynamic> objectToString = (dynamic s) => s.toString();

  UiInputOptionRadio(ILifetime lifetime) : super(lifetime) {
    _lifetime = lifetime;
    _elButtons = lifetime.resolve();
  }

  @override
  void build() {
    super.build();
    element.append(_elButtons);
    if (_options != null) setOptions(_options);
  }

  UiElement _createOption(dynamic optionValue) {
    var el = _lifetime.resolve<UiButtonText>();
    el.changeText(objectToString(optionValue));
    el.setOnClick(() {
      setValue(optionValue);
      if (onValueChange != null) onValueChange(getValue());
    });
    return el;
  }

  void setOptions(List<dynamic> newOptions) {
    _options = newOptions;
    _valueToElement = {};
    _elButtons.children.clear();
    for (int i = 0; i < _options.length; i++) {
      var el_item = _createOption(_options[i]);
      _valueToElement[i] = el_item;
      _elButtons.append(el_item.element);
    }
  }

  @override
  dynamic getValue() {
    return _options[value];
  }

  @override
  void setValue(dynamic newValue) {
    setValueIndex(_options.indexOf(newValue));
  }

  void setValueIndex(int index) {
    if (index == -1) return;
    if (value != null) _valueToElement[value].removeStyle("selected");
    value = index;
    _valueToElement[value].addStyle("selected");
  }
}
