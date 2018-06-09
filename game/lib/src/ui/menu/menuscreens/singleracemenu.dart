part of game.menu;

class SingleRaceMenu extends GameMenuScreen{
  GameMenuController menu;
  GameBuilder _gameBuilder;
  GameInputSelection _vehicleSelection;
  GameInputSelection _trailerSelection;
  GameInputSelection _levelSelection;
  InputElement _in_laps;
  InputElement _in_oponents;

  SingleRaceMenu(this.menu) : super("Single Race"){
    _gameBuilder = new GameBuilder(menu.settings);
  }

  Element setupFields()
  {
    closebutton = false;

    Element el = super.setupFields();

    _vehicleSelection = new GameInputSelectionVehicle();
    _trailerSelection = new GameInputSelectionTrailer();
    _levelSelection = new GameInputSelection(1);

    el.append(_vehicleSelection.element);
    el.append(_trailerSelection.element);
    el.append(_levelSelection.element);

    _in_laps = new InputElement();
    _in_laps.type = "number";
    _in_laps.value = "3";
    el.appendText("Laps:");
    el.append(_in_laps);
    _in_oponents = new InputElement();
    _in_oponents.type = "number";
    _in_oponents.value = "3";
    el.appendText("Oponents:");
    el.append(_in_oponents);

    el.append(createMenuButtonWithIcon("Start","play_arrow",(Event e){
      menu.showPlayGameMenu(createGameInput());
    }));

    _vehicleSelection.onIndexChanged(-1, 0);
    _trailerSelection.onIndexChanged(-1, 0);

    return el;
  }

  GameInput createGameInput(){
    return _gameBuilder.newGameRandomPlayers(int.parse(_in_oponents.value),VehicleType.values[_vehicleSelection.index], TrailerType.values[_trailerSelection.index],"", int.parse(_in_laps.value));
  }
}

class GameInputSelectionVehicle extends GameInputSelectionVehicleBase{

  GameInputSelectionVehicle() : super(VehicleType.values.length){
    _typeToPreview[VehicleType.Car.index] = _createPreviewFromModel(new GlModel_Vehicle());
    _typeToPreview[VehicleType.Truck.index] = _createPreviewFromModel(new GlModel_Truck());
    _typeToPreview[VehicleType.Formula.index] = _createPreviewFromModel(new GlModel_Formula());
  }
}
class GameInputSelectionTrailer extends GameInputSelectionVehicleBase{
  GameInputSelectionTrailer() : super(TrailerType.values.length){
    _typeToPreview[TrailerType.Caravan.index] = _createPreviewFromModel(new GlModel_Caravan());
    _typeToPreview[TrailerType.TruckTrailer.index] = _createPreviewFromModel(new GlModel_TruckTrailer());
  }
}
class GameInputSelectionVehicleBase extends GameInputSelection
{
  Map<int, String> _typeToPreview = {};
  ImageElement img_preview;

  GameInputSelectionVehicleBase(int optionsLength) : super(optionsLength){
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

  String _createPreviewFromModel(dynamic model){
    GlPreview preview = new GlPreview(150.0,100.0,(GlModelCollection modelCollection){
      model.loadModel(modelCollection);
      var instance = model
          .getModelInstance(modelCollection, new GlColor(0.8, 0.4, 0.0), new GlColor(1.0, 1.0, 1.0), new GlColor(0.7, 0.7, 0.9));

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

  GameInputSelection(this._optionsLength){
    element = new DivElement();
    element.className = "GameInputSelection";
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