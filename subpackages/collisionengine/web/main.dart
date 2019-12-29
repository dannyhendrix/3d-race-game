import "dart:html";
import 'dart:math';

import "package:dependencyinjection/dependencyinjection.dart";
import "package:collisionengine/collision.dart";
import "package:collisionengine/gameitem.dart";
import "package:dashboard/uihelper.dart";
import 'package:gameutils/gameloop.dart';
import 'package:gameutils/math.dart';

ExampleGameState createInitialState(ILifetime lifetime) {
  var state = ExampleGameState();
  state.player
    ..setPolygon(Polygon([Vector(-40.0, -10.0), Vector(40.0, -10.0), Vector(40.0, 10.0), Vector(-40.0, 10.0)]))
    ..applyOffsetRotation(Vector(30.0, 30.0), 0.0)
    ..velocity.x = 3;
  state.walls = [
    GameItemStatic()
      ..setPolygon(Polygon([Vector(-250.0, -10.0), Vector(250.0, -10.0), Vector(250.0, 10.0), Vector(-250.0, 10.0)]))
      ..applyOffsetRotation(Vector(250.0, 10.0), 0.0),
    GameItemStatic()
      ..setPolygon(Polygon([Vector(-250.0, -10.0), Vector(250.0, -10.0), Vector(250.0, 10.0), Vector(-250.0, 10.0)]))
      ..applyOffsetRotation(Vector(250.0, 490.0), 0.0),
    GameItemStatic()
      ..setPolygon(Polygon([Vector(-250.0, -10.0), Vector(250.0, -10.0), Vector(250.0, 10.0), Vector(-250.0, 10.0)]))
      ..applyOffsetRotation(Vector(10.0, 250.0), pi / 2),
    GameItemStatic()
      ..setPolygon(Polygon([Vector(-250.0, -10.0), Vector(250.0, -10.0), Vector(250.0, 10.0), Vector(-250.0, 10.0)]))
      ..applyOffsetRotation(Vector(490.0, 250.0), pi / 2)
  ];
  state.balls = [
    GameItemMovable()
      ..setPolygon(Polygon([Vector(-10.0, -10.0), Vector(10.0, -10.0), Vector(10.0, 10.0), Vector(-10.0, 10.0)]))
      ..applyOffsetRotation(Vector(40.0, 40.0), 0.0),
    GameItemMovable()
      ..setPolygon(Polygon([Vector(-10.0, -10.0), Vector(10.0, -10.0), Vector(10.0, 10.0), Vector(-10.0, 10.0)]))
      ..applyOffsetRotation(Vector(40.0, 90.0), 0.0)
  ];
  return state;
}

ExampleUiState createInitialUiState(ILifetime lifetime) {
  var state = ExampleUiState();
  state.renderlayer = lifetime.resolve()
    ..build()
    ..setSize(500, 500);
  state.buttonUp = lifetime.resolve()
    ..build()
    ..changeText("up");
  return state;
}

void main() {
  var lifetime = DependencyBuilderFactory().createNew((builder) {
    builder.registerModule(UiComposition());
    builder.registerType((lifetime) => CollisionController(lifetime.resolve(), lifetime.resolve()), lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => CollisionDetection(), lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => CollisionHandlingPhysics(), lifeTimeScope: LifeTimeScope.SingleInstance, additionRegistrations: [CollisionHandling]);
    builder.registerType((lifetime) => GameObjectCollisionHandler(), lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => GameObjectCollisionHandlerVehicle(), lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => Example(lifetime), lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => createInitialState(lifetime), lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => createInitialUiState(lifetime), lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => GameLoopHandler(), lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => GameLoopState(), lifeTimeScope: LifeTimeScope.SingleInstance);
  });

  document.body.querySelector("#loading").remove();

  Example example = lifetime.resolve();
  ExampleUiState uistate = lifetime.resolve();
  document.body.append(uistate.renderlayer.canvas);
  document.body.append(uistate.buttonUp.element);
  example.start();
  document.body.onKeyDown.listen(onKeyDown);
  document.body.onKeyUp.listen(onKeyUp);
}

bool keyUp = false;
bool keyDown = false;
bool keyLeft = false;
bool keyRight = false;

void onKeyDown(KeyboardEvent e) {
  setControl(e.keyCode, true);
}

void onKeyUp(KeyboardEvent e) {
  setControl(e.keyCode, false);
}

void setControl(int keyCode, bool down) {
  switch (keyCode) {
    case 37: //left
      keyLeft = down;
      break;
    case 39: //right
      keyRight = down;
      break;
    case 38: //up
      keyUp = down;
      break;
    case 40: //down
      keyDown = down;
      break;
  }
}

class ExampleGameState extends GameLoopState {
  GameItemMovable player = GameItemMovable();
  List<GameItemMovable> balls = List<GameItemMovable>();
  List<GameItemStatic> walls = List<GameItemStatic>();
  GameLoopState gameloop = GameLoopState();
}

class ExampleUiState {
  UiRenderLayer renderlayer;
  UiButtonText buttonUp;
}

class Example {
  ExampleGameState gamestate;
  ExampleUiState uistate;
  GameLoopState gameloopstate;

  GameLoopHandler _gameloop;
  CollisionController _collisionController;
  GameObjectCollisionHandler _collisionHandler;
  GameObjectCollisionHandlerVehicle _collisionHandlerVehicle;

  Example(ILifetime lifetime) {
    gameloopstate = lifetime.resolve();
    uistate = lifetime.resolve();
    gamestate = lifetime.resolve();
    _gameloop = lifetime.resolve();
    _collisionHandler = lifetime.resolve();
    _collisionController = lifetime.resolve();
    _collisionHandlerVehicle = lifetime.resolve();
  }
  void start() {
    uistate.buttonUp.setOnClick(_onButtonUp);
    gameloopstate.onUpdate = _update;
    _gameloop.start(gameloopstate);
  }

  void _onButtonUp() {
    gamestate.player.velocity.addToThis(1.0, 0.0);
  }

  void _applyControl(ExampleGameState gamestate) {
    var max = 5.0;
    var acc = 0.2;
    if (keyDown && gamestate.player.velocity.y < max) gamestate.player.velocity.addToThis(0.0, acc);
    if (keyUp && gamestate.player.velocity.y > -max) gamestate.player.velocity.addToThis(0.0, -acc);
    if (keyRight && gamestate.player.velocity.x < max) gamestate.player.velocity.addToThis(acc, 0.0);
    if (keyLeft && gamestate.player.velocity.x > -max) gamestate.player.velocity.addToThis(-acc, 0.0);
  }

  void _update(num frame) {
    //gamestate.player.applyOffsetRotation(Vector(1.0, 0.0), 0.0);
    _collisionController.handleCollisions2(gamestate.walls, [gamestate.player]);
    _collisionController.handleCollisions2(gamestate.walls, gamestate.balls);
    _collisionController.handleCollisions3(gamestate.balls, [gamestate.player]);
    _collisionController.handleCollisions(gamestate.balls);
    _collisionHandlerVehicle.update(gamestate.player);
    for (var item in gamestate.balls) _collisionHandler.update(item);
    if (!gamestate.player.hasCollided) _applyControl(gamestate);
    _paint(uistate, gamestate);
  }

  void _paint(ExampleUiState uistate, ExampleGameState state) {
    uistate.renderlayer.clear();
    _drawPolygon(state.player.polygon, uistate.renderlayer, "red", 0, 0);
    for (var wall in state.walls) _drawPolygon(wall.polygon, uistate.renderlayer, "black", 0, 0);
    for (var ball in state.balls) _drawPolygon(ball.polygon, uistate.renderlayer, "green", 0, 0);
  }

  void _drawPolygon(Polygon polygon, UiRenderLayer layer, String color, double offsetx, double offsety, [bool stroke = false]) {
    var scale = 1.0;
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
}
