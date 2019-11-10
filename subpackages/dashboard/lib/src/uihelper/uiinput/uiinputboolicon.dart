part of uihelper;

class UiInputBoolIcon extends UiInput<bool>{
  UiButtonIcon el_checked;
  bool checked = false;
  static const String _iconChecked = "check_box";
  static const String _iconUnChecked = "check_box_outline_blank";

  UiInputBoolIcon(ILifetime lifetime) : super(lifetime){
    el_checked = lifetime.resolve();
  }

  @override
  void build(){
    super.build();
    el_checked.setOnClick((){
      checked = !checked;
      _setValueInElement(checked);
      if(onValueChange != null)onValueChange(getValue());
    });
    element.append(el_checked.element);
    _setValueInElement(false);
  }

  void _setValueInElement(bool checked){
    if(checked){
      el_checked.changeIcon(_iconChecked);
    }else{
      el_checked.changeIcon(_iconUnChecked);
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