part of uihelper;
class UiButtonText extends UiButton{
  OnButtonClick _onClick;
  UiButtonText(ILifetime lifetime) : super(lifetime);
  void changeText(String text) => element.text = text;
}