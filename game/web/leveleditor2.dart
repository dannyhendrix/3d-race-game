import "dart:html";
import "dart:convert";
import "package:micromachines/leveleditor.dart";
import "package:micromachines/definitions.dart";
import "package:micromachines/gamemode.dart";


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
  LevelManager levelManager = new LevelManager();
  GameLevelLoader levelLoader = new GameLevelLoader();
  GameLevelSaver levelSaver = new GameLevelSaver();

  ClickToAddOptions _currentClickOption = ClickToAddOptions.None;
  LevelObject _currentLevelObject = null;
  //TODO: connect scale to all levelObjects
  double _scale = 0.5;

  LevelEditor(){
    wrappers = [checkPoints,walls,staticObjects];
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
    el_right.append(_createMenuProperties());
    el_right.append(_createMenuClickAdd());
    el.append(el_right);
    el.append(_createLoadSaveLevelElement());
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
    Element el = _createSection("Properties");
    el.className = "properties";
    el.append(menu.createElement());
    return el;
  }
  Element _createMenuCreate(){
    Element el_menu = _createSection("Add objects");
    el_menu.className = "menu";

    el_menu.append(createButtonText("New checkpoint", (Event e){
      _addNewCheckpoint(10.0,10.0);
    }));
    el_menu.append(createButtonText("New wall", (Event e){
      _addNewWall(10.0,10.0);
    }));
    el_menu.append(createButtonText("New tree", (Event e){
      _addNewStaticObject(10.0,10.0);
    }));

    return el_menu;
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
    LevelObjectWall levelObj = new LevelObjectWall(gameObject);
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
      gameObject = new GameLevelCheckPoint(x, y, source.radius);
    }
    else
      gameObject = new GameLevelCheckPoint(x,y,100.0);
    gamelevel.path.checkpoints.add(gameObject);
    _addCheckpointToLevelObjects(gameObject);
  }
  void _addCheckpointToLevelObjects(GameLevelCheckPoint gameObject){
    LevelObjectCheckpoint levelObj = new LevelObjectCheckpoint(gameObject);
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
    LevelObjectStaticObject levelObj = new LevelObjectStaticObject(gameObject);
    levelObj.onSelect = _onSelect;
    levelObj.onPropertyChanged = _onProperyChange;
    staticObjects.addLevelObject(levelObj);
    loadToTextArea();
  }
  void _onSelect(LevelObject obj){
    _currentLevelObject = obj;
    menu.onSelect(obj);
  }
  void _onProperyChange(LevelObject obj){
    loadToTextArea();
  }
  Element _createMenuClickAdd(){
    Element el_menu = _createSection("Click to add");
    el_menu.className = "menu";
    for(ClickToAddOptions option in ClickToAddOptions.values){
      RadioButtonInputElement el = new RadioButtonInputElement();
      el.name = "clickToAdd";
      el.checked = option == ClickToAddOptions.None;
      el_menu.append(el);
      el_menu.appendText(option.toString().split(".").last);
      el_menu.append(new BRElement());
      el.onChange.listen((Event e){
        _currentClickOption = option;
      });
    }
    return el_menu;
  }

  Element _createLoadSaveLevelElement(){
    Element el_wrap = _createSection("load/save");

    el_txt = new TextAreaElement();
    el_wrap.append(el_txt);
    el_txt.className = "json";
    el_txt.onChange.listen((Event e){
      loadFromTestArea();
    });

    el_wrap.append(createButton("file_download",(Event e){
      loadToTextArea();
    }));

    el_wrap.append(createButton("file_upload",(Event e){
      GameLevelLoader levelLoader = new GameLevelLoader();
      loadFromTestArea();
    }));
    el_txt.value = jsonEncode(levelSaver.levelToJson(levelLoader.loadLevelJson(levelManager.leveljson)));
    return el_wrap;
  }

  Element _createSection(String title){
    Element el_wrap = new FieldSetElement();
    Element el_legend = new LegendElement();
    el_legend.text = title;
    el_wrap.append(el_legend);
    return el_wrap;
  }

  void loadToTextArea(){
    Map json = levelSaver.levelToJson(gamelevel);
    el_txt.value = jsonEncode(json);
  }
  void loadFromTestArea(){
    Map json = jsonDecode(el_txt.value);
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

void main(){
  var editor = new LevelEditor();
  document.body.append(editor.createElement());
}
Element createIcon(String icon)
{
  Element iel = new Element.tag("i");
  iel.className = "material-icons";
  iel.text = icon.toLowerCase();
  return iel;
}
Element createButton(String icon, Function onClick)
{
  DivElement btn = new DivElement();
  btn.className = "button";
  btn.onClick.listen((MouseEvent e){ e.preventDefault(); onClick(e); });
  btn.onTouchStart.listen((TouchEvent e){ e.preventDefault(); onClick(e); });
  btn.append(createIcon(icon));
  return btn;
}
Element createButtonText(String text, Function onClick)
{
  DivElement btn = new DivElement();
  btn.className = "button";
  btn.onClick.listen((MouseEvent e){ e.preventDefault(); onClick(e); });
  btn.onTouchStart.listen((TouchEvent e){ e.preventDefault(); onClick(e); });
  btn.text = text;
  return btn;
}