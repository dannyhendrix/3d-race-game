part of game.leveleditor;

enum ClickToAddOptions { None, CheckPoint, Tree, Wall }

class LevelEditor extends UiPanel {
  ILifetime _lifetime;

  GameLevelLoader _levelLoader;
  GameLevelSaver _levelSaver;

  GameLevel gamelevel = new GameLevel();

  EditorMenuCollection _menus;
  UiPanel _levelwrapper;
  UiPanel _menuwrapper;
  Preview _preview;
  LevelObjectWrapperWalls _walls;
  LevelObjectWrapperStaticObjects _staticObjects;
  LevelObjectWrapperCheckpoints _checkPoints;
  List<LevelObjectWrapper> _wrappers;

  ClickToAddOptions _currentClickOption = ClickToAddOptions.None;
  LevelObject _currentLevelObject = null;
  //TODO: connect scale to all levelObjects
  double _scale = 0.5;

  LevelEditor(ILifetime lifetime) : super(lifetime) {
    _lifetime = lifetime;
    _levelLoader = lifetime.resolve();
    _levelSaver = lifetime.resolve();
    _preview = lifetime.resolve();
    _levelwrapper = lifetime.resolve();
    _menuwrapper = lifetime.resolve();
    _walls = lifetime.resolve();
    _staticObjects = lifetime.resolve();
    _checkPoints = lifetime.resolve();
    _menus = lifetime.resolve();
    _wrappers = [_checkPoints, _walls, _staticObjects];
    _menus.setEditor(this);
    gamelevel.path = new GameLevelPath();
  }
  @override
  void build() {
    super.build();
    _levelwrapper.element.onMouseDown.listen(_onLevelMouseDown);
    _levelwrapper.addStyle("levelWrapper");
    _levelwrapper.append(_preview);
    _wrappers.forEach((o) => _levelwrapper.append(o));
    _menuwrapper.addStyle("menuWrapper");
    _menus.appendAllTo(_menuwrapper);
    append(_levelwrapper);
    append(_menuwrapper);
  }

  void _onLevelMouseDown(MouseEvent e) {
    switch (_currentClickOption) {
      case ClickToAddOptions.CheckPoint:
        _addNewCheckpoint(e.offset.x / _scale, e.offset.y / _scale);
        return;
      case ClickToAddOptions.Tree:
        _addNewStaticObject(e.offset.x / _scale, e.offset.y / _scale);
        return;
      case ClickToAddOptions.Wall:
        _addNewWall(e.offset.x / _scale, e.offset.y / _scale);
        return;
      default:
        return;
    }
  }

  void deleteLevelObject(LevelObject obj) {
    if (obj is LevelObjectWall) {
      gamelevel.walls.remove(obj.gameObject);
      _walls.removeLevelObject(obj);
    } else if (obj is LevelObjectStaticObject) {
      gamelevel.staticobjects.remove(obj.gameObject);
      _staticObjects.removeLevelObject(obj);
    } else if (obj is LevelObjectCheckpoint) {
      gamelevel.path.checkpoints.remove(obj.gameObject);
      _checkPoints.removeLevelObject(obj);
      _preview.paintLevel(gamelevel);
    }
    _menus.onDeleteObject(obj);
    _menus.onGameLevelChange(gamelevel);
  }

  void _addNewWall(double x, double y) {
    GameLevelWall gameObject;
    if (_currentLevelObject is LevelObjectWall) {
      LevelObjectWall sourceLevelObject = _currentLevelObject;
      GameLevelWall source = sourceLevelObject.gameObject;
      gameObject = new GameLevelWall(x, y, source.r, source.w, source.d, source.h);
    } else
      gameObject = new GameLevelWall(x, y, 0.0, 100.0, 50.0, 100.0);
    gamelevel.walls.add(gameObject);
    _addWallToLevelObjects(gameObject);
  }

  void _addWallToLevelObjects(GameLevelWall gameObject) {
    LevelObjectWall levelObj = _lifetime.resolve<LevelObjectWall>()..gameObject = gameObject;
    levelObj.onSelect = _onSelect;
    levelObj.onPropertyChanged = _onProperyChange;
    _walls.addLevelObject(levelObj);
    _menus.onGameLevelChange(gamelevel);
    levelObj.updateElement();
    levelObj.updateProperties();
  }

  void _addNewCheckpoint(double x, double y) {
    GameLevelCheckPoint gameObject;
    if (_currentLevelObject is LevelObjectCheckpoint) {
      LevelObjectCheckpoint sourceLevelObject = _currentLevelObject;
      GameLevelCheckPoint source = sourceLevelObject.gameObject;
      gameObject = new GameLevelCheckPoint(x, y, source.width, source.angle, source.lengthBefore, source.lengthAfter);
      int index = gamelevel.path.checkpoints.indexOf(source);
      gamelevel.path.checkpoints.insert(index + 1, gameObject);
    } else {
      gameObject = new GameLevelCheckPoint(x, y, 100.0, 0.0, 100.0, 100.0);
      gamelevel.path.checkpoints.add(gameObject);
    }
    _addCheckpointToLevelObjects(gameObject, true);
  }

  void _addCheckpointToLevelObjects(GameLevelCheckPoint gameObject, [bool autoAngle = false]) {
    LevelObjectCheckpoint levelObj = _lifetime.resolve<LevelObjectCheckpoint>()..gameObject = gameObject;
    if (autoAngle) levelObj.autoAngle();
    levelObj.onSelect = _onSelect;
    levelObj.onPropertyChanged = (o) {
      _onProperyChange(o);
      _preview.paintLevel(gamelevel);
    };
    _checkPoints.addLevelObject(levelObj);
    _preview.paintLevel(gamelevel);
    _menus.onGameLevelChange(gamelevel);
    levelObj.updateElement();
    levelObj.updateProperties();
  }

  void _addNewStaticObject(double x, double y) {
    GameLevelStaticObject gameObject;
    if (_currentLevelObject is GameLevelStaticObject) {
      LevelObjectStaticObject sourceLevelObject = _currentLevelObject;
      GameLevelStaticObject source = sourceLevelObject.gameObject;
      gameObject = new GameLevelStaticObject(source.id, x, y, source.r);
    } else
      gameObject = new GameLevelStaticObject(0, x, y, 100.0);
    gamelevel.staticobjects.add(gameObject);
    _addStaticObjectToLevelObjects(gameObject);
  }

  void _addStaticObjectToLevelObjects(GameLevelStaticObject gameObject) {
    LevelObjectStaticObject levelObj = _lifetime.resolve<LevelObjectStaticObject>()..gameObject = gameObject;
    levelObj.onSelect = _onSelect;
    levelObj.onPropertyChanged = _onProperyChange;
    _staticObjects.addLevelObject(levelObj);
    _menus.onGameLevelChange(gamelevel);
    levelObj.updateElement();
    levelObj.updateProperties();
  }

  void _onSelect(LevelObject obj) {
    if (_currentLevelObject != null) _currentLevelObject.onDeselect();
    _currentLevelObject = obj;
    _menus.onSelectObject(obj);
  }

  void _onProperyChange(LevelObject obj) {
    _menus.onGameLevelChange(gamelevel);
  }

  void load(GameLevel level) {
    loadFromJson(_levelSaver.levelToJson(level));
  }

  void loadFromJson(Map json) {
    gamelevel = _levelLoader.loadLevelJson(json);
    _wrappers.forEach((w) => w.clearAll());
    for (GameLevelWall gameObject in gamelevel.walls) {
      _addWallToLevelObjects(gameObject);
    }
    for (GameLevelCheckPoint gameObject in gamelevel.path.checkpoints) {
      _addCheckpointToLevelObjects(gameObject);
    }
    for (GameLevelStaticObject gameObject in gamelevel.staticobjects) {
      _addStaticObjectToLevelObjects(gameObject);
    }
    _preview.paintLevel(gamelevel);
  }

  String saveToJson() {
    var json = _levelSaver.levelToJson(gamelevel);
    return jsonEncode(json);
  }
}
