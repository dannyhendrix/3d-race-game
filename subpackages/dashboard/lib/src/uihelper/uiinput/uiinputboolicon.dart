part of uihelper;

class UiInputBoolIcon extends UiInput<bool>{
  UIIconButton el_checked;
  UIIconButton el_unchecked;
  bool checked = false;

  UiInputBoolIcon(String label) : super(label);
  Element createElement(){
    Element el = super._createElement();
    el_checked = UIIconButton("check_box", (){
      checked = false;
      _setValueInElement(checked);
      if(onValueChange != null)onValueChange(getValue());
    });
    el_unchecked = UIIconButton("check_box_outline_blank", (){
      checked = true;
      _setValueInElement(checked);
      if(onValueChange != null)onValueChange(getValue());
    });
    el.append(el_checked.element);
    el.append(el_unchecked.element);
    _setValueInElement(false);
    return el;
  }

  void _setValueInElement(bool checked){
    if(checked){
      el_checked.show();
      el_unchecked.hide();
    }else{
      el_checked.hide();
      el_unchecked.show();
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