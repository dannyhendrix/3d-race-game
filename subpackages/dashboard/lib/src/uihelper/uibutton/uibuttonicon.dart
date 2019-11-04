part of uihelper;
class UiButtonIcon extends UiButton{
  UiIcon icon;
  OnButtonClick _onClick;
  UiButtonIcon(String iconId, this._onClick) : icon = UiIcon(iconId);
  UiButtonIcon.fromInjection() : super.fromInjection();

  void setDependencies(ILifetime lifetime){
    icon = lifetime.resolve();
    super.setDependencies(lifetime);
  }

  Element createElement(){
    var btn = _createButton();
    btn.classes.add("buttonIcon");
    btn.append(icon.element);
    return btn;
  }

  void changeIcon(String iconId) => icon.changeIcon(iconId);
}