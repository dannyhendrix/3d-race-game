import "dart:html";
import 'dart:math';

import "package:dependencyinjection/dependencyinjection.dart";
import "package:physicsengine/physicsengine.dart";
import "package:dashboard/uihelper.dart";
import 'package:gameutils/gameloop.dart';
import 'package:gameutils/math.dart';

ExampleGameState createInitialState(ILifetime lifetime) {
  var state = ExampleGameState();
  return state;
}

ExampleUiState createInitialUiState(ILifetime lifetime) {
  var state = ExampleUiState();
  state.renderlayer = lifetime.resolve()
    ..build()
    ..setSize(500, 500);
  return state;
}

void main() {
  var lifetime = DependencyBuilderFactory().createNew((builder) {
    builder.registerModule(UiComposition());
    builder.registerSingleInstanceType((lifetime) => Example(lifetime));
    builder.registerSingleInstanceType((lifetime) => createInitialState(lifetime));
    builder.registerSingleInstanceType((lifetime) => createInitialUiState(lifetime));
    builder.registerSingleInstanceType((lifetime) => GameLoopHandler());
    builder.registerSingleInstanceType((lifetime) => GameLoopState());
    builder.registerSingleInstanceType((lifetime) => CollisionDetection());
    builder.registerSingleInstanceType((lifetime) => CollisionHandler());
    builder.registerSingleInstanceType((lifetime) => CollisionController(lifetime.resolve(), lifetime.resolve()));
  });

  document.body.querySelector("#loading").remove();

  Example example = lifetime.resolve();
  ExampleUiState uistate = lifetime.resolve();
  GameLoopState gameloopstate = lifetime.resolve();
  GameLoopHandler gameloop = lifetime.resolve();
  document.body.append(uistate.renderlayer.canvas);
  document.body.append((lifetime.resolve<UiButtonText>()
        ..changeText("pause")
        ..setOnClick(() {
          gameloop.stop(gameloopstate);
        }))
      .element);
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
  PhysicsObject player;
  List<PhysicsObject> bodies = [];
}

class ExampleUiState {
  UiRenderLayer renderlayer;
}

class Example {
  ExampleGameState gamestate;
  ExampleUiState uistate;
  GameLoopState gameloopstate;

  GameLoopHandler _gameloop;
  CollisionController _collisionController;

  Example(ILifetime lifetime) {
    gameloopstate = lifetime.resolve();
    uistate = lifetime.resolve();
    gamestate = lifetime.resolve();
    _gameloop = lifetime.resolve();
    _collisionController = lifetime.resolve();
  }
  void start() {
    gamestate.player = new PhysicsObject.rectangle(10.0, 50.0)..move(230.0, 200.0, 0.0);
    gamestate.bodies.add(gamestate.player);
    gamestate.bodies.add(new PhysicsObject.rectangle(200.0, 10.0)..move(240, 100, 0));
    gamestate.bodies.add(new PhysicsObject.rectangle(200.0, 10.0)
      ..move(240, 300, 0)
      ..setStatic());

    gameloopstate.onUpdate = _update;
    _gameloop.start(gameloopstate);
  }

  void _applyControl(ExampleGameState gamestate) {
    var max = 5.0;
    var acc = 0.2;
    var f = 300000.0;
    //print("$keyDown,$keyUp,$keyLeft,$keyRight");

    if (keyDown) gamestate.player.force.addToThis(0.0, f);
    //if (keyDown) gamestate.player.torque = 600000.0;
    if (keyUp) gamestate.player..force.addToThis(0.0, -f);
    //if (keyUp) gamestate.player.torque = -600000.0;

    if (keyRight) gamestate.player.force.addToThis(f, 0.0);
    if (keyLeft) gamestate.player.force.addToThis(-f, 0.0);
    //if (keyDown && gamestate.player.velocity.y < max) gamestate.player.velocity.addToThis(0.0, acc);
    //if (keyUp && gamestate.player.velocity.y > -max) gamestate.player.velocity.addToThis(0.0, -acc);
    //if (keyRight && gamestate.player.velocity.x < max) gamestate.player.velocity.addToThis(acc, 0.0);
    //if (keyLeft && gamestate.player.velocity.x > -max) gamestate.player.velocity.addToThis(-acc, 0.0);
  }

  void _update(num frame) {
    _applyControl(gamestate);
    _collisionController.step(gamestate.bodies);
    _paint(uistate, gamestate);
    //_gameloop.stop(gameloopstate);
  }

  void _paint(ExampleUiState uistate, ExampleGameState state) {
    uistate.renderlayer.clear();

    uistate.renderlayer.ctx.strokeStyle = "black";
    uistate.renderlayer.ctx.fillStyle = "black";
    for (var p in gamestate.bodies) {
      uistate.renderlayer.ctx.beginPath();
      uistate.renderlayer.ctx.moveTo(p.center.x - 5, p.center.y);
      uistate.renderlayer.ctx.lineTo(p.center.x + 5, p.center.y);
      uistate.renderlayer.ctx.closePath();
      uistate.renderlayer.ctx.stroke();
      uistate.renderlayer.ctx.beginPath();
      uistate.renderlayer.ctx.moveTo(p.center.x, p.center.y - 5);
      uistate.renderlayer.ctx.lineTo(p.center.x, p.center.y + 5);
      uistate.renderlayer.ctx.closePath();
      uistate.renderlayer.ctx.stroke();

      uistate.renderlayer.ctx.beginPath();
      for (int i = 0; i < p.vertices.length; i++) {
        var v = p.vertices[i];
        if (i == 0) {
          uistate.renderlayer.ctx.moveTo(v.x, v.y);
        } else {
          uistate.renderlayer.ctx.lineTo(v.x, v.y);
        }
      }
      uistate.renderlayer.ctx.closePath();
      uistate.renderlayer.ctx.stroke();
    }
  }

  void _drawPolygon(List<Vector> vertices, UiRenderLayer layer, String color, double offsetx, double offsety, [bool stroke = false]) {
    var scale = 1.0;
    layer.ctx.beginPath();
    layer.ctx.moveTo((vertices.first.x * scale - offsetx), (vertices.first.y * scale - offsety));
    for (var p in vertices) {
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
