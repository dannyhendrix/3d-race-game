part of game.menu;

class SingleRaceMenu extends GameMenuScreen{
  GameMenuController menu;
  GameBuilder _gameBuilder;
  GameInputSelection _vehicleSelection;
  GameInputSelection _trailerSelection;
  GameInputSelection _levelSelection;
  IntValueSelection _in_laps;
  IntValueSelection _in_oponents;

  SingleRaceMenu(this.menu){
    _gameBuilder = new GameBuilder(menu.settings);
  }

  Element setupFields()
  {
    closebutton = false;

    Element el = super.setupFields();
    Element el_left = new DivElement();
    Element el_right = new DivElement();
    el_left.className = "leftPanel";
    el_right.className = "rightPanel";
    el.append(el_left);
    el.append(el_right);

    _vehicleSelection = new GameInputSelectionVehicle();
    _trailerSelection = new GameInputSelectionTrailer();
    _levelSelection = new GameInputSelection(1, "Track");

    _in_oponents = new IntValueSelection((int newValue){});
    Element el_oponents = _in_oponents.setupFields(3,[0,1,2,3,4], "Oponents");

    _in_laps = new IntValueSelection((int newValue){});
    Element el_laps = _in_laps.setupFields(3,[1,2,3,5,10], "Laps");

    el_left.append(_levelSelection.element);
    el_left.append(el_laps);

    el_right.append(_vehicleSelection.element);
    el_right.append(_trailerSelection.element);
    el_right.append(el_oponents);

    el.append(createMenuButtonWithIcon("Start","play_arrow",(Event e){
      menu.showMenu(new GameInputMenuStatus("Single race", createGameInput(), (GameOutput result){
        menu.showMenu(new GameOutputMenuStatus("Race results", result));
      }));
    }));

    _vehicleSelection.onIndexChanged(-1, 0);
    _trailerSelection.onIndexChanged(-1, 0);

    return el;
  }

  GameInput createGameInput(){
    return _gameBuilder.newGameRandomPlayers(_in_oponents.value,VehicleType.values[_vehicleSelection.index], TrailerType.values[_trailerSelection.index],"", _in_laps.value);
  }
}

class GameInputSelectionVehicle extends GameInputSelectionVehicleBase{

  GameInputSelectionVehicle() : super(VehicleType.values.length, "Vehicle"){
    _typeToPreview[VehicleType.Car.index] = _createPreviewFromModel(new GlModel_Vehicle());
    _typeToPreview[VehicleType.Truck.index] = _createPreviewFromModel(new GlModel_Truck());
    _typeToPreview[VehicleType.Formula.index] = _createPreviewFromModel(new GlModel_Formula());
  }
}
class GameInputSelectionTrailer extends GameInputSelectionVehicleBase{
  GameInputSelectionTrailer() : super(TrailerType.values.length, "Trailer"){
    _typeToPreview[TrailerType.None.index] = _createPreviewFromModel(null);
    _typeToPreview[TrailerType.Caravan.index] = _createPreviewFromModel(new GlModel_Caravan());
    _typeToPreview[TrailerType.TruckTrailer.index] = _createPreviewFromModel(new GlModel_TruckTrailer());
  }
}
class GameInputSelectionVehicleBase extends GameInputSelection
{
  Map<int, String> _typeToPreview = {};
  ImageElement img_preview;

  GameInputSelectionVehicleBase(int optionsLength, String label) : super(optionsLength, label){
    img_preview = new ImageElement();
    el_content.append(img_preview);
  }

  void onIndexChanged(int oldIndex, int newIndex){
    if(_typeToPreview.containsKey(newIndex))
    {
      img_preview.src = _typeToPreview[newIndex];
    }
    else{
      img_preview.src = "";
    }
  }
//TODO: remove dynamic?
  String _createPreviewFromModel(dynamic model){
    GlPreview preview = new GlPreview(150.0,100.0,(GlModelCollection modelCollection){
      if(model == null) return [];
      model.loadModel(modelCollection);
      var instance = model
          .getModelInstance(modelCollection, colorMappingGl[VehicleThemeColor.White], colorMappingGl[VehicleThemeColor.White], new GlColor(0.7, 0.7, 0.9));

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
class GameInputSelection{
  Element _btn_next;
  Element _btn_prev;
  Element el_content;
  int index = 0;
  int _optionsLength = 0;
  Element element;

  GameInputSelection(this._optionsLength, [String label=""]){
    element = new DivElement();
    element.className = "GameInputSelection";

    if(label.isNotEmpty){
      Element el_label = new DivElement();
      el_label.className = "label";
      el_label.text = label;
      element.append(el_label);
    }

    _btn_prev = createButtonWithIcon("navigate_before", (Event e){
      int oldIndex = index--;
      if(index < 0)
        index = _optionsLength-1;
      onIndexChanged(oldIndex, index);
    });
    _btn_next = createButtonWithIcon("navigate_next", (Event e){
      int oldIndex = index++;
      if(index >= _optionsLength)
        index = 0;
      onIndexChanged(oldIndex, index);
    });
    el_content = new DivElement();
    el_content.className = "content";

    element.append(_btn_prev);
    element.append(el_content);
    element.append(_btn_next);
  }
  void onIndexChanged(int oldIndex, int newIndex){
    el_content.text = newIndex.toString();
  }
  Element createButtonWithIcon(String icon, Function onClick)
  {
    DivElement btn = new DivElement();
    btn.className = "navigate button";
    btn.onClick.listen((MouseEvent e){ e.preventDefault(); onClick(e); });
    btn.onTouchStart.listen((TouchEvent e){ e.preventDefault(); onClick(e); });
    btn.append(createIcon(icon));
    return btn;
  }
  Element createIcon(String icon)
  {
    Element iel = new Element.tag("i");
    iel.className = "material-icons";
    iel.text = icon.toLowerCase();
    return iel;
  }
}

typedef void OnIntValueChange(int newValue);
class IntValueSelection{
  int value = null;
  Map<int, Element> _valueToElement;
  OnIntValueChange onValueChange;

  IntValueSelection(this.onValueChange);

  Element setupFields(int initialValue, List<int> allowedValues, [String label = ""]){
    Element el = new DivElement();
    el.className = "intSelection";

    if(label.isNotEmpty){
      Element el_label = new DivElement();
      el_label.className = "label";
      el_label.text = label;
      el.append(el_label);
    }

    _valueToElement = {};
    for(int allowedValue in allowedValues){
      Element el_item = _createOption(allowedValue);
      _valueToElement[allowedValue] = el_item;
      el.append(el_item);
    }
    setCurrent(initialValue);
    return el;
  }

  void setCurrent(int newValue){
    if(value != null) _valueToElement[value].classes.remove("selected");
    value = newValue;
    _valueToElement[value].classes.add("selected");
    if(value != null) onValueChange(newValue);
  }

  Element _createOption(int optionValue){
    Element el = new DivElement();
    el.className = "selectionItem button";
    el.text = optionValue.toString();
    el.onClick.listen((Event e){setCurrent(optionValue);});
    return el;
  }
}