import "dart:html";
import 'dart:math';

import "package:dependencyinjection/dependencyinjection.dart";
import "package:physicsengine/physicsengine.dart";
import "package:dashboard/uihelper.dart";
import 'package:gameutils/gameloop.dart';
import 'package:gameutils/math.dart';

ExampleGameState createInitialState(ILifetime lifetime) {
  var state = ExampleGameState();
  state.player = new Vehicle();
  return state;
}

ExampleUiState createInitialUiState(ILifetime lifetime) {
  var state = ExampleUiState();
  state.renderlayer = lifetime.resolve()
    ..build()
    ..setSize(600, 600);
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
  ExampleGameState state = lifetime.resolve();
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
  document.body.append((lifetime.resolve<UiInputDouble>()
        ..changeLabel("forwardSpeed")
        ..setValue(state.player.forwardSpeed)
        ..setOnValueChange((double v) {
          state.player.forwardSpeed = v;
        }))
      .element);
  document.body.append((lifetime.resolve<UiInputDouble>()
        ..changeLabel("reverseSpeed")
        ..setValue(state.player.reverseSpeed)
        ..setOnValueChange((double v) {
          state.player.reverseSpeed = v;
        }))
      .element);
  document.body.append((lifetime.resolve<UiInputDouble>()
        ..changeLabel("steerspeed")
        ..setValue(state.player.steerSpeed)
        ..setOnValueChange((double v) {
          state.player.steerSpeed = v;
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
  Vehicle player;
  Chain chain;
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
    var border = 20.0;
    gamestate.player.move(230.0, 200.0, 0.0);
    gamestate.bodies.add(gamestate.player);
    gamestate.bodies.add(new Trailer()..move(140.0, 200.0, 0.0));
    gamestate.chain = new Chain(gamestate.bodies[0], gamestate.bodies[1]);

    gamestate.bodies.add(new Ball()..move(240, 100, 0));
    //walls

    gamestate.bodies.add(new PhysicsObject.rectangle(1200.0, border)
      ..move(600, border / 2, 0)
      ..setStatic());
    gamestate.bodies.add(new PhysicsObject.rectangle(1200.0, border)
      ..move(600, 1200 - border / 2, 0)
      ..setStatic());
    gamestate.bodies.add(new PhysicsObject.rectangle(border, 1200.0)
      ..move(border / 2, 600, 0)
      ..setStatic());
    gamestate.bodies.add(new PhysicsObject.rectangle(border, 1200.0)
      ..move(1200 - border / 2, 600, 0)
      ..setStatic());

    print(gamestate.player.mass);
    print(gamestate.player.invMass);

    gameloopstate.onUpdate = _update;
    _gameloop.start(gameloopstate);
  }

  void _applyControl(ExampleGameState gamestate) {
    if (keyDown) gamestate.player.reverse();
    if (keyUp) gamestate.player.forward();

    if (keyRight) gamestate.player.steerRight();
    if (keyLeft) gamestate.player.steerLeft();
  }

  void _update(num frame) {
    _applyControl(gamestate);
    var contacts = _collisionController.step(gamestate.bodies, gamestate.chain);
    _paint(uistate, gamestate, contacts);
    //_gameloop.stop(gameloopstate);
  }

  void _paint(ExampleUiState uistate, ExampleGameState state, List<Manifold> contacts) {
    uistate.renderlayer.clear();

    var scale = 0.5;
    for (var p in gamestate.bodies) {
      uistate.renderlayer.ctx.strokeStyle = "blue";
      drawCross(uistate.renderlayer, p.center.x, p.center.y, 5, scale);
      uistate.renderlayer.ctx.strokeStyle = "red";
      drawCross(uistate.renderlayer, p.chainLocation.x, p.chainLocation.y, 5, scale);
      uistate.renderlayer.ctx.strokeStyle = "black";
      _drawPolygon(uistate.renderlayer, p.vertices, scale);
    }
    for (var c in contacts) {
      //drawCross(uistate.renderlayer, c.A.center.x + c.normal.x, c.A.center.y + c.normal.y, 5, scale);
      for (var i = 0; i < c.contactCount; i++) {
        var cc = c.contacts[i];
        uistate.renderlayer.ctx.strokeStyle = "green";
        drawCross(uistate.renderlayer, cc.x + c.normal.x * 20, cc.y + c.normal.y * 20, 5, scale);
        uistate.renderlayer.ctx.strokeStyle = "darkgreen";
        drawCross(uistate.renderlayer, cc.x, cc.y, 5, scale);
      }
    }
  }

  void drawCross(UiRenderLayer layer, double x, double y, double size, double scale) {
    x *= scale;
    y *= scale;
    size *= scale;
    uistate.renderlayer.ctx.beginPath();
    uistate.renderlayer.ctx.moveTo(x - size, y);
    uistate.renderlayer.ctx.lineTo(x + size, y);
    uistate.renderlayer.ctx.closePath();
    uistate.renderlayer.ctx.stroke();
    uistate.renderlayer.ctx.beginPath();
    uistate.renderlayer.ctx.moveTo(x, y - size);
    uistate.renderlayer.ctx.lineTo(x, y + size);
    uistate.renderlayer.ctx.closePath();
    uistate.renderlayer.ctx.stroke();
  }

  void _drawPolygon(UiRenderLayer layer, List<Vector> vertices, double scale) {
    layer.ctx.beginPath();
    for (int i = 0; i < vertices.length; i++) {
      var v = vertices[i];
      if (i == 0) {
        layer.ctx.moveTo(v.x * scale, v.y * scale);
      } else {
        layer.ctx.lineTo(v.x * scale, v.y * scale);
      }
    }
    layer.ctx.closePath();
    layer.ctx.stroke();
  }
}

class Ball extends PhysicsObject {
  Ball() : super.rectangle(30.0, 30.0) {
    impulseImpact = 3.5;
  }
}

class Trailer extends PhysicsObject {
  Trailer() : super.rectangle(50.0, 30.0) {
    chainLocation.resetToPosition(65, 0);
  }
}

class Vehicle extends PhysicsObject {
  Vehicle() : super.rectangle(50.0, 30.0) {
    chainLocation.resetToPosition(-25, 0);
  }
  double angle = 0.0;
  double forwardSpeed = 7000.0;
  double reverseSpeed = 2000.0;
  double steerSpeed = 40000.0;
  @override
  void move(double x, double y, double radians) {
    angle += radians;
    super.move(x, y, radians);
  }

  void forward() {
    force.addVectorToThis(Vector.fromAngleRadians(angle, forwardSpeed));
  }

  void reverse() {
    force.addVectorToThis(Vector.fromAngleRadians(angle, -reverseSpeed));
  }

  void steerLeft() {
    torque -= steerSpeed;
  }

  void steerRight() {
    torque += steerSpeed;
  }
}
