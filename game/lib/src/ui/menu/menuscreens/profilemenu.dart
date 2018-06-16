part of game.menu;

typedef void OnColorChange(VehicleThemeColor newColor);

class ProfileMenu extends GameMenuScreen{
  GameMenuController menu;
  ProfileMenu(this.menu);

  ImageElement _el_vehiclePreview;

  Element setupFields()
  {
    Element el = super.setupFields();

    _el_vehiclePreview = new ImageElement();

    el.append(_createUsernameInput(menu.settings.user_name.v));
    el.append(_el_vehiclePreview);
    el.append(_createColorSelect(menu.settings.user_color1.v, (VehicleThemeColor newColor){ menu.settings.user_color1.v = newColor; _onColorChange();}));
    el.append(_createColorSelect(menu.settings.user_color2.v, (VehicleThemeColor newColor){ menu.settings.user_color2.v = newColor; _onColorChange();}));

    closebutton = false;

    _onColorChange();

    //add(createOpenMenuButton("Options",TeamxMenuController.MENU_OPTION));
    return el;
  }

  void _onColorChange(){
    _el_vehiclePreview.src = _createPreviewFromModel(new GlModel_Vehicle(), colorMappingGl[menu.settings.user_color1.v], colorMappingGl[menu.settings.user_color2.v]);
  }

  Element _createColorSelect(VehicleThemeColor current, OnColorChange onColorChange){
    /*SelectElement el = new SelectElement();
    for(var x in VehicleThemeColor.values){
      el.append(new OptionElement(data:x.toString()));
    }
    el.selectedIndex = current.index;
    el.onChange.listen((Event e){
      onColorChange(VehicleThemeColor.values[el.selectedIndex]);
      menu.settings.saveToCookie();
      _onColorChange();
    });
    return el;*/
    ColorSelection cs = new ColorSelection(onColorChange);
    return cs.setupFields(current);
  }

  Element _createUsernameInput(String value){
    Element el = new DivElement();
    el.id = "profile_username";
    InputElement el_in = new InputElement();
    el_in.onChange.listen((Event e){
      menu.settings.user_name.v = el_in.value;
      menu.settings.saveToCookie();
    });
    el_in.value = value;
    el.append(el_in);
    return el;
  }

  String _createPreviewFromModel(dynamic model, GlColor c1, GlColor c2){
    GlPreview preview = new GlPreview(150.0,100.0,(GlModelCollection modelCollection){
      model.loadModel(modelCollection);
      var instance = model
          .getModelInstance(modelCollection, c1, c2, new GlColor(0.7, 0.7, 0.9));

      return [instance];

    });
    preview.ox = 0.0;
    preview.oy = 26.0;
    preview.oz = 240.0;
    preview.rx = 1.0;
    preview.ry = 2.6;
    preview.rz = 5.8;
    preview.lx = 0.3;
    preview.ly = 0.7;
    preview.lz = 0.1;
    preview.create();
    preview.draw();
    return preview.layer.canvas.toDataUrl("image/png");
  }
}


class ColorSelection{
  VehicleThemeColor selectedColor = null;
  Map<VehicleThemeColor, Element> _colorToElement;
  OnColorChange onColorChange;

  ColorSelection(this.onColorChange);

  Element setupFields(VehicleThemeColor initialColor){
    Element el = new DivElement();
    el.className = "colorSelection";
    _colorToElement = {};
    for(VehicleThemeColor color in VehicleThemeColor.values){
      Element el_color = _createColorButton(color);
      _colorToElement[color] = el_color;
      el.append(el_color);
    }
    setCurrentColor(initialColor);
    return el;
  }

  void setCurrentColor(VehicleThemeColor color){
    if(selectedColor != null) _colorToElement[selectedColor].classes.remove("selected");
    selectedColor = color;
    _colorToElement[selectedColor].classes.add("selected");
    if(selectedColor != null) onColorChange(color);
  }

  Element _createColorButton(VehicleThemeColor color){
    Element el = new DivElement();
    el.className = "colorSelectionItem";
    el.style.backgroundColor = colorMappingCss[color];
    el.onClick.listen((Event e){setCurrentColor(color);});
    return el;
  }
}