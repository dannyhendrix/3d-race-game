part of game.menu;

class GameInputSelectionVehicle extends GameInputSelectionVehicleBase<VehicleType> {
  GameInputSelectionVehicle(ILifetime lifetime) : super(lifetime);

  @override
  void build() {
    super.build();
    changeLabel("Vehicle");
    _typeToPreview[VehicleType.Car.index] = _createPreviewFromModel(new GlModel_Vehicle());
    _typeToPreview[VehicleType.Truck.index] = _createPreviewFromModel(new GlModel_Truck());
    _typeToPreview[VehicleType.Formula.index] = _createPreviewFromModel(new GlModel_Formula());
    _typeToPreview[VehicleType.Pickup.index] = _createPreviewFromModel(new GlModel_Pickup());
    setOptions(VehicleType.values);
  }

  @override
  int getIndex(VehicleType item) {
    return item.index;
  }
}

class GameInputSelectionTrailer extends GameInputSelectionVehicleBase<TrailerType> {
  GameInputSelectionTrailer(ILifetime lifetime) : super(lifetime);

  @override
  void build() {
    super.build();
    changeLabel("Trailer");
    _typeToPreview[TrailerType.None.index] = _createPreviewFromModel(null);
    _typeToPreview[TrailerType.Caravan.index] = _createPreviewFromModel(new GlModel_Caravan());
    _typeToPreview[TrailerType.TruckTrailer.index] = _createPreviewFromModel(new GlModel_TruckTrailer());
    setOptions(TrailerType.values);
  }

  @override
  int getIndex(TrailerType item) {
    return item.index;
  }
}

abstract class GameInputSelectionVehicleBase<T> extends UiInputOptionCycle<T> {
  Map<int, String> _typeToPreview = {};
  ImageElement img_preview;

  GameInputSelectionVehicleBase(ILifetime lifetime) : super(lifetime) {
    img_preview = new ImageElement();
  }

  @override
  void build() {
    super.build();
    addStyle("GameInputSelection");
    appendElementToContent(img_preview);
  }

  @override
  void setValue(T value) {
    super.setValue(value);
    int index = getIndex(value);
    if (_typeToPreview.containsKey(index)) {
      img_preview.src = _typeToPreview[index];
    } else {
      img_preview.src = "";
    }
  }

  int getIndex(T item);

//TODO: remove dynamic?
  String _createPreviewFromModel(dynamic model) {
    GlPreview preview = new GlPreview(150.0, 100.0, (GlModelCollection modelCollection) {
      if (model == null) return [];
      model.loadModel(modelCollection);
      var instance = model.getModelInstance(modelCollection, colorMappingGl[VehicleThemeColor.White], colorMappingGl[VehicleThemeColor.White], new GlColor(0.7, 0.7, 0.9));

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
