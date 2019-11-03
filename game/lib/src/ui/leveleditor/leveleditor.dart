part of game.leveleditor;

enum ClickToAddOptions {None, CheckPoint, Tree, Wall}

class LevelEditor{
  UiInputTextLarge el_txt;
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
    var el = new UiPanel();
    var el_levelwrap = new UiPanel();
    el_levelwrap.element.onMouseDown.listen(_onLevelMouseDown);
    el_levelwrap.addStyle("levelWrapper");
    el_levelwrap.appendElement(preview.createElement());
    wrappers.forEach((o)=>el_levelwrap.append(o));
    el.append(el_levelwrap);
    var el_right = new UiPanel();
    el_right.addStyle("rightpanel");
    el_right.append(_createMenuCreate());
    el_right.append(_createMenuControls());
    el_right.append(_createMenuProperties());
    el_right.append(_createMenuClickAdd());
    el_right.append(_createMenuSaveLoad());
    el.append(el_right);
    return el.element;
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
  UiElement _createMenuProperties(){
    return menu.createElement();
  }
  UiElement _createMenuControls(){
    return menu.createElementControls();
  }
  UiElement _createMenuCreate(){
    var menu = new UIMenu("Add objects");
    menu.addStyle("menu");

    menu.append(new UITextButton("New checkpoint", (){
      _addNewCheckpoint(10.0,10.0);
    }));
    menu.append(new UITextButton("New wall", (){
      _addNewWall(10.0,10.0);
    }));
    menu.append(new UITextButton("New tree", (){
      _addNewStaticObject(10.0,10.0);
    }));

    return menu;
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
  UiElement _createMenuClickAdd(){
    var menu = new UIMenu("Add new");
    for(ClickToAddOptions option in ClickToAddOptions.values){
      RadioButtonInputElement el = new RadioButtonInputElement();
      el.name = "clickToAdd";
      el.checked = option == ClickToAddOptions.None;
      menu.appendElement(el);
      var el_txt = new SpanElement();
      el_txt.text = option.toString().split(".").last;
      menu.appendElement(el_txt);
      menu.appendElement(new BRElement());
      el.onChange.listen((Event e){
        _currentClickOption = option;
      });
    }
    return menu;
  }
  UiElement _createMenuSaveLoad(){
    var menu = new UIMenu("Load/Save from file");

    // text area
    el_txt = new UiInputTextLarge("Content");
    menu.append(el_txt);
    el_txt.addStyle("json");
    el_txt.onValueChange = (String val){
      loadFromTestArea();
    };
    loadToTextArea();

    // save/load
    var set_in = new UiInputText("Set");
    var level_in = new UiInputText("Level");
    menu.append(set_in);
    menu.append(level_in);
    set_in.setValue("race");
    level_in.setValue("level1");
    menu.append(new UIIconButton("cloud_download", (){
      var set = set_in.getValue();
      var level = level_in.getValue();
      var loader = new PreLoader(()=> loadFromJson(JsonController.getJson("level/$set/$level")));
      loader.loadJson("levels/$set/$level.json","level/$set/$level");
      loader.start();
    }));
    menu.append(new UIIconButton("cloud_upload", (){
      var json = levelSaver.levelToJson(gamelevel);
      var data = jsonEncode(json);
      HttpRequest.postFormData('http://localhost/0004-dart/MicroMachines/game/web/server/server.php', {"a":"save","set":set_in.getValue(),"level":level_in.getValue(),"data":data}
      ).then((data) {
        print("Saved ok");
      });
    }));

    return menu;
  }

  void loadToTextArea(){
    Map json = levelSaver.levelToJson(gamelevel);
    el_txt.setValue(jsonEncode(json));
  }
  void loadFromTestArea(){
    Map json = jsonDecode(el_txt.getValue());
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