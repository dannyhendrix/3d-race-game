part of game.menu;

class ColorSelection extends UiPanel {
  ILifetime _lifetime;
  VehicleThemeColor selectedColor = null;
  Map<VehicleThemeColor, UiElement> _colorToElement = {};
  OnValueChange<VehicleThemeColor> onValueChange;

  ColorSelection(ILifetime lifetime) : super(lifetime) {
    _lifetime = lifetime;
  }

  @override
  void build() {
    super.build();
    addStyle("colorSelection");
    for (VehicleThemeColor color in VehicleThemeColor.values) {
      var el_color = _createColorButton(color);
      _colorToElement[color] = el_color;
      append(el_color);
    }
  }

  void setValue(VehicleThemeColor color) {
    if (selectedColor != null) _colorToElement[selectedColor].removeStyle("selected");
    selectedColor = color;
    _colorToElement[selectedColor].addStyle("selected");
    if (selectedColor != null) onValueChange?.call(color);
  }

  VehicleThemeColor getValue() => selectedColor;

  UiElement _createColorButton(VehicleThemeColor color) {
    UiPanel el = _lifetime.resolve();
    el.addStyle("colorSelectionItem");
    el.element.style.backgroundColor = colorMappingCss[color];
    el.element.onClick.listen((Event e) {
      setValue(color);
    });
    return el;
  }
}
