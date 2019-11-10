part of uihelper;

typedef void OnButtonClick();

abstract class UiButton extends UiElement{
  ButtonElement _buttonElement;
  OnButtonClick _onClick;
  UiButton(ILifetime lifetime) : super(lifetime){
    _buttonElement = lifetime.resolve();
    element = _buttonElement;
  }
  @override
  void build(){
    super.build();
    _buttonElement.classes.add("button");
    _buttonElement.onClick.listen(_onButtonClick);
    _buttonElement.onTouchStart.listen(_onButtonClick);
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