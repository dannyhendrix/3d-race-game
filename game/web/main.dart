import "package:preloader/preloader.dart";
import "package:logging/logging.dart";
import "package:micromachines/game.dart";
import "package:renderlayer/renderlayer.dart";
import "package:gameutils/gameloop.dart";
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
/*
  drawPolygon(new Polygon([
    new Point(0,0),
    new Point(0,50),
    new Point(10,50),
    new Point(10,0),
  ]),layer);
*/
  /*
  drawPolygon(new Polygon([
    new Point(0,0),
    new Point(50,0),
    new Point(50,10),
    new Point(0,10),
  ]).translate(new Point(100,120), new Point(25,5)),layer);
  drawPolygon(new Polygon([
    new Point(0,0),
    new Point(50,0),
    new Point(50,10),
    new Point(0,10),
  ]).translate(new Point(100,120), new Point(25,5)).rotate(0.7, new Point(100,120)),layer);
*/
  GameLoop gameloop = new GameLoop((int now){
    game.update();
    layer.clear();
    for(GameObject o in game.gameobjects){
      /*
      double midX = o.w~/2;
      double midY = o.h~/2;
      layer.ctx.save();
      layer.ctx.fillStyle = 'blue';
      layer.ctx.translate(o.x,o.y);
      layer.ctx.rotate(o.r);
      layer.ctx.fillRect(-midX,-midY,o.w,o.h);
      layer.ctx.restore();
*/
      drawPolygon(o.createPolygonOnActualLocation(), layer, "blue");

      layer.ctx.font = "10px Arial";
      layer.ctx.fillText("Vehicle: ${game.player.vehicle.info}",10,10);
      layer.ctx.fillText("Game: ${game.info}",10,50);

      layer.ctx.beginPath();
      layer.ctx.arc(o.x, o.y, 2, 0, 2 * Math.PI, false);
      layer.ctx.fillStyle = 'green';
      layer.ctx.fill();
    }
  });

  gameloop.play();

  var handleKey = (KeyboardEvent e)
  {
    if(!gameloop.playing || gameloop.stopping)
      return;
    e.preventDefault();
    int key = e.keyCode;
    bool down = e.type == "keydown";//event.KEYDOWN
    Control control;
    if(key == 38)//up
      control = Control.Accelerate;
    else if(key == 40)//down
      control = Control.Brake;
    else if(key == 37)//left
      control = Control.SteerLeft;
    else if(key == 39)//right
      control = Control.SteerRight;
    else return;
    game.player.onControl(control, down);
  };

  document.onKeyDown.listen(handleKey);
  document.onKeyUp.listen(handleKey);
  document.body.append(createButton("reset",(MouseEvent e){
    game.player.vehicle.x = 150;
    game.player.vehicle.y = 50;
  }));
}

ButtonElement createButton(String text, Function onClick){
  ButtonElement button = new ButtonElement();
  button.text = text;
  button.onClick.listen(onClick);
  return button;
}

void drawPolygon(Polygon polygon, Renderlayer layer, String color){
  layer.ctx.beginPath();
  layer.ctx.fillStyle = color;
  layer.ctx.moveTo(polygon.points.first.x,polygon.points.first.y);
  for(Point p in polygon.points){
    layer.ctx.lineTo(p.x,p.y);
  }
  layer.ctx.fill();
}