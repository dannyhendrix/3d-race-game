import "dart:html";
import "dart:math" as Math;
import "dart:convert";
import "package:micromachines/game.dart";
import "package:gameutils/math.dart";


Map leveljson = {"w":1500,"d":800,"walls":[{"x":750.0,"z":5.0,"r":0.0,"w":1500.0,"d":10.0,"h":10.0},{"x":750.0,"z":795.0,"r":0.0,"w":1500.0,"d":10.0,"h":10.0},{"x":5.0,"z":400.0,"r":0.0,"w":10.0,"d":780.0,"h":10.0},{"x":1495.0,"z":400.0,"r":0.0,"w":10.0,"d":780.0,"h":10.0},{"x":740.0,"z":190.0,"r":0.0,"w":800.0,"d":10.0,"h":10.0},{"x":1180.0,"z":350.0,"r":1.4,"w":300.0,"d":10.0,"h":10.0},{"x":320.0,"z":350.0,"r":1.7,"w":300.0,"d":10.0,"h":10.0},{"x":730.0,"z":610.0,"r":1.6,"w":300.0,"d":10.0,"h":10.0}],"path":{"circular":true,"laps":-1, "roadwidth":80.0,"checkpoints":[{"x":190.0,"z":110.0,"radius":100.0},{"x":1300.0,"z":100.0,"radius":100.0},{"x":1300.0,"z":640.0,"radius":100.0},{"x":950.0,"z":630.0,"radius":100.0},{"x":750.0,"z":310.0,"radius":100.0},{"x":470.0,"z":600.0,"radius":100.0},{"x":180.0,"z":650.0,"radius":100.0}]}};


abstract class LevelElement{
  Map toJson();
  Element createElement();
}
abstract class LevelElementXZ{
  double x,z;
}
class Level extends LevelElement{
  List<Wall> walls = [];
  Path path = new Path();
  int w = 800;
  int d = 500;
  Map toJson(){
    return {
      "w":w,
      "d":d,
      "walls" : walls.map((Wall o) => o.toJson()).toList(),
      "path" : path.toJson()
    };
  }
  Element createElement(){
    Element el = new SpanElement();
    el.append(createInputElementInt("w",w,(int v)=>w=v));
    el.append(createInputElementInt("d",d,(int v)=>d=v));
    el.append(new ObjInput<Path>().createInputElementObj("path",path));
    el.append(new ListInput<Wall>().createInputElementList("walls",walls,(){var n =new Wall(); walls.add(n); return n;},(Wall p)=>walls.remove(p)));
    return el;
  }
}
class Wall extends LevelElement with LevelElementXZ{
  double x = 0.0,z = 0.0,r = 0.0;
  double w = 1.0,d = 1.0,h = 1.0;
  Wall([this.x=0.0,this.z=0.0,this.r=0.0, this.w = 1.0,this.d = 1.0,this.h = 1.0]);
  Map toJson(){
    return {
      "x":x,"z":z, "r":r,
      "w":w,"d":d, "h":h,
    };
  }
  Element createElement(){
    Element el = new SpanElement();
    el.append(createInputElementDouble("x",x,(double v)=>x=v));
    el.append(createInputElementDouble("z",z,(double v)=>z=v));
    el.append(createInputElementDouble("r",r,(double v)=>r=v));
    el.append(createInputElementDouble("w",w,(double v)=>w=v));
    el.append(createInputElementDouble("d",d,(double v)=>d=v));
    el.append(createInputElementDouble("h",h,(double v)=>h=v));
    return el;
  }
}
class CheckPoint extends LevelElement with LevelElementXZ{
  double x = 0.0,z = 0.0;
  double radius = 50.0;
  CheckPoint([this.x=0.0,this.z=0.0, this.radius = 50.0]);
  Map toJson(){
    return {"x":x,"z":z, "radius":radius};
  }
  Element createElement(){
    Element el = new SpanElement();
    el.append(createInputElementDouble("x",x,(double v)=>x=v));
    el.append(createInputElementDouble("z",z,(double v)=>z=v));
    el.append(createInputElementDouble("radius",radius,(double v)=>radius=v));
    return el;
  }
}
class Path extends LevelElement{
  bool circular = false;
  int laps = -1;
  double roadwidth = 80.0;
  List<CheckPoint> checkpoints = [];
  Map toJson(){
    return {
      "circular" : circular,
      "laps" : laps,
      "roadwidth" : roadwidth,
      "checkpoints" : checkpoints.map((CheckPoint o) => o.toJson()).toList()
    };
  }
  Element createElement(){
    Element el = new SpanElement();
    el.append(createInputElementBool("circular",circular,(bool v)=>circular=v));
    el.append(createInputElementInt("laps",laps,(int v)=>laps=v));
    el.append(createInputElementDouble("roadwidth",roadwidth,(double v)=>roadwidth=v));
    el.append(new ListInput<CheckPoint>().createInputElementList("checkpoints",checkpoints,(){var n =new CheckPoint(); checkpoints.add(n); return n;},(CheckPoint p)=>checkpoints.remove(p)));
    return el;
  }
}

class LevelLoader{
  Level loadLevel(Map json){
    Level level = new Level();
    level.w = json["w"];
    level.d = json["d"];
    level.path.circular = json["path"]["circular"];
    level.path.laps = json["path"]["laps"];
    level.path.roadwidth = json["path"]["roadwidth"];
    level.path.checkpoints = (json["path"]["checkpoints"]).map((Map m)=>new CheckPoint(m["x"],m["z"],m["radius"])).toList();
    level.walls = json["walls"].map((Map m)=>new Wall(m["x"],m["z"],m["r"],m["w"],m["d"],m["h"])).toList();
    return level;
  }
}

class Container
{
  Level level = new Level();
  Preview preview = new Preview();
  LevelElementXZ currentXY;
  Container();
}
Container container = new Container();

void main(){
  document.body.append(container.preview.createElement());
  Element el_level = new DivElement();
  Element el_form = new ObjInput<Level>().createInputElementObj("level",container.level);
  el_level.append(el_form);
  document.body.append(el_level);
  document.body.append(createLoadSaveLevelElement(el_form,el_level));
}

Element createLoadSaveLevelElement(Element el_form, Element el_level){
  Element el_wrap = new FieldSetElement();
  Element el_legend = new LegendElement();
  el_legend.text = "load/save";
  el_wrap.append(el_legend);

  TextAreaElement el_txt = new TextAreaElement();
  el_wrap.append(el_txt);
  el_txt.className = "json";
  el_wrap.append(createButton("CreateJson",(Event e){
    Map json = container.level.toJson();
    el_txt.value = JSON.encode(json);
  }));
  el_wrap.append(createButton("ReadJson",(Event e){
    LevelLoader levelLoader = new LevelLoader();
    Map json = JSON.decode(el_txt.value);
    container.level = levelLoader.loadLevel(json);
    el_form.remove();
    el_form = new ObjInput<Level>().createInputElementObj("level",container.level);
    el_level.append(el_form);
  }));
  el_txt.value = JSON.encode(leveljson);
  return el_wrap;
}

void onInputValueChange(){
  container.preview.paintLevel(container.level);
}

/**
 * Preview canvas
 */
class Preview{
  CanvasElement canvas = new CanvasElement();
  CanvasRenderingContext2D ctx;
  Preview(){
    ctx = canvas.context2D;
  }
  Element createElement(){
    Element el = new DivElement();
    Element el_pos = new DivElement();
    Element el_x = new SpanElement();
    Element el_y = new SpanElement();
    el.className = "preview";
    el.append(canvas);
    el_pos.appendText("mouse x");
    el_pos.append(el_x);
    el_pos.appendText("y");
    el_pos.append(el_y);
    el.append(el_pos);
    el.onMouseMove.listen((MouseEvent e){
      el_x.text = e.offset.x.toString();
      el_y.text = e.offset.y.toString();
    });
    el.onMouseDown.listen((MouseEvent e){
      container.currentXY.x = 1.0*e.offset.x;
      container.currentXY.z= 1.0*e.offset.y;
    });
    return el;
  }
  void paintLevel(Level level){
    canvas.width = level.w;
    canvas.height = level.d;

    //draw road
    PathToPolygons pathToPolygons = new PathToPolygons();
    var roadPolygons = pathToPolygons.createRoadPolygons(level.path.checkpoints.map((p) => new Point(p.x, p.z)).toList(), level.path.roadwidth, level.path.circular);

    ctx.fillStyle = "#999";
    ctx.strokeStyle = "#999";
    for(Polygon p in roadPolygons){
      drawRoadPolygon(p);
    }

    //draw path
    if(level.path.checkpoints.length > 0)
    {
      var startPoint = level.path.checkpoints[0];
      ctx.beginPath();
      ctx.moveTo(startPoint.x, startPoint.z);
      for (int i = 1; i < level.path.checkpoints.length; i++)
      {
        var p = level.path.checkpoints[i];
        ctx.lineTo(p.x, p.z);
      }
      if (level.path.circular)
      {
        ctx.lineTo(startPoint.x, startPoint.z);
      }
      ctx.strokeStyle = '#555';
      ctx.stroke();

      for (int i = 0; i < level.path.checkpoints.length; i++)
      {
        var p = level.path.checkpoints[i];
        ctx.beginPath();
        ctx.arc(p.x, p.z, p.radius, 0, 2 * Math.PI, false);
        ctx.stroke();
      }
    }
    //draw walls
    ctx.fillStyle = "#222";
    for(Wall o in level.walls){
      ctx.save();
      ctx.translate(o.x,o.z);
      ctx.rotate(o.r);
      ctx.fillRect(-o.w/2, -o.d/2, o.w, o.d);
      ctx.restore();
    }
  }
  void drawRoadPolygon(Polygon polygon){
    ctx.beginPath();
    var first = polygon.points.first;
    ctx.moveTo(first.x,first.y);
    for(Point p in polygon.points){
      ctx.lineTo(p.x,p.y);
    }
    ctx.lineTo(first.x,first.y);
    ctx.fill();
    ctx.stroke();
  }
}
CanvasElement createPreview(){
  CanvasElement canvas = new CanvasElement();
}

/**
 * Html input
 */
typedef void OnDoubleValueChange(double newvalue);
typedef void OnBoolValueChange(bool newvalue);
typedef void OnIntValueChange(int newvalue);
typedef T OnAddObject<T>();
typedef void OnRemoveObject<T>(T obj);

Element createInputElementDouble(String label, double value, OnDoubleValueChange onChange){
  Element el_wrap = new SpanElement();
  InputElement el = new InputElement();
  el.value = value.toString();
  el.onChange.listen((Event e){
    onChange(double.parse(el.value));
    onInputValueChange();
  });
  el_wrap.appendText(label);
  el_wrap.append(el);
  el_wrap.className = "in doubleIn";
  return el_wrap;
}
Element createInputElementInt(String label, int value, OnIntValueChange onChange){
  Element el_wrap = new SpanElement();
  InputElement el = new InputElement();
  el.value = value.toString();
  el.onChange.listen((Event e){
    onChange(int.parse(el.value));
    onInputValueChange();
  });
  el_wrap.appendText(label);
  el_wrap.append(el);
  el_wrap.className = "in intIn";
  return el_wrap;
}
Element createInputElementBool(String label, bool value, OnBoolValueChange onChange){
  Element el_wrap = new SpanElement();
  CheckboxInputElement el = new CheckboxInputElement();
  el.checked = value;
  el.onChange.listen((Event e){
    onChange(el.checked);
    onInputValueChange();
  });
  el_wrap.append(el);
  el_wrap.appendText(label);
  el_wrap.className = "in boolIn";
  return el_wrap;
}
class ListInput<T extends LevelElement>
{
  Element createInputElementList(String label, List<T> value, OnAddObject<T> onAdd, OnRemoveObject<T> onRemove)
  {
    Element el_wrap = new FieldSetElement();
    Element el_legend = new LegendElement();
    el_legend.text = label;
    el_wrap.append(el_legend);
    Element el_content = new DivElement();
    el_wrap.append(el_content);

    for(T v in value){
      addNew(v, el_content, onRemove);
    }

    el_wrap.append(createButton("add", (Event e)
    {
      T obj = onAdd();
      addNew(obj, el_content, onRemove);
    }));
    el_wrap.className = "in listIn";
    return el_wrap;
  }

  void addNew(T obj, Element el_content, OnRemoveObject<T> onRemove){
    Element el_item = new DivElement();
    el_item.append(obj.createElement());

    el_item.append(createButton("remove", (Event e)
    {
      el_item.remove();
      onRemove(obj);
      onInputValueChange();
    }));
    el_content.append(el_item);
    onInputValueChange();
  }
}
class ObjInput<T extends LevelElement>
{
  Element createInputElementObj(String label, T value){
    Element el_wrap = new FieldSetElement();
    Element el_legend = new LegendElement();
    el_legend.text = label;
    el_wrap.append(el_legend);
    el_wrap.append(value.createElement());
    el_wrap.className = "in objIn";
    return el_wrap;
  }
}
Element createButton(String labelText, Function onClick){
  var btn = new ButtonElement();
  btn.text = labelText;
  btn.onClick.listen(onClick);
  return btn;
}
Element createButtonSetCurrent(String labelText, LevelElementXZ obj){
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