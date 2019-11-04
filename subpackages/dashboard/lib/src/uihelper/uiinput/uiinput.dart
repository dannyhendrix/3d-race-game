part of uihelper;

typedef void OnValueChange<T>(T value);

abstract class UiInput<T> extends UiElement{
  UiInputLabel label;
  OnValueChange<T> onValueChange;

  UiInput(String labelTxt) : label = UiInputLabel(labelTxt);
  UiInput.fromInjection() : super.fromInjection();

  void setDependencies(ILifetime lifetime){
    label = lifetime.resolve();
    super.setDependencies(lifetime);
  }

  Element _createElement(){
    Element el = new DivElement();
    el.append(label.element);
    return el;
  }
  void setValue(T value);
  T getValue();
  void changeLabel(String labelTxt) => label.changeText(labelTxt);
}

class UiInputLabel extends UiText {
  UiInputLabel(String text) : super(text){
    addStyle("label");
  }
  UiInputLabel.fromInjection() : super.fromInjection();
  void setDependencies(ILifetime lifetime){
    super.setDependencies(lifetime);
    addStyle("label");
  }
}