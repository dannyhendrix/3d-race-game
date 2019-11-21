part of game.menu;

class GameInputSelectionLevel extends UiInputOptionCycle<String>{
  Map<int, String> _typeToPreview = {};
  Map<int, String> _indexToLevelKey = {};
  ImageElement img_preview;
  LevelManager _levelManager;
  GameLevelLoader _levelLoader;
  GameSettings _settings;
  CustomLevelInput _customLevelInput;
  LevelPreview _preview;

  GameInputSelectionLevel(ILifetime lifetime) : super(lifetime){
    _levelManager = lifetime.resolve();
    _customLevelInput = lifetime.resolve();
    _settings = lifetime.resolve();
    _levelLoader = lifetime.resolve();
    _preview = lifetime.resolve();
    img_preview = new ImageElement();
  }

  @override
  void build(){
    var levelKeys = _levelManager.getLevelKeys();
    optionsLength = levelKeys.length;
    if(_settings.levels_allowJsonInput.v) optionsLength += 1;
    super.build();
    //var el = setupFields(levelKeys.length+(enableCustomLevels?1:0), "Track");
    changeLabel("Track");
    addStyle("GameInputSelection");

    int i = 0;
    for(var level in levelKeys){
      _typeToPreview[i] = _createPreviewFromModel(_levelManager.getLevel(level));
      _indexToLevelKey[i] = level;
      i++;
    }
    appendElementToContent(img_preview);
    appendToContent(_customLevelInput);
    _customLevelInput.hide();
  }
  @override
  void setValueIndex(int index){
    if(_typeToPreview.containsKey(index))
    {
      img_preview.src = _typeToPreview[index];
      img_preview.style.display = "";
      _customLevelInput.hide();
    }
    else{
      img_preview.src = "";
      _customLevelInput.show();
      img_preview.style.display = "none";
    }
  }
  String _createPreviewFromModel(GameLevel level){
    _preview.setSize(150,100);
    _preview.clear();
    _preview.draw(level, "#666");
    return _preview.canvas.toDataUrl("image/png");
  }

  getValue() => _indexToLevelKey[index];

  GameLevel getSelectedLevel(){
    if(_typeToPreview.containsKey(index)) return _levelManager.getLevel(_indexToLevelKey[index]);
    var customInput = _customLevelInput.getValue();
    if(customInput.isNotEmpty) return _levelLoader.loadLevelJson(jsonDecode(customInput));
    throw new Exception("Constum level is not set");
  }
}