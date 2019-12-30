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
  GameLoopState gameloop = GameLoopState();
}

class ExampleUiState {
  UiRenderLayer renderlayer;
}

class Example {
  ExampleGameState gamestate;
  ExampleUiState uistate;
  GameLoopState gameloopstate;

  GameLoopHandler _gameloop;
  ImpulseScene impulse = new ImpulseScene(ImpulseMath.DT, 10);

  Example(ILifetime lifetime) {
    gameloopstate = lifetime.resolve();
    uistate = lifetime.resolve();
    gamestate = lifetime.resolve();
    _gameloop = lifetime.resolve();
  }
  void start() {
    Body b = null;

    b = impulse.add(new PolygonShape.rectangle(10.0, 50.0), 230, 200);
    b.setOrient(0);
    b = impulse.add(new PolygonShape.rectangle(200.0, 10.0), 240, 100);
    b.setOrient(0);
    b = impulse.add(new PolygonShape.rectangle(200.0, 10.0), 240, 300);
    b.setStatic();
    b.setOrient(0);

    gameloopstate.onUpdate = _update;
    _gameloop.start(gameloopstate);
  }

  void _applyControl(ExampleGameState gamestate) {
    var max = 5.0;
    var acc = 0.2;
    //if (keyDown && gamestate.player.velocity.y < max) gamestate.player.velocity.addToThis(0.0, acc);
    //if (keyUp && gamestate.player.velocity.y > -max) gamestate.player.velocity.addToThis(0.0, -acc);
    //if (keyRight && gamestate.player.velocity.x < max) gamestate.player.velocity.addToThis(acc, 0.0);
    //if (keyLeft && gamestate.player.velocity.x > -max) gamestate.player.velocity.addToThis(-acc, 0.0);
  }

  void _update(num frame) {
    impulse.step();
    _paint(uistate, gamestate);
    //_gameloop.stop(gameloopstate);
  }

  void _paint(ExampleUiState uistate, ExampleGameState state) {
    uistate.renderlayer.clear();

    uistate.renderlayer.ctx.strokeStyle = "black";
    uistate.renderlayer.ctx.fillStyle = "black";
    for (Body b in impulse.bodies) {
      //print(b.shape.u);
      PolygonShape p = b.shape;

      uistate.renderlayer.ctx.beginPath();
      for (int i = 0; i < p.vertexCount; i++) {
        Vec2 v = p.vertices[i].clone();
        b.shape.u.mulV(v);
        v.addV(b.shape.u.position());

        if (i == 0) {
          uistate.renderlayer.ctx.moveTo(v.x, v.y);
        } else {
          uistate.renderlayer.ctx.lineTo(v.x, v.y);
        }
      }
      uistate.renderlayer.ctx.closePath();
      uistate.renderlayer.ctx.stroke();

      /*
      } else if (b.shape is PolygonShape) {
        PolygonShape polygon = b.shape;
        var verts = List<Vec2>();
        for (var v in polygon.vertices) {
          var v2 = v.clone();
          b.shape.u.mulV(v2);
          v2.addV(b.position);
          verts.add(v2);
        }
        _drawPolygon(verts, uistate.renderlayer, "black", 0, 0);
      }*/
    }

    uistate.renderlayer.ctx.strokeStyle = "green";
    for (Manifold m in impulse.contacts) {
      for (int i = 0; i < m.contactCount; i++) {
        Vec2 v = m.contacts[i];
        Vec2 n = m.normal;

        uistate.renderlayer.ctx.beginPath();
        uistate.renderlayer.ctx.moveTo(v.x, v.y);
        uistate.renderlayer.ctx.lineTo(v.x + n.x * 8.0, v.y + n.y * 8.0);
        uistate.renderlayer.ctx.stroke();
      }
    }
  }

  void _drawPolygon(List<Vec2> vertices, UiRenderLayer layer, String color, double offsetx, double offsety, [bool stroke = false]) {
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
