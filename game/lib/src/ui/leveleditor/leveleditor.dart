part of game.leveleditor;

enum ClickToAddOptions {None, CheckPoint, Tree, Wall}

class LevelEditor{
  TextAreaElement el_txt;
  GameLevel gamelevel = new GameLevel();
  Preview preview = new Preview();
  LevelObjectWrapper walls = new LevelObjectWrapper();
  LevelObjectWrapper staticObjects = new LevelObjectWrapper();
  LevelObjectWrapper checkPoints = new LevelObjectWrapper();
  List<LevelObjectWrapper> wrappers;
  LevelObjectMenu menu = new LevelObjectMenu();
  GameLevelLoader levelLoader = new GameLevelLoader();
  GameLevelSaver levelSaver = new GameLevelSaver();

  ClickToAddOptions _currentClickOption = ClickToAddOptions.None;
  LevelObject _currentLevelObject = null;
  //TODO: connect scale to all levelObjects
  double _scale = 0.5;

  LevelEditor(){
    wrappers = [checkPoints,walls,staticObjects];
    gamelevel.path = new GameLevelPath();
    menu.onLevelObjectDelete = _deleteLevelObject;
  }

  Element createElement(){
    Element el = new DivElement();
    Element el_levelwrap = new DivElement();
    el_levelwrap.onMouseDown.listen(_onLevelMouseDown);
    el_levelwrap.className = "levelWrapper";
    el_levelwrap.append(preview.createElement());
    wrappers.forEach((o)=>el_levelwrap.append(o.createElement()));
    el.append(el_levelwrap);
    Element el_right = new DivElement();
    el_right.className = "rightpanel";
    el_right.append(_createMenuCreate());
    el_right.append(_createMenuControls());
    el_right.append(_createMenuProperties());
    el_right.append(_createMenuClickAdd());
    el_right.append(_createMenuSaveLoad());
    el.append(el_right);
    return el;
  }
  void _onLevelMouseDown(MouseEvent e){
    //document.elementFromPoint(e.page.x, e.page.y).style.background = "red";

    LevelObjectWrapper wrapper;
    switch(_currentClickOption){
      case ClickToAddOptions.CheckPoint:
        _addNewCheckpoint(e.offset.x/_scale, e.offset.y/_scale);
        return;
      case ClickToAddOptions.Tree:
        _addNewStaticObject(e.offset.x/_scale, e.offset.y/_scale);
        return;
      case ClickToAddOptions.Wall:
        _addNewWall(e.offset.x/_scale, e.offset.y/_scale);
        return;
      default:
        return;
    }
    //wrapper.addNew(menu.onSelect,menu.onMove, e.offset.x/_scale, e.offset.y/_scale);
  }
  Element _createMenuProperties(){
    var uimenu = new UIMenu("Properties");
    var el = uimenu.createElement(false);
    el.className = "properties";
    uimenu.append(menu.createElement());
    return el;
  }
  Element _createMenuControls(){
    var uimenu = new UIMenu("Controls");
    var el = uimenu.createElement();
    el.className = "controls";
    uimenu.append(menu.createElementControls());
    return el;
  }
  Element _createMenuCreate(){
    var menu = new UIMenu("Add objects");
    var el_menu = menu.createElement();
    el_menu.className = "menu";

    menu.append(new UITextButton("New checkpoint", (Event e){
      _addNewCheckpoint(10.0,10.0);
    }).createElement());
    menu.append(new UITextButton("New wall", (Event e){
      _addNewWall(10.0,10.0);
    }).createElement());
    menu.append(new UITextButton("New tree", (Event e){
      _addNewStaticObject(10.0,10.0);
    }).createElement());

    return el_menu;
  }
  void _deleteLevelObject(LevelObject obj){
    if(obj is LevelObjectWall){
      gamelevel.walls.remove(obj.gameObject);
      walls.removeLevelObject(obj);
    }
    else if(obj is LevelObjectStaticObject){
      gamelevel.staticobjects.remove(obj.gameObject);
      staticObjects.removeLevelObject(obj);
    }
    else if(obj is LevelObjectCheckpoint){
      gamelevel.path.checkpoints.remove(obj.gameObject);
      checkPoints.removeLevelObject(obj);
      preview.paintLevel(gamelevel);
    }
    loadToTextArea();
  }
  void _addNewWall(double x, double y){
    GameLevelWall gameObject;
    if(_currentLevelObject is LevelObjectWall)
    {
      LevelObjectWall sourceLevelObject = _currentLevelObject;
      GameLevelWall source = sourceLevelObject.gameObject;
      gameObject = new GameLevelWall(x, y, source.r, source.w, source.d, source.h);
    }
    else
      gameObject = new GameLevelWall(x,y,0.0,100.0,50.0,100.0);
    gamelevel.walls.add(gameObject);
    _addWallToLevelObjects(gameObject);
  }
  void _addWallToLevelObjects(GameLevelWall gameObject){
    LevelObjectWall levelObj = new LevelObjectWall(this,gameObject);
    levelObj.onSelect = _onSelect;
    levelObj.onPropertyChanged = _onProperyChange;
    walls.addLevelObject(levelObj);
    loadToTextArea();
  }
  void _addNewCheckpoint(double x, double y){
    GameLevelCheckPoint gameObject;
    if(_currentLevelObject is LevelObjectCheckpoint)
    {
      LevelObjectCheckpoint sourceLevelObject = _currentLevelObject;
      GameLevelCheckPoint source = sourceLevelObject.gameObject;
      gameObject = new GameLevelCheckPoint(x, y, source.width, source.angle, source.lengthBefore, source.lengthAfter);
      int index = gamelevel.path.checkpoints.indexOf(source);
      gamelevel.path.checkpoints.insert(index+1, gameObject);
    }
    else
    {
      gameObject = new GameLevelCheckPoint(x, y, 100.0, 0.0, 100.0, 100.0);
      gamelevel.path.checkpoints.add(gameObject);
    }
    _addCheckpointToLevelObjects(gameObject, true);
  }
  void _addCheckpointToLevelObjects(GameLevelCheckPoint gameObject,[bool autoAngle = false]){
    LevelObjectCheckpoint levelObj = new LevelObjectCheckpoint(this,gameObject);
    if(autoAngle)levelObj.autoAngle();
    levelObj.onSelect = _onSelect;
    levelObj.onPropertyChanged = (o){_onProperyChange(o); preview.paintLevel(gamelevel);};
    checkPoints.addLevelObject(levelObj);
    preview.paintLevel(gamelevel);
    loadToTextArea();
  }
  void _addNewStaticObject(double x, double y){
    GameLevelStaticObject gameObject;
    if(_currentLevelObject is GameLevelStaticObject)
    {
      LevelObjectStaticObject sourceLevelObject = _currentLevelObject;
      GameLevelStaticObject source = sourceLevelObject.gameObject;
      gameObject = new GameLevelStaticObject(source.id, x, y, source.r);
    }
    else
      gameObject = new GameLevelStaticObject(0,x,y,100.0);
    gamelevel.staticobjects.add(gameObject);
    _addStaticObjectToLevelObjects(gameObject);
  }
  void _addStaticObjectToLevelObjects(GameLevelStaticObject gameObject){
    LevelObjectStaticObject levelObj = new LevelObjectStaticObject(this,gameObject);
    levelObj.onSelect = _onSelect;
    levelObj.onPropertyChanged = _onProperyChange;
    staticObjects.addLevelObject(levelObj);
    loadToTextArea();
  }
  void _onSelect(LevelObject obj){
    if(_currentLevelObject != null) _currentLevelObject.onDeselect();
    _currentLevelObject = obj;
    menu.onSelect(obj);
  }
  void _onProperyChange(LevelObject obj){
    loadToTextArea();
  }
  Element _createMenuClickAdd(){
    var menu = new UIMenu("Add new");
    var el_menu = menu.createElement();
    for(ClickToAddOptions option in ClickToAddOptions.values){
      RadioButtonInputElement el = new RadioButtonInputElement();
      el.name = "clickToAdd";
      el.checked = option == ClickToAddOptions.None;
      menu.append(el);
      var el_txt = new SpanElement();
      el_txt.text = option.toString().split(".").last;
      menu.append(el_txt);
      menu.append(new BRElement());
      el.onChange.listen((Event e){
        _currentClickOption = option;
      });
    }
    return el_menu;
  }
  Element _createMenuSaveLoad(){
    var menu = new UIMenu("Load/Save from file");
    var el_menu = menu.createElement();

    // text area
    el_txt = new TextAreaElement();
    menu.append(el_txt);
    el_txt.className = "json";
    el_txt.onChange.listen((Event e){
      loadFromTestArea();
    });
    loadToTextArea();

    // save/load
    var set_in = new InputFormString("Set");
    var level_in = new InputFormString("Level");
    menu.append(set_in.createElement());
    menu.append(level_in.createElement());
    set_in.setValue("race");
    level_in.setValue("level1");
    menu.append(new UIIconButton("cloud_download", (Event e){
      var set = set_in.getValue();
      var level = level_in.getValue();
      var loader = new PreLoader(()=> loadFromJson(JsonController.getJson("level/$set/$level")));
      loader.loadJson("levels/$set/$level.json","level/$set/$level");
      loader.start();
    }).createElement());
    menu.append(new UIIconButton("cloud_upload", (Event e){
      var json = levelSaver.levelToJson(gamelevel);
      var data = jsonEncode(json);
      HttpRequest.postFormData('http://localhost/0004-dart/MicroMachines/game/web/server/server.php', {"a":"save","set":set_in.getValue(),"level":level_in.getValue(),"data":data}
      ).then((data) {
        print("Saved ok");
      });
    }).createElement());

    return el_menu;
  }

  void loadToTextArea(){
    Map json = levelSaver.levelToJson(gamelevel);
    el_txt.value = jsonEncode(json);
  }
  void loadFromTestArea(){
    Map json = jsonDecode(el_txt.value);
    loadFromJson(json);
  }

  void loadFromJson(Map json){
    gamelevel = levelLoader.loadLevelJson(json);
    wrappers.forEach((w) => w.clearAll());
    for(GameLevelWall gameObject in gamelevel.walls){
      _addWallToLevelObjects(gameObject);
    }
    for(GameLevelCheckPoint gameObject in gamelevel.path.checkpoints){
      _addCheckpointToLevelObjects(gameObject);
    }
    for(GameLevelStaticObject gameObject in gamelevel.staticobjects){
      _addStaticObjectToLevelObjects(gameObject);
    }
    preview.paintLevel(gamelevel);
  }
}