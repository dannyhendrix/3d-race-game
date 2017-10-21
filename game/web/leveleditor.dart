import "dart:html";
import "dart:math" as Math;
import "dart:convert";
import "package:micromachines/game.dart";
import "package:gameutils/math.dart";

class LevelEditorForm{
  Element createNewElement(GameLevelElement gameLevelElement){
    if(gameLevelElement is GameLevel){
      return _formLevel(gameLevelElement);
    }else if(gameLevelElement is GameLevelWall){
      return _formWall(gameLevelElement);
    }else if(gameLevelElement is GameLevelPath){
      return _formPath(gameLevelElement);
    }else if(gameLevelElement is GameLevelCheckPoint){
      return _formCheckPoint(gameLevelElement);
    }
  }
  Element _formLevel(GameLevel level){
    Element el = new SpanElement();
    el.append(createInputElementInt("w",level.w,(int v)=>level.w=v));
    el.append(createInputElementInt("d",level.d,(int v)=>level.d=v));
    el.append(new ObjInput<GameLevelPath>().createInputElementObj("path",level.path));
    el.append(new ListInput<GameLevelWall>().createInputElementList("walls",level.walls,(){var n =new GameLevelWall(); level.walls.add(n); return n;},(GameLevelWall p)=>level.walls.remove(p)));
    return el;
  }

  Element _formWall(GameLevelWall wall){
    Element el = new SpanElement();
    el.append(createInputElementDouble("x",wall.x,(double v)=>wall.x=v));
    el.append(createInputElementDouble("z",wall.z,(double v)=>wall.z=v));
    el.append(createInputElementDouble("r",wall.r,(double v)=>wall.r=v));
    el.append(createInputElementDouble("w",wall.w,(double v)=>wall.w=v));
    el.append(createInputElementDouble("d",wall.d,(double v)=>wall.d=v));
    el.append(createInputElementDouble("h",wall.h,(double v)=>wall.h=v));
    return el;
  }
  Element _formPath(GameLevelPath path){
    Element el = new SpanElement();
    el.append(createInputElementBool("circular",path.circular,(bool v)=>path.circular=v));
    el.append(createInputElementInt("laps",path.laps,(int v)=>path.laps=v));
    el.append(new ListInput<GameLevelCheckPoint>().createInputElementList("checkpoints",path.checkpoints,(){var n =new GameLevelCheckPoint(); path.checkpoints.add(n); return n;},(GameLevelCheckPoint p)=>path.checkpoints.remove(p)));
    return el;
  }
  Element _formCheckPoint(GameLevelCheckPoint checkpoint){
    Element el = new SpanElement();
    el.append(createInputElementDouble("x",checkpoint.x,(double v)=>checkpoint.x=v));
    el.append(createInputElementDouble("z",checkpoint.z,(double v)=>checkpoint.z=v));
    el.append(createInputElementDouble("radius",checkpoint.radius,(double v)=>checkpoint.radius=v));
    return el;
  }
}

class Container
{
  GameLevel level = new GameLevel();
  Preview preview = new Preview();
  LevelEditorForm form = new LevelEditorForm();
  GameLevelElement currentXY;
  Container();
}
Container container = new Container();

void main(){
  document.body.append(container.preview.createElement());
  Element el_level = new DivElement();
  Element el_form = new ObjInput<GameLevel>().createInputElementObj("level",container.level);
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
    GameLevelSaver levelSaver = new GameLevelSaver();
    Map json = levelSaver.levelToJson(container.level);
    el_txt.value = JSON.encode(json);
  }));
  el_wrap.append(createButton("ReadJson",(Event e){
    GameLevelLoader levelLoader = new GameLevelLoader();
    Map json = JSON.decode(el_txt.value);
    container.level = levelLoader.loadLevelJson(json);
    el_form.remove();
    el_form = new ObjInput<GameLevel>().createInputElementObj("level",container.level);
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
      //container.currentXY.x = 1.0*e.offset.x;
      //container.currentXY.z= 1.0*e.offset.y;
    });
    return el;
  }
  void paintLevel(GameLevel level){
    canvas.width = level.w;
    canvas.height = level.d;

    //draw road
    PathToPolygons pathToPolygons = new PathToPolygons();
    var roadPolygons = pathToPolygons.createRoadPolygons(level.path.checkpoints.map((p) => new PathCheckPoint(p.x, p.z,p.radius)).toList(), level.path.circular);

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
    for(GameLevelWall o in level.walls){
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
    for(Point2d p in polygon.points){
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
class ListInput<T extends GameLevelElement>
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
    el_item.append( container.form.createNewElement(obj));

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
class ObjInput<T extends GameLevelElement>
{
  Element createInputElementObj(String label, T value){
    Element el_wrap = new FieldSetElement();
    Element el_legend = new LegendElement();
    el_legend.text = label;
    el_wrap.append(el_legend);
    el_wrap.append( container.form.createNewElement(value));
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