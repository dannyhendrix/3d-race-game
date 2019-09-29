part of game.menu;

class GameInputSelectionVehicle extends GameInputSelectionVehicleBase{
  Element setupFieldsForVehicles(){
    _typeToPreview[VehicleType.Car.index] = _createPreviewFromModel(new GlModel_Vehicle());
    _typeToPreview[VehicleType.Truck.index] = _createPreviewFromModel(new GlModel_Truck());
    _typeToPreview[VehicleType.Formula.index] = _createPreviewFromModel(new GlModel_Formula());
    _typeToPreview[VehicleType.Pickup.index] = _createPreviewFromModel(new GlModel_Pickup());
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
class GameInputSelectionVehicleBase extends GameInputSelectionInt
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
    preview.lx = 0.0;
    preview.ly = 0.5;
    preview.lz = -1.0;
    preview.lightImpact = 0.3;
    preview.create();
    preview.draw();
    return preview.layer.canvas.toDataUrl("image/png");
  }
}
class GameInputSelectionLevel extends GameInputSelection<String>{
  Map<int, String> _typeToPreview = {};
  Map<int, String> _indexToLevelKey = {};
  ImageElement img_preview;
  LevelManager _levelManager;
  Element el_customLevel;

  GameInputSelectionLevel(this._levelManager);

  Element setupFieldsForLevels(Element customLevelElement, bool enableCustomLevels){
    var levelKeys = _levelManager.getLevelKeys();
    Element el = setupFields(levelKeys.length+(enableCustomLevels?1:0), "Track");
    int i = 0;
    for(var level in levelKeys){
      _typeToPreview[i] = _createPreviewFromModel(_levelManager.getLevel(level));
      _indexToLevelKey[i] = level;
      i++;
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

  getSelectedValue() => _indexToLevelKey[index];
}

abstract class GameInputSelectionInt extends GameInputSelection<int>{
  getSelectedValue() => index;
}

abstract class GameInputSelection<T>{
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
  T getSelectedValue();
}