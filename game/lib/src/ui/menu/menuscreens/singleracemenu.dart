part of game.menu;

class SingleRaceMenu extends GameMenuScreen{
  GameMenuController menu;
  GameInputSelectionVehicle _vehicleSelection;
  GameInputSelectionTrailer _trailerSelection;
  GameInputSelectionLevel _levelSelection;
  InputFormRadio _in_laps;
  InputFormRadio _in_oponents;
  TextAreaElement in_levelJson;

  SingleRaceMenu(this.menu){
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
    _levelSelection = new GameInputSelectionLevel(menu.levelManager);

    _in_oponents = new InputFormRadio("Oponents", [0,1,2,3,4]);
    Element el_oponents = _in_oponents.createElement();
    _in_oponents.setValue(3);

    _in_laps = new InputFormRadio("Laps",[1,2,3,5,10]);
    Element el_laps = _in_laps.createElement();
    _in_laps.setValue(2);

    el_left.append(_levelSelection.setupFieldsForLevels(_createLevelJsonInput(),menu.settings.levels_allowJsonInput.v));

    el_left.append(el_laps);

    el_right.append(_vehicleSelection.setupFieldsForVehicles());
    el_right.append(_trailerSelection.setupFieldsForTrailers());
    el_right.append(el_oponents);

    el.append(createMenuButtonWithIcon("Start","play_arrow",(Event e){
      menu.showMenu(new GameInputMenuStatus("Single race", createGameInput(), (GameOutput result){
        menu.showMenu(new GameOutputMenuStatus("Race results", result));
      }));
    }));

    _vehicleSelection.onIndexChanged(-1, 0);
    _trailerSelection.onIndexChanged(-1, 0);
    _levelSelection.onIndexChanged(-1, 0);

    return el;
  }

  Element _createLevelJsonInput(){
    Element el = new DivElement();
    in_levelJson = new TextAreaElement();
    in_levelJson.className = "leveljson";
    AnchorElement el_editorLink = new AnchorElement();
    el_editorLink.href = menu.settings.editor_location.v;
    el_editorLink.className = "button";
    el_editorLink.text = "Open level editor";
    el_editorLink.target = "_blank";
    el.append(in_levelJson);
    el.append(new BRElement());
    el.append(el_editorLink);
    return el;
  }

  GameInput createGameInput(){
    var levelLoader = new GameLevelLoader();
    var level = (in_levelJson != null && in_levelJson.value.isNotEmpty) ? levelLoader.loadLevelJson(jsonDecode(in_levelJson.value)) : menu.levelManager.loadedLevels[_levelSelection.index];
    return menu.gameBuilder.newGameRandomPlayers(_in_oponents.getValue(),VehicleType.values[_vehicleSelection.index], TrailerType.values[_trailerSelection.index],level, _in_laps.getValue());
  }
}

class GameInputSelectionVehicle extends GameInputSelectionVehicleBase{
  Element setupFieldsForVehicles(){
    _typeToPreview[VehicleType.Car.index] = _createPreviewFromModel(new GlModel_Vehicle());
    _typeToPreview[VehicleType.Truck.index] = _createPreviewFromModel(new GlModel_Truck());
    _typeToPreview[VehicleType.Formula.index] = _createPreviewFromModel(new GlModel_Formula());
    return setupFieldsForVehiclesBase(VehicleType.values.length, "Vehicle");
  }
}
class GameInputSelectionTrailer extends GameInputSelectionVehicleBase{
  Element setupFieldsForTrailers(){
    _typeToPreview[TrailerType.None.index] = _createPreviewFromModel(null);
    _typeToPreview[TrailerType.Caravan.index] = _createPreviewFromModel(new GlModel_Caravan());
    _typeToPreview[TrailerType.TruckTrailer.index] = _createPreviewFromModel(new GlModel_TruckTrailer());
    return setupFieldsForVehiclesBase(TrailerType.values.length, "Trailer");
  }
}
class GameInputSelectionVehicleBase extends GameInputSelection
{
  Map<int, String> _typeToPreview = {};
  ImageElement img_preview;

  Element setupFieldsForVehiclesBase(int numberOfOptions, [String label]){
    Element el = setupFields(numberOfOptions, label);
    img_preview = new ImageElement();
    el_content.append(img_preview);
    return el;
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
class GameInputSelectionLevel extends GameInputSelection{
  Map<int, String> _typeToPreview = {};
  ImageElement img_preview;
  LevelManager _levelManager;
  Element el_customLevel;

  GameInputSelectionLevel(this._levelManager);

  Element setupFieldsForLevels(Element customLevelElement, bool enableCustomLevels){
    Element el = setupFields(_levelManager.loadedLevels.length+(enableCustomLevels?1:0), "Track");
    int i = 0;
    for(GameLevel level in _levelManager.loadedLevels.values){
      _typeToPreview[i++] = _createPreviewFromModel(level);
    }
    img_preview = new ImageElement();
    el_customLevel = customLevelElement;
    el_content.append(img_preview);
    el_content.append(el_customLevel);
    el_customLevel.style.display = "none";
    return el;
  }

  void onIndexChanged(int oldIndex, int newIndex){
    if(_typeToPreview.containsKey(newIndex))
    {
      img_preview.src = _typeToPreview[newIndex];
      img_preview.style.display = "";
      el_customLevel.style.display = "none";
    }
    else{
      img_preview.src = "";
      el_customLevel.style.display = "";
      img_preview.style.display = "none";
    }
  }
  String _createPreviewFromModel(GameLevel level){
    LevelPreview preview = new LevelPreview(150.0,100.0);
    preview.create();
    preview.draw(level, "#666");
    return preview.layer.canvas.toDataUrl("image/png");
  }
}
class GameInputSelection{
  Element _btn_next;
  Element _btn_prev;
  Element el_content;
  int index = 0;
  Element element;

  Element setupFields(int optionsLength, [String label=""]){
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
        index = optionsLength-1;
      onIndexChanged(oldIndex, index);
    });
    _btn_next = createButtonWithIcon("navigate_next", (Event e){
      int oldIndex = index++;
      if(index >= optionsLength)
        index = 0;
      onIndexChanged(oldIndex, index);
    });
    el_content = new DivElement();
    el_content.className = "content";

    element.append(_btn_prev);
    element.append(el_content);
    element.append(_btn_next);
    return element;
  }
  void onIndexChanged(int oldIndex, int newIndex){
    el_content.text = newIndex.toString();
  }
  Element createButtonWithIcon(String icon, Function onClick)
  {
    Element btn = UIHelper.createButtonWithIcon(icon, onClick);
    btn.className = "navigate";
    return btn;
  }
}