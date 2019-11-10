part of uihelper;
class UiButtonIconText extends UiButton{
  OnButtonClick _onClick;
  UiIcon icon;
  UiText text;
  UiButtonIconText(ILifetime lifetime) : super(lifetime){
    icon = lifetime.resolve();
    text = lifetime.resolve();
  }
  @override
  void build(){
    super.build();
    element.classes.add("buttonIcon");
    element.append(icon.element);
    element.append(text.element);
  }
  void changeIcon(String iconId) => icon.changeIcon(iconId);
  void changeText(String txt) => text.changeText(txt);
}