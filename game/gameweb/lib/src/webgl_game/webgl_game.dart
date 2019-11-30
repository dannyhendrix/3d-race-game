part of webgl_game;
/**
 * Flow:
 * UI form -> select game settings
 * UI form -> start race
 * WebglGame.start(gameSettings);
 */

typedef void OnGameFinished(GameOutput result);

abstract class WebglGame {
  OnGameFinished onGameFinished;
  Element initAndCreateDom(GameInput input, GameSettings settings);
  void start();
  void stop();
  void pause();
  bool onControl(Control control, bool active);

  void _registerControls(InputController inputController) {
    inputController.onControlChange = onControl;
    document.onKeyDown.listen(inputController.handleKey);
    document.onKeyUp.listen(inputController.handleKey);
  }
}

class WebglGame2d extends WebglGame {
  Game game;
  GameState gameState;
  UiRenderLayer layer;
  GameLoop _gameloop;
  int screenw = 800;
  int screenh = 500;
  WebglGame2d(ILifetime lifetime) {
    game = lifetime.resolve();
    layer = lifetime.resolve();
    _gameloop = new GameLoop();
    _gameloop.setOnUpdate(_loop);
    gameState = game.state;
  }

  Element initAndCreateDom(GameInput input, GameSettings settings) {
    game.initSession(input);
    layer.setSize(screenw, screenh);
    //document.body.append(layer.canvas);
    InputController inputController = new InputController(settings);
    _registerControls(inputController);
    return layer.canvas;
  }

  bool onControl(Control control, bool active) {
    if (!_gameloop.playing || _gameloop.stopping) return false;
    game.onControl(game.state.humanPlayer, control, active);

    return true;
  }

  void start() {
    game.startSession();
    _gameloop.trigger(LoopTrigger.Start);
  }

  void pause() {
    _gameloop.trigger(LoopTrigger.Toggle);
  }

  void stop() {
    _gameloop.trigger(LoopTrigger.Stop);
  }

  void _loop(int now) {
    game.step();
    layer.clear();

    //draw road
    layer.ctx.fillStyle = "#111";
    layer.ctx.strokeStyle = "#111";
    for (Polygon p in game.state.level.roadPolygons) {
      _drawRoadPolygon(p, layer);
    }
/*
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
*/
    //draw gameObjects
    for (var o in gameState.trees) _drawPolygon(o.polygon, layer, "blue");
    for (var o in gameState.walls) _drawPolygon(o.polygon, layer, "blue");
    for (var o in gameState.checkpointPosts) _drawPolygon(o.polygon, layer, "blue");
    for (var o in gameState.vehicles) {
      _drawPolygon(o.polygon, layer, o.isCollided ? "red" : "green");
      for (var s in o.sensors) {
        _drawPolygon(s.polygon, layer, s.collides ? "red" : "#ffffff", true);
      }
    }
    for (var o in gameState.trailers) _drawPolygon(o.polygon, layer, "blue");
    for (var o in gameState.checkpoints) {
      var current = (gameState.humanPlayer.pathProgress as PathProgressCheckpoint).currentIndex;
      var index = o.index;
      _drawPolygon(o.polygon, layer, index == current ? "yellow" : (index == 0 ? "#fff" : "#999"));
    }

    layer.ctx.font = "10px Arial";
    layer.ctx.fillText("Vehicle: ${gameState.playerRanking[0].vehicle.info}", 10, 10);
    if (!gameState.countdown.complete) {
      layer.ctx.font = "124px Arial";
      layer.ctx.fillText("${gameState.countdown.count}", 400, 400);
    }
  }

  void _drawPolygon(Polygon polygon, UiRenderLayer layer, String color, [bool stroke = false]) {
    var midx = screenw / 2;
    var midy = screenh / 2;
    var scale = 0.5;
    var offsetx = gameState.humanPlayer.vehicle.position.x * scale - midx;
    var offsety = gameState.humanPlayer.vehicle.position.y * scale - midy;
    layer.ctx.beginPath();
    layer.ctx.moveTo((polygon.points.first.x * scale - offsetx), (polygon.points.first.y * scale - offsety));
    for (var p in polygon.points) {
      layer.ctx.lineTo((p.x * scale - offsetx), (p.y * scale - offsety));
    }
    if (stroke) {
      layer.ctx.strokeStyle = color;
      layer.ctx.stroke();
    } else {
      layer.ctx.fillStyle = color;
      layer.ctx.fill();
    }
  }

  void _drawRoadPolygon(Polygon polygon, UiRenderLayer layer) {
    var midx = screenw / 2;
    var midy = screenh / 2;
    var scale = 0.5;
    var offsetx = gameState.humanPlayer.vehicle.position.x * scale - midx;
    var offsety = gameState.humanPlayer.vehicle.position.y * scale - midy;
    layer.ctx.beginPath();
    var first = polygon.points.first;
    layer.ctx.moveTo((first.x * scale - offsetx), (first.y * scale - offsety));
    for (var p in polygon.points) {
      layer.ctx.lineTo((p.x * scale - offsetx), (p.y * scale - offsety));
    }
    layer.ctx.lineTo((first.x * scale - offsetx), (first.y * scale - offsety));
    layer.ctx.fill();
    layer.ctx.stroke();
  }
}
