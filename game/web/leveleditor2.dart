import "dart:html";
import "dart:convert";
import "package:micromachines/leveleditor.dart";
import "package:micromachines/definitions.dart";
import "package:micromachines/gamemode.dart";


enum ClickToAddOptions {None, CheckPoint, Tree, Wall}

class LevelEditor{
  Preview preview = new Preview();
  LevelObjectWrapperWalls walls = new LevelObjectWrapperWalls();
  LevelObjectWrapperStaticObjects staticObjects = new LevelObjectWrapperStaticObjects();
  LevelObjectWrapperCheckpoints checkPoints = new LevelObjectWrapperCheckpoints();
  List<LevelObjectWrapper> wrappers;
  LevelObjectMenu menu = new LevelObjectMenu();
  LevelManager levelManager = new LevelManager();
  GameLevelLoader levelLoader = new GameLevelLoader();
  GameLevelSaver levelSaver = new GameLevelSaver();

  ClickToAddOptions _currentClickOption = ClickToAddOptions.None;
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
        wrapper = checkPoints;
        break;
      case ClickToAddOptions.Tree:
        wrapper = staticObjects;
        break;
      case ClickToAddOptions.Wall:
        wrapper = walls;
        break;
      default:
        return;
    }
    wrapper.addNew(menu.onSelect,menu.onMove, e.offset.x/_scale, e.offset.y/_scale);
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
    el_menu.append(createButtonText("add checkpoint", (Event e){ checkPoints.addNew(menu.onSelect,menu.onMove, 10.0, 10.0); }));
    el_menu.append(createButtonText("add wall", (Event e){ walls.addNew(menu.onSelect,menu.onMove, 10.0, 10.0); }));
    el_menu.append(createButtonText("add staticObject", (Event e){ staticObjects.addNew(menu.onSelect,menu.onMove, 10.0, 10.0); }));
    return el_menu;
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

    var el_txt = new TextAreaElement();
    el_wrap.append(el_txt);
    el_txt.className = "json";

    el_wrap.append(createButton("file_download",(Event e){
      el_txt.value = loadToTextArea();
    }));

    el_wrap.append(createButton("file_upload",(Event e){
      GameLevelLoader levelLoader = new GameLevelLoader();
      loadFromTestArea(el_txt.value);
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

  String loadToTextArea(){
    var gamelevel = new GameLevel();
    wrappers.forEach((o)=>o.addToGameLevel(gamelevel));
    Map json = levelSaver.levelToJson(gamelevel);
    return jsonEncode(json);
  }
  void loadFromTestArea(String levelTxt){
    Map json = jsonDecode(levelTxt);
    var gamelevel = levelLoader.loadLevelJson(json);
    wrappers.forEach((o)=>o.loadFromGameLevel(gamelevel, menu.onSelect, menu.onMove));
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