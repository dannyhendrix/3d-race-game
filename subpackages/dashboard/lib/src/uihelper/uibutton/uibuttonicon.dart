part of uihelper;
class UiButtonIcon extends UiButton{
  UiIcon icon;
  OnButtonClick _onClick;
  UiButtonIcon(ILifetime lifetime) : super(lifetime){
    icon = lifetime.resolve();
  }

  @override
  void build(){
    super.build();
    _buttonElement.classes.add("buttonIcon");
    _buttonElement.append(icon.element);
  }

  void changeIcon(String iconId) => icon.changeIcon(iconId);
}