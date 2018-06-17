part of webgl_game;
/**
 * Flow:
 * UI form -> select game settings
 * UI form -> start race
 * WebglGame.start(gameSettings);
 */

typedef void OnGameFinished(GameOutput result);

abstract class WebglGame{
  OnGameFinished onGameFinished;
  Element initAndCreateDom(GameInput input, GameSettings settings);
  void start();
  void stop();
  void pause([bool forceStart = null]);
  bool onControl(Control control, bool active);

  void _registerControls(InputController inputController){
    inputController.onControlChange = onControl;
    document.onKeyDown.listen(inputController.handleKey);
    document.onKeyUp.listen(inputController.handleKey);
  }
}

class WebglGame2d extends WebglGame{
  Game game;
  RenderLayer layer;
  GameLoop _gameloop;
  WebglGame2d(GameSettings settings){
    game = new Game(settings);
    _gameloop = new GameLoop(_loop);
  }

  Element initAndCreateDom(GameInput input, GameSettings settings){
    game.initSession(input);
    layer = new RenderLayer.withSize(1500,800);
    //document.body.append(layer.canvas);
    InputController inputController = new InputController(settings);
    _registerControls(inputController);
    return layer.canvas;
  }

  bool onControl(Control control, bool active){
    if(!_gameloop.playing || _gameloop.stopping)
      return false;
    game.humanPlayer.onControl(control,active);
    return true;
  }

  void start(){
    game.startSession();
    _gameloop.play();
  }

  void pause([bool forceStart = null]){
    _gameloop.pause(forceStart);
  }
  void stop(){
    _gameloop.stop();
  }

  void _loop(int now){
    game.step();
    layer.clear();

    //draw road
    layer.ctx.fillStyle = "#111";
    layer.ctx.strokeStyle = "#111";
    for(Polygon p in game.path.roadPolygons){
      _drawRoadPolygon(p, layer);
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
      layer.ctx.arc(p.x, p.y, p.radius, 0, 2 * Math.pi, false);
      layer.ctx.stroke();
    }

    //draw gameObjects
    for(GameObject o in game.gameobjects){
      Matrix2d M = o.getTransformation();
      var absolutePolygons = o.getAbsoluteCollisionFields();
      //draw gameObjects
      if(o is Vehicle){
        Vehicle v = o;
        _drawPolygon(absolutePolygons.first, layer, v.isCollided ? "red" : "green");
        for(var s in v.sensors){
          //print(s.collides);
          _drawPolygon(s.polygon.applyMatrix(M), layer, s.collides ? "red" : "#ffffff", true);
        }
      }else{
        for(Polygon p in absolutePolygons) _drawPolygon(p, layer, "blue");
      }

      layer.ctx.beginPath();
      layer.ctx.arc(o.position.x, o.position.y, 2, 0, 2 * Math.pi, false);
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
  }

  void _drawPolygon(Polygon polygon, RenderLayer layer, String color, [bool stroke = false]){
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
  void _drawRoadPolygon(Polygon polygon,RenderLayer layer){
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
}