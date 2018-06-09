import "dart:html";
import "dart:math" as Math;
import "dart:convert";
import "package:micromachines/game.dart";
import "package:micromachines/leveleditor.dart";
import "package:micromachines/webgl_game.dart";
import "package:gameutils/math.dart";

abstract class DrawObject{
  void paint(CanvasRenderingContext2D ctx);
  void paintAsCurrent(CanvasRenderingContext2D ctx);
  bool pointInObj(double x, double y);
}
class DrawObjectPolygon extends DrawObject{
  Polygon polygon;
  String style;
  DrawObjectPolygon.FromSquare(double x, double y, double w, double h, double r, this.style){
    double hw = w/2;
    double hh = h/2;
    polygon = new Polygon([new Point2d(-hw,-hh),new Point2d(hw,-hh),new Point2d(hw,hh),new Point2d(-hw,hh)]);
    //Matrix2d transform = new Matrix2d.rotation(r).translate(x,y);
    Matrix2d transform = new Matrix2d.translation(x,y).rotate(r);
    polygon = polygon.applyMatrix(transform);
  }

  void paint(CanvasRenderingContext2D ctx){
    ctx.fillStyle = style;
    ctx.strokeStyle = "#999";
    _drawRoadPolygon(ctx,polygon);
  }
  void paintAsCurrent(CanvasRenderingContext2D ctx){
    ctx.fillStyle = "green";
    ctx.strokeStyle = "#999";
    _drawRoadPolygon(ctx,polygon);
  }
  void _drawRoadPolygon(CanvasRenderingContext2D ctx,Polygon polygon){
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
  bool pointInObj(double x, double y){
    return polygon.pointInPoligon(x,y);
  }
}

class Container{
  Preview preview = new Preview();
  Input input;
  GameLevelElement currentXY;
  bool changed;
  Container(){
    input = Input.createInput(GameLevel, (Input input){ changed = true;});
  }
}
Container container = new Container();

void main(){
  document.body.append(container.preview.createElement());
  Element el_level = new DivElement();
  Element el_form = container.input.createElement("level", new GameLevel());
  document.body.append(el_level);
  document.body.append(el_form);
  document.body.append(createLoadSaveLevelElement(el_form,el_level));
  document.body.append(createScaleLevel());

  window.requestAnimationFrame(loop);
}

void loop(num num){
  if(container.changed) container.preview.paintLevel(container.input.createValue());
  container.changed = false;
  window.requestAnimationFrame(loop);
}

Element createLoadSaveLevelElement(Element el_form, Element el_level){
  Element el_wrap = new FieldSetElement();
  Element el_legend = new LegendElement();
  el_legend.text = "load/save";
  el_wrap.append(el_legend);

  TextAreaElement el_txt = new TextAreaElement();
  el_wrap.append(el_txt);
  el_txt.className = "json";
  el_wrap.append(createButton("file_download",(Event e){
    GameLevelSaver levelSaver = new GameLevelSaver();
    GameLevel level = container.input.createValue();
    Map json = levelSaver.levelToJson(level);
    el_txt.value = jsonEncode(json);
  }));
  el_wrap.append(createButton("file_upload",(Event e){
    GameLevelLoader levelLoader = new GameLevelLoader();
    Map json = jsonDecode(el_txt.value);
    el_form.remove();
    el_form = container.input.createElement("level", levelLoader.loadLevelJson(json));
    el_level.append(el_form);
    container.changed = true;
  }));
  el_txt.value = jsonEncode(leveljson);
  return el_wrap;
}

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

/**
 * Preview canvas
 */
class Preview{
  double mouseX = 0.0;
  double mouseY = 0.0;
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
      mouseX = e.offset.x;
      el_x.text = mouseX.toString();
      mouseY = e.offset.y;
      el_y.text = mouseY.toString();
      container.changed = true;
    });
    el.onMouseDown.listen((MouseEvent e){
      //container.currentXY.x = 1.0*e.offset.x;
      //container.currentXY.z= 1.0*e.offset.y;
    });
    return el;
  }

  void paintLevel(GameLevel level){
    double scale = 0.5;
    canvas.width = (level.w*scale).round();
    canvas.height = (level.d*scale).round();

    //draw road
    PathToPolygons pathToPolygons = new PathToPolygons();
    var roadPolygons = pathToPolygons.createRoadPolygons(level.path.checkpoints.map((p) => new PathCheckPoint(p.x*scale, p.z*scale,p.radius*scale)).toList(), level.path.circular);

    ctx.fillStyle = "#999";
    ctx.strokeStyle = "#999";
    for(Polygon p in roadPolygons){
      drawRoadPolygon(p);
    }
    //List<DrawObject> drawobjects = [];
    Input current = null;
    container.input.map((Input input){
      if(input is InputObj){
        DrawObject drawObject;
        if(input.objType == GameLevelWall){
          GameLevelWall value = input.createValue();
          drawObject = new DrawObjectPolygon.FromSquare(value.x*scale, value.z*scale, value.w*scale, value.d*scale, value.r, "red");
        }else if(input.objType == GameLevelStaticObject){
          GameLevelStaticObject value = input.createValue();
          drawObject = new DrawObjectPolygon.FromSquare(value.x*scale, value.z*scale, 50*scale, 50*scale, value.r, "green");
        }
        if(drawObject == null) return;
        if(current == null && drawObject.pointInObj(mouseX,mouseY)){
          drawObject.paintAsCurrent(ctx);
          current = input;
        }else{
          drawObject.paint(ctx);
        }
      }
    });

    //draw path
    if(level.path.checkpoints.length > 0)
    {
      var startPoint = level.path.checkpoints[0];
      ctx.beginPath();
      ctx.moveTo(startPoint.x*scale, startPoint.z*scale);
      for (int i = 1; i < level.path.checkpoints.length; i++)
      {
        var p = level.path.checkpoints[i];
        ctx.lineTo(p.x*scale, p.z*scale);
      }
      if (level.path.circular)
      {
        ctx.lineTo(startPoint.x*scale, startPoint.z*scale);
      }
      ctx.strokeStyle = '#555';
      ctx.stroke();

      for (int i = 0; i < level.path.checkpoints.length; i++)
      {
        var p = level.path.checkpoints[i];
        ctx.beginPath();
        ctx.arc(p.x*scale, p.z*scale, p.radius*scale, 0, 2 * Math.pi, false);
        ctx.stroke();
      }
    }
    /*
    //draw walls
    ctx.fillStyle = "#222";
    for(GameLevelWall o in level.walls){
      ctx.save();
      ctx.translate(o.x*scale,o.z*scale);
      ctx.rotate(o.r);
      ctx.fillRect(-o.w*scale/2, -o.d*scale/2, o.w*scale, o.d*scale);
      ctx.restore();
    }
    ctx.fillStyle = "#282";
    for(GameLevelStaticObject o in level.staticobjects){
      ctx.save();
      ctx.translate(o.x*scale,o.z*scale);
      ctx.rotate(o.r);
      double w = 30.0;
      double d = 30.0;
      ctx.fillRect(-w*scale/2, -d*scale/2, w*scale, d*scale);
      ctx.restore();
    }
    */
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