import "package:preloader/preloader.dart";
import "package:logging/logging.dart";
import "package:micromachines/game.dart";
import "package:renderlayer/renderlayer.dart";
import "package:gameutils/gameloop.dart";
import "package:gameutils/math.dart";
import "dart:html";
import "dart:math" as Math;

void main()
{
  //logger
  Logger.root.level = Level.OFF;

  //String resPath = "http://dannyhendrix.com/teamx/v3/resources/";
  String resPath = "res/";
  ImageController.relativepath = resPath;
  JsonController.relativepath = resPath;

  print("Hi");
  Game game = new Game();
  game.init();
  game.start();

  RenderLayer layer = new RenderLayer.withSize(1500,800);
  document.body.append(layer.canvas);

  var loop = (int now){
    game.update();
    layer.clear();

    //draw road
    layer.ctx.fillStyle = "#111";
    layer.ctx.strokeStyle = "#111";
    for(Polygon p in game.path.roadPolygons){
      drawRoadPolygon(p, layer);
    }

    //draw path
    var startPoint = game.path.point(0);
    layer.ctx.beginPath();
    layer.ctx.moveTo(startPoint.x, startPoint.y);
    for(int i = 1; i < game.path.length; i++){
      var p =game.path.point(i);
      layer.ctx.lineTo(p.x, p.y);
    }
    if(game.path.circular){
      layer.ctx.lineTo(startPoint.x,startPoint.y);
    }
    layer.ctx.strokeStyle = '#555';
    layer.ctx.stroke();

    for(int i = 0; i < game.path.length; i++){
      var p =game.path.point(i);
      layer.ctx.beginPath();
      layer.ctx.arc(p.x, p.y, p.radius, 0, 2 * Math.PI, false);
      layer.ctx.stroke();
    }

    //draw gameObjects
    for(GameObject o in game.gameobjects){
      Matrix2d M = o.getTransformation();
      //draw gameObjects
      if(o is Vehicle){
        Vehicle v = o;
        drawPolygon(o.collisionField.applyMatrix(M), layer, v.isCollided ? "red" : "green");
        for(var s in v.sensors){
          //print(s.collides);
          drawPolygon(s.polygon.applyMatrix(M), layer, s.collides ? "red" : "#ffffff", true);
        }

      }else drawPolygon(o.collisionField.applyMatrix(M), layer, "blue");

      layer.ctx.beginPath();
      layer.ctx.arc(o.position.x, o.position.y, 2, 0, 2 * Math.PI, false);
      layer.ctx.fillStyle = 'green';
      layer.ctx.fill();
    }

    //draw line from each player to his next target
    layer.ctx.strokeStyle = '#777';
    for(int i = 0; i < game.players.length; i++){
      var p =game.players[i];
      layer.ctx.beginPath();
      layer.ctx.moveTo(p.vehicle.position.x, p.vehicle.position.y);
      layer.ctx.lineTo(p.pathProgress.current.x, p.pathProgress.current.y);
      layer.ctx.stroke();
    }

    layer.ctx.font = "10px Arial";
    layer.ctx.fillText("Vehicle: ${game.players[0].vehicle.info}",10,10);
    layer.ctx.fillText("Game: ${game.info}",10,50);
    if(!game.countdown.complete){
      layer.ctx.font = "124px Arial";
      layer.ctx.fillText("${game.countdown.count}",400,400);
    }
  };

  GameLoop gameloop = new GameLoop(loop);
  //loop(0);
  gameloop.play();
  registerControls(game,gameloop);
}

void registerControls(Game game, GameLoop gameloop){

  var handleKey = (KeyboardEvent e)
  {
    if(!gameloop.playing || gameloop.stopping)
      return;
    e.preventDefault();
    int key = e.keyCode;
    bool down = e.type == "keydown";//event.KEYDOWN
    Control control;
    if(key == 38)//up
      game.humanPlayer.onControl(Control.Accelerate,down);
    else if(key == 40)//down
      game.humanPlayer.onControl(Control.Brake,down);
    else if(key == 37)//left
      game.humanPlayer.onControl(Control.SteerLeft,down);
    else if(key == 39)//right
      game.humanPlayer.onControl(Control.SteerRight,down);
/*
    else if(key == 87)//w
      game.players[1].onControl(Control.Accelerate,down);
    else if(key == 83)//s
      game.players[1].onControl(Control.Brake,down);
    else if(key == 65)//a
      game.players[1].onControl(Control.SteerLeft,down);
    else if(key == 68)//d
      game.players[1].onControl(Control.SteerRight,down);
      */
    else return;
  };

  document.onKeyDown.listen(handleKey);
  document.onKeyUp.listen(handleKey);
}

ButtonElement createButton(String text, Function onClick){
  ButtonElement button = new ButtonElement();
  button.text = text;
  button.onClick.listen(onClick);
  return button;
}

void drawPolygon(Polygon polygon, RenderLayer layer, String color, [bool stroke = false]){
  layer.ctx.beginPath();
  layer.ctx.moveTo(polygon.points.first.x,polygon.points.first.y);
  for(Point2d p in polygon.points){
    layer.ctx.lineTo(p.x,p.y);
  }
  if(stroke)  {
    layer.ctx.strokeStyle = color;
    layer.ctx.stroke();
  }else{
    layer.ctx.fillStyle = color;
    layer.ctx.fill();
  }
}
void drawRoadPolygon(Polygon polygon,RenderLayer layer){
  layer.ctx.beginPath();
  var first = polygon.points.first;
  layer.ctx.moveTo(first.x,first.y);
  for(Point2d p in polygon.points){
    layer.ctx.lineTo(p.x,p.y);
  }
  layer.ctx.lineTo(first.x,first.y);
  layer.ctx.fill();
  layer.ctx.stroke();
}