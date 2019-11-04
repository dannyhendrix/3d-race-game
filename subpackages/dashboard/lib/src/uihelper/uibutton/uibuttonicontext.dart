part of uihelper;
class UiButtonIconText extends UiButton{
  OnButtonClick _onClick;
  UiIcon icon;
  UiText text;
  UiButtonIconText(String text, String iconId, this._onClick) : icon = UiIcon(iconId), text = UiText(text){
    changeText(text);
  }
  UiButtonIconText.fromInjection() : super.fromInjection();
  void setDependencies(ILifetime lifetime){
    icon = lifetime.resolve();
    text = lifetime.resolve();
    super.setDependencies(lifetime);
  }
  Element createElement(){
    var btn = _createButton();
    btn.classes.add("buttonIcon");
    btn.append(icon.element);
    btn.append(text.element);
    return btn;
  }
  void changeIcon(String iconId) => icon.changeIcon(iconId);
  void changeText(String txt) => text.changeText(txt);
}