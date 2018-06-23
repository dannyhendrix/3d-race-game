import "dart:html";
import "dart:convert";
import "package:micromachines/leveleditor.dart";
import "package:micromachines/definitions.dart";
import "package:micromachines/gamemode.dart";



class Container{
  Preview preview = new Preview();
  GameLevel gamelevel;
  bool changed;
}
Container container = new Container();
LevelManager levelManager = new LevelManager();
GameLevelLoader levelLoader = new GameLevelLoader();
GameLevelSaver levelSaver = new GameLevelSaver();

void main(){
  var menu = new LevelObjectMenu();
  var obj1 = new LevelObject();
  obj1.onSelect = menu.onSelect;
  obj1.onMove = menu.onMove;
  var obj2 = new LevelObjectCircle();
  obj2.onSelect = menu.onSelect;
  obj2.onMove = menu.onMove;
  document.body.append(menu.createElement());
  document.body.append(obj1.createElement());
  document.body.append(obj2.createElement());


  container.gamelevel = levelLoader.loadLevelJson(levelManager.levelJson2);
  document.body.append(container.preview.createElement());
  Element el_level = new DivElement();
  document.body.append(el_level);
  document.body.append(createLoadSaveLevelElement(el_level));

  container.preview.canvas.onMouseDown.listen((MouseEvent e){
    container.gamelevel.path.checkpoints.add(new GameLevelCheckPoint(e.offset.x/container.preview.scale,e.offset.y/container.preview.scale,80.0));
    container.preview.paintLevel(container.gamelevel);
  });
  //document.body.append(createScaleLevel());

}
Element createLoadSaveLevelElement(Element el_level){
  Element el_wrap = new FieldSetElement();
  Element el_legend = new LegendElement();
  el_legend.text = "load/save";
  el_wrap.append(el_legend);

  TextAreaElement el_txt = new TextAreaElement();
  el_wrap.append(el_txt);
  el_txt.className = "json";

  el_wrap.append(createButton("file_download",(Event e){
    Map json = levelSaver.levelToJson(container.gamelevel);
    el_txt.value = jsonEncode(json);
  }));

  el_wrap.append(createButton("file_upload",(Event e){
    GameLevelLoader levelLoader = new GameLevelLoader();
    Map json = jsonDecode(el_txt.value);
    container.gamelevel = levelLoader.loadLevelJson(json);
    container.preview.paintLevel(container.gamelevel);
    container.changed = true;
  }));
  el_txt.value = jsonEncode(levelSaver.levelToJson(container.gamelevel));
  return el_wrap;
}
/*
void scaleLevel(GameLevel level, double scale){
  level.d = (level.d*scale).round();
  level.w = (level.w*scale).round();
  level.walls.forEach((GameLevelWall w){
    w.d = w.d*scale;
    w.h = w.h*scale;
    w.w = w.w*scale;
    w.x = w.x*scale;
    w.z = w.z*scale;
  });
  level.path.checkpoints.forEach((GameLevelCheckPoint c){
    c.x = c.x*scale;
    c.z = c.z*scale;
    c.radius = c.radius*scale;
  });
}

Element createScaleLevel(){
  Element el = new DivElement();
  InputElement el_in = new InputElement();
  el_in.value = "1.0";
  Element el_btn = createButton("Scale level",(Event e){
    double scale = double.parse(el_in.value);
    scaleLevel(container.input.createValue(),scale);
  });
  el.append(el_in);
  el.append(el_btn);
  return el;
}*/
/*
Element createButtonSetCurrent(String labelText, GameLevelElement obj){
  var btn = new ButtonElement();
  btn.text = labelText;
  btn.onClick.listen((Event e){
    container.currentXY = obj;
  });
  return btn;
}
Element createMoveUpButton(String labelText, Element el_wrap, Function onClick){
  var btn = new ButtonElement();
  btn.text = labelText;
  btn.onClick.listen((Event e){
    var index = el_wrap.parent.nodes.indexOf(el_wrap);
    index = (index < 1) ? 0 : index-1;
    Element elBefore = el_wrap.parent.nodes[index];
    el_wrap.parent.insertBefore(el_wrap,elBefore);
    onClick(e);
  });
  return btn;
}
Element createMoveDownButton(String labelText, Element el_wrap, Function onClick){
  var btn = new ButtonElement();
  btn.text = labelText;
  btn.onClick.listen((Event e){
    var index = el_wrap.parent.nodes.indexOf(el_wrap);
    index = (index < 0) ? 0 : index+2;
    if(index >= el_wrap.parent.nodes.length){
      el_wrap.parent.append(el_wrap);
    }else{
      Element elBefore = el_wrap.parent.nodes[index];
      el_wrap.parent.insertBefore(el_wrap,elBefore);
    }
    onClick(e);
  });
  return btn;
}
*/
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
  btn.onClick.listen((MouseEvent e){ e.preventDefault(); onClick(e); });
  btn.onTouchStart.listen((TouchEvent e){ e.preventDefault(); onClick(e); });
  btn.append(createIcon(icon));
  return btn;
}