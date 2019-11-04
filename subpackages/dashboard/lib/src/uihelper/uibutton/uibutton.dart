part of uihelper;

typedef void OnButtonClick();

abstract class UiButton extends UiElement{
  UiButton();
  UiButton.fromInjection() : super.fromInjection();
  OnButtonClick _onClick;
  Element _createButton(){
    var btn = new ButtonElement();
    btn.className = "button";
    btn.onClick.listen(_onButtonClick);
    btn.onTouchStart.listen(_onButtonClick);
    return btn;
  }
  void setOnClick(OnButtonClick onClick){
    _onClick = onClick;
  }
  bool _onButtonClick(Event e){
    e.preventDefault();
    e.stopPropagation();
    _onClick?.call();
    return false;
  }
}