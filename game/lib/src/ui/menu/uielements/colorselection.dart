part of game.menu;

class ColorSelection extends UiPanel{
  ILifetime _lifetime;
  VehicleThemeColor selectedColor = null;
  Map<VehicleThemeColor, UiElement> _colorToElement = {};
  OnValueChange<VehicleThemeColor> onValueChange;

  ColorSelection(ILifetime lifetime) : super(lifetime){
    _lifetime = lifetime;
  }

  @override
  void build(){
    super.build();
    addStyle("colorSelection");
    for(VehicleThemeColor color in VehicleThemeColor.values){
      var el_color = _createColorButton(color);
      _colorToElement[color] = el_color;
      append(el_color);
    }
  }

  void setValue(VehicleThemeColor color){
    if(selectedColor != null) _colorToElement[selectedColor].removeStyle("selected");
    selectedColor = color;
    _colorToElement[selectedColor].addStyle("selected");
    if(selectedColor != null) onValueChange?.call(color);
  }
  VehicleThemeColor getValue() => selectedColor;

  UiElement _createColorButton(VehicleThemeColor color){
    UiPanel el = _lifetime.resolve();
    el.addStyle("colorSelectionItem");
    el.element.style.backgroundColor = colorMappingCss[color];
    el.element.onClick.listen((Event e){setValue(color);});
    return el;
  }
}

class CustomLevelInput extends UiPanel{
  UiInputTextLarge _in_levelJson;
  GameSettings _settings;

  CustomLevelInput(ILifetime lifetime) : super(lifetime){
    _in_levelJson = lifetime.resolve();
    _settings = lifetime.resolve();
  }

  void setValue(String value) => _in_levelJson.setValue(value);
  String getValue() => _in_levelJson.getValue();

  void build(){
    super.build();
    _in_levelJson.addStyle("leveljson");
    var el_editorLink = new AnchorElement();
    el_editorLink.href = _settings.editor_location.v;
    el_editorLink.className = "button";
    el_editorLink.text = "Open level editor";
    el_editorLink.target = "_blank";
    append(_in_levelJson);
    appendElement(new BRElement());
    appendElement(el_editorLink);
  }
}