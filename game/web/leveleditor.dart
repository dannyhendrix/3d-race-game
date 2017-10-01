import "dart:html";
import "dart:math" as Math;
import "dart:convert";
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
  CheckPoint([this.x=0.0,this.z=0.0]);
  Map toJson(){
    return {"x":x,"z":z};
  }
  Element createElement(){
    Element el = new SpanElement();
    el.append(createInputElementDouble("x",x,(double v)=>x=v));
    el.append(createInputElementDouble("z",z,(double v)=>z=v));
    return el;
  }
}
class Path extends LevelElement{
  bool circular = false;
  int laps = -1;
  List<CheckPoint> checkpoints = [];
  Map toJson(){
    return {
      "circular" : circular,
      "laps" : laps,
      "checkpoints" : checkpoints.map((CheckPoint o) => o.toJson()).toList()
    };
  }
  Element createElement(){
    Element el = new SpanElement();
    el.append(createInputElementBool("circular",circular,(bool v)=>circular=v));
    el.append(createInputElementInt("laps",laps,(int v)=>laps=v));
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
    level.path.checkpoints = json["path"]["checkpoints"].map((Map m)=>new CheckPoint(double.parse(m["x"]),double.parse(m["z"]))).toList();
    level.walls = json["walls"].map((Map m)=>new Wall(double.parse(m["x"]),double.parse(m["z"]),double.parse(m["r"]),double.parse(m["w"]),double.parse(m["d"]),double.parse(m["h"]))).toList();
    return level;
  }
}


Level level = new Level();
Preview preview = new Preview();
LevelElementXZ currentXY;

void main(){
  document.body.append(preview.createElement());
  Element el_level = new DivElement();
  Element el = new ObjInput<Level>().createInputElementObj("level",level);
  el_level.append(el);
  document.body.append(el_level);
  Element el_txt = new TextAreaElement();
  document.body.append(createButton("CreateJson",(Event e){
    Map json = level.toJson();
    el_txt.text = JSON.encode(json);
  }));
  document.body.append(createButton("ReadJson",(Event e){
    LevelLoader levelLoader = new LevelLoader();
    Map json = JSON.decode(el_txt.text);
    level = levelLoader.loadLevel(json);
    el.remove();
    el = new ObjInput<Level>().createInputElementObj("level",level);
    el_level.append(el);
  }));
  document.body.append(el_txt);
}

void onInputValueChange(){
  preview.paintLevel(level);
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
      currentXY.x = 1.0*e.offset.x;
      currentXY.z= 1.0*e.offset.y;
    });
    return el;
  }
  void paintLevel(Level level){
    canvas.width = level.w;
    canvas.height = level.d;

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
        ctx.arc(p.x, p.z, 5, 0, 2 * Math.PI, false);
        ctx.stroke();
      }
    }
    //draw walls
    for(Wall o in level.walls){
      ctx.fillStyle = "rgba(2,2,2,1.0)";
      ctx.save();
      ctx.translate(o.x,o.z);
      ctx.rotate(o.r);
      ctx.fillRect(-o.w/2, -o.d/2, o.w, o.d);
      ctx.restore();
    }
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
  Element createInputElementList(String label, List value, OnAddObject<T> onAdd, OnRemoveObject<T> onRemove)
  {
    Element el_wrap = new FieldSetElement();
    Element el_legend = new LegendElement();
    el_legend.text = label;
    el_wrap.append(el_legend);
    Element el_content = new DivElement();
    el_wrap.append(el_content);
    el_wrap.append(createButton("add", (Event e)
    {
      Element el_item = new DivElement();
      T obj = onAdd();
      el_item.append(obj.createElement());

      el_item.append(createButton("remove", (Event e)
      {
        el_item.remove();
        onRemove(obj);
        onInputValueChange();
      }));
      el_content.append(el_item);
      onInputValueChange();
    }));
    el_wrap.className = "in listIn";
    return el_wrap;
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
    currentXY = obj;
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