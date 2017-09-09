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

  GameLoop gameloop = new GameLoop((int now){
    game.update();
    layer.clear();
    for(GameObject o in game.gameobjects){
      if(o is Vehicle){
        Vehicle v = o;
        drawPolygon(o.createPolygonOnActualLocation(), layer, v.isCollided ? "red" : "purple");
      }else drawPolygon(o.createPolygonOnActualLocation(), layer, "blue");

      layer.ctx.beginPath();
      layer.ctx.arc(o.position.x, o.position.y, 2, 0, 2 * Math.PI, false);
      layer.ctx.fillStyle = 'green';
      layer.ctx.fill();
    }

    layer.ctx.font = "10px Arial";
    layer.ctx.fillText("Vehicle: ${game.player.vehicle.info}",10,10);
    layer.ctx.fillText("Game: ${game.info}",10,50);
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
    game.player.vehicle.position = new Point(150.0, 50.0);
  }));
}

ButtonElement createButton(String text, Function onClick){
  ButtonElement button = new ButtonElement();
  button.text = text;
  button.onClick.listen(onClick);
  return button;
}

void drawPolygon(Polygon polygon, RenderLayer layer, String color){
  layer.ctx.beginPath();
  layer.ctx.fillStyle = color;
  layer.ctx.moveTo(polygon.points.first.x,polygon.points.first.y);
  for(Point p in polygon.points){
    layer.ctx.lineTo(p.x,p.y);
  }
  layer.ctx.fill();
}