part of game.menu;

typedef void OnColorChange(VehicleThemeColor newColor);

class ProfileMenu extends GameMenuScreen{
  TextureGenerator _textureGenerator;
  GameMenuController menu;
  ProfileMenu(this.menu){
    _textureGenerator = new TextureGenerator(menu.resourceManager);
  }

  ImageElement _el_vehiclePreview;

  UiContainer setupFields()
  {
    var el = super.setupFields();

    _el_vehiclePreview = new ImageElement();

    el.appendElement(_el_vehiclePreview);
    el.append(_createColorSelect(menu.settings.user_color1.v, (VehicleThemeColor newColor){ menu.settings.user_color1.v = newColor; _onColorChange();}));
    el.append(_createColorSelect(menu.settings.user_color2.v, (VehicleThemeColor newColor){ menu.settings.user_color2.v = newColor; _onColorChange();}));
    el.append(_createUsernameInput(menu.settings.user_name.v));

    closebutton = false;

    _onColorChange();

    //add(createOpenMenuButton("Options",TeamxMenuController.MENU_OPTION));
    return el;
  }

  void _onColorChange(){
    _el_vehiclePreview.src = _createPreviewFromModel(new GlModel_Vehicle(), colorMappingGl[menu.settings.user_color1.v], colorMappingGl[menu.settings.user_color2.v]);

    if(menu.settings.client_changeCSSWithThemeChange.v)
    {
      LinkElement theme1 = document.querySelector("#css_theme1");
      theme1.href = "theme1/${colorMappingText[menu.settings.user_color1.v].toLowerCase()}.css";
      LinkElement theme2 = document.querySelector("#css_theme2");
      theme2.href = "theme2/${colorMappingText[menu.settings.user_color2.v].toLowerCase()}.css";
    }
  }

  UiElement _createColorSelect(VehicleThemeColor current, OnColorChange onColorChange){
    var cs = new ColorSelection(onColorChange);
    return cs.setupFields(current);
  }

  UiElement _createUsernameInput(String value){
    var el_in = new UiInputText("Username");
    el_in.setValue(value);
    el_in.onValueChange = (String newValue){
      menu.settings.user_name.v = newValue;
      menu.settings.saveToCookie();
    };
    var el = UiPanelForm();
    el.append(el_in);
    return el;
  }

  String _createPreviewFromModel(dynamic model, GlColor c1, GlColor c2){
    GlPreview preview = new GlPreview(200.0,150.0,(GlModelCollection modelCollection){
      model.loadModel(modelCollection);
      var instance = model
          .getModelInstance(modelCollection, c1, c2, new GlColor(0.7, 0.7, 0.9),"car");

      return [instance];

    },menu.settings.client_renderType.v == GameRenderType.Textures);
    preview.ox = 0.0;
    preview.oy = 26.0;
    preview.oz = 200.0;
    preview.rx = 1.0;
    preview.ry = 2.6;
    preview.rz = 5.8;
    preview.lx = 0.0;
    preview.ly = 0.5;
    preview.lz = -1.0;
    preview.lightImpact = 0.3;

    preview.create();
    preview.layer.setTexture("car", _textureGenerator.CreateTexture(c1, c2,"textures/texture_vehicle1").canvas);
    preview.draw();
    return preview.layer.canvas.toDataUrl("image/png");
  }
}


class ColorSelection{
  VehicleThemeColor selectedColor = null;
  Map<VehicleThemeColor, UiElement> _colorToElement;
  OnColorChange onColorChange;

  ColorSelection(this.onColorChange);

  UiElement setupFields(VehicleThemeColor initialColor){
    var el = new UiPanel();
    el.addStyle("colorSelection");
    _colorToElement = {};
    for(VehicleThemeColor color in VehicleThemeColor.values){
      var el_color = _createColorButton(color);
      _colorToElement[color] = el_color;
      el.append(el_color);
    }
    setCurrentColor(initialColor);
    return el;
  }

  void setCurrentColor(VehicleThemeColor color){
    if(selectedColor != null) _colorToElement[selectedColor].removeStyle("selected");
    selectedColor = color;
    _colorToElement[selectedColor].addStyle("selected");
    if(selectedColor != null) onColorChange(color);
  }

  UiElement _createColorButton(VehicleThemeColor color){
    var el = new UiPanel();
    el.addStyle("colorSelectionItem");
    el.element.style.backgroundColor = colorMappingCss[color];
    el.element.onClick.listen((Event e){setCurrentColor(color);});
    return el;
  }
}