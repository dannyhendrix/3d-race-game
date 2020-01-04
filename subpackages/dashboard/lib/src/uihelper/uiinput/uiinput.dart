part of uihelper;

typedef void OnValueChange<T>(T value);

abstract class UiInput<T> extends UiElement {
  UiInputLabel label;
  OnValueChange<T> onValueChange;

  UiInput(ILifetime lifetime) : super(lifetime) {
    label = lifetime.resolve();
    element = lifetime.resolve<DivElement>();
  }

  @override
  void build() {
    super.build();
    element.append(label.element);
  }

  void setValue(T value);
  T getValue();
  void changeLabel(String labelTxt) => label.changeText(labelTxt);
  void setOnValueChange(OnValueChange<T> f) => onValueChange = f;
}

class UiInputLabel extends UiText {
  UiInputLabel(ILifetime lifetime) : super(lifetime);
  @override
  void build() {
    super.build();
    addStyle("label");
  }
}
