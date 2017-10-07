import "package:preloader/preloader.dart";
import "package:logging/logging.dart";
import "package:micromachines/game.dart";
import "package:micromachines/webgl.dart";
import "package:micromachines/webgl_game.dart";
import "package:renderlayer/renderlayer.dart";
import "package:gameutils/gameloop.dart";
import "package:gameutils/math.dart";
import "dart:html";
import "dart:math" as Math;
import "dart:web_gl";

Element el_Fps;
Game game;

GlRenderLayer layer;
List<GlModelInstanceCollection> modelInstances = [];
GlCameraDistanseToTarget camera;
double cameraZOffset = 1800.0;
double cameraZRotation = -1.0;

class GlModelInstanceFromVehicle extends GlModelInstanceCollection{
  GameObject gameObject;
  double get x => gameObject.position.x;
  double get z => gameObject.position.y;
  double get ry => -gameObject.r;
  GlModelInstanceFromVehicle(this.gameObject, GlModelInstanceCollection model):super([]){
    this.modelInstances = model.modelInstances;
  }
}
class GlModelInstanceFromGameObject extends GlModelInstanceCollection{
  GameObject gameObject;
  double get x => gameObject.position.x;
  double get z => gameObject.position.y;
  double get ry => -gameObject.r;
  GlModelInstanceFromGameObject(this.gameObject, GlModelInstanceCollection model):super(model.modelInstances);
}
class GlModelInstanceCheckpoint extends GlModelInstanceCollection{
  Game game;
  double get x => game.humanPlayer.pathProgress.current.x;
  double get z => game.humanPlayer.pathProgress.current.y;
  double get ry => 0.0;
  GlModelInstanceCheckpoint(this.game, GlModelInstanceCollection model):super(model.modelInstances);
}

void main()
{
  //logger
  Logger.root.level = Level.OFF;

  double windowW = 800.0;
  double windowH = 500.0;
  layer = new GlRenderLayer.withSize(windowW.toInt(),windowH.toInt());
  el_Fps = new DivElement();
  document.body.append(layer.canvas);
  document.body.append(el_Fps);
  print("Hi");

  // Tell WebGL how to convert from clip space to pixels
  layer.ctx.viewport(0, 0, layer.canvas.width, layer.canvas.height);

  //3 set view perspective
  camera = new GlCameraDistanseToTarget();
  camera.setPerspective(aspect:windowW / windowH, fieldOfViewRadians: 0.5, zFar: 4000.0);
  /*
  camera.y = 800.0;
  camera.x = 100.0;
  camera.z = -100.0;
  */

  game = new Game();
  game.init();
  game.start();
//units/actual
  //4 4 8
  GlModelCollection modelCollection = new GlModelCollection(layer);
  GlModel_Vehicle vehicleModel2 = new GlModel_Vehicle();
  vehicleModel2.loadModel(modelCollection,game.players[0].vehicle.w/1.0, 50.0/1.0, game.players[0].vehicle.h/1.0);
  //createVehicleModel().modelInstances.forEach((GlModelInstance model) => modelInstances.add(model));
  GlColor colorWindows = new GlColor(0.2,0.2,0.2);
  var colors1 = [new GlColor(1.0,1.0,0.0),new GlColor(1.0,0.0,0.0),new GlColor(0.0,1.0,0.0),new GlColor(1.0,0.0,1.0),new GlColor(1.0,1.0,1.0),new GlColor(1.0,1.0,1.0)];
  var colors2 = [new GlColor(0.0,0.0,1.0),new GlColor(1.0,1.0,1.0),new GlColor(0.2,0.2,0.2),new GlColor(1.0,1.0,1.0),new GlColor(1.0,0.0,0.0),new GlColor(0.0,0.0,1.0)];
  int c = 0;
  //create all buffer
  for(GameObject o in game.gameobjects){
    if(o is Vehicle){
      modelInstances.add(new GlModelInstanceFromVehicle(o, vehicleModel2.getModelInstance(modelCollection, colors1[c], colors2[c], colorWindows)));

      c++;
      if(c >= colors1.length) c = 0;
    }else{
      double h = o is Wall ? 150.0 : 80.0;
      GlModelBuffer cube = new GlCube.fromTopCenter(0.0,0.0,0.0,o.w,h,o.h).createBuffers(layer);
      modelInstances.add(new GlModelInstanceFromGameObject(o, new GlModelInstanceCollection([new GlModelInstance(cube, new GlColor(1.0,1.0,1.0))])));
    }
  }

  GlModel worldModel = new GlAreaModel([new GlRectangle.withWD(0.0,0.0,0.0,1500.0,800.0,false)]);
  GlModelBuffer world = worldModel.createBuffers(layer);
  modelInstances.add(new GlModelInstanceCollection([new GlModelInstance(world, new GlColor(0.6,0.6,0.6))]));

  GlModelBuffer cube = new GlCube.fromTopCenter(0.0,0.0,0.0,30.0,30.0,30.0).createBuffers(layer);
  modelInstances.add(new GlModelInstanceCheckpoint(game, new GlModelInstanceCollection([new GlModelInstance(cube, new GlColor(1.0,1.0,0.0))])));

  // Start off the infinite animation loop
  tick(0);

  var handleKey = (KeyboardEvent e)
  {
    //if(!gameloop.playing || gameloop.stopping)
      //return;
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
      game.players[1].onControl(Control.SteerRight,down);*/
    else return;

    e.preventDefault();
  };

  document.onKeyDown.listen(handleKey);
  document.onKeyUp.listen(handleKey);
}

/**
 * This is the infinite animation loop; we request that the web browser
 * call us back every time its ready for a new frame to be rendered. The [time]
 * parameter is an increasing value based on when the animation loop started.
 */
tick(time) {
  window.animationFrame.then(tick);
  frameCount(time);

  game.update();

  layer.clearForNextFrame();

  camera.setCameraAngleAndOffset(new GlVector(game.players[0].vehicle.position.x,0.0,game.players[0].vehicle.position.y),rx:cameraZRotation,offsetZ:cameraZOffset);
  /*
  camera.tx = game.players[0].vehicle.position.x;
  camera.x = game.players[0].vehicle.position.x;
  camera.tz = game.players[0].vehicle.position.y;
  camera.z = game.players[0].vehicle.position.y-300.0;
*/
  var viewProjectionMatrix = camera.cameraMatrix;//perspective*viewMatrix;


  // Draw a F at the origin
  var worldMatrix = GlMatrix.rotationYMatrix(0.0);

  // Multiply the matrices.
  var worldViewProjectionMatrix = viewProjectionMatrix * worldMatrix;


  //2 call draw method with buffer
  for(GlModelInstanceCollection m in modelInstances){
    GlMatrix objPerspective = worldMatrix.translate(m.x,m.y,m.z);
    objPerspective = objPerspective.rotateX(m.rx);
    objPerspective = objPerspective.rotateY(m.ry);
    objPerspective = objPerspective.rotateZ(m.rz);
    layer.setWorld(objPerspective,viewProjectionMatrix*objPerspective, new GlVector(-1.0,0.8,0.6), 0.4);
    for(GlModelInstance mi in m.modelInstances) layer.drawModel(mi);
  }
}

/// FPS meter - activated when the url parameter "fps" is included.
const num ALPHA_DECAY = 0.1;
const num INVERSE_ALPHA_DECAY = 1 - ALPHA_DECAY;
const SAMPLE_RATE_MS = 500;
const SAMPLE_FACTOR = 1000 ~/ SAMPLE_RATE_MS;
int frames = 0;
num lastSample = 0;
num averageFps = 1;

void frameCount(num now) {
  frames++;
  if ((now - lastSample) < SAMPLE_RATE_MS) return;
  averageFps = averageFps * ALPHA_DECAY + frames * INVERSE_ALPHA_DECAY * SAMPLE_FACTOR;
  el_Fps.text = averageFps.toStringAsFixed(2);
  frames = 0;
  lastSample = now;
}






abstract class InputWithValue<T>{
  Element element;
  T getValue();
  void setValue(T v);
}

Element createButton(String labelText, Function onClick){
  var btn = new ButtonElement();
  btn.text = labelText;
  btn.onClick.listen(onClick);
  return btn;
}

class InputWithDoubleValue extends InputWithValue<double>{
  InputElement _inputElement;
  SpanElement _readValue;

  void setValue(double v){
    _readValue.text = v.toString();
  }
  double getValue(){
    return double.parse(_inputElement.value);
  }

  InputWithDoubleValue(double value, String labelText, Function onChange){
    element = new DivElement();
    _readValue = new SpanElement();
    _inputElement = new InputElement();
    _inputElement.onChange.listen(onChange);
    _inputElement.value = value.toString();
    var label = new SpanElement();
    label.text = labelText;
    label.style.width = "300px";
    label.style.display = "inline-block";
    element.append(label);
    element.append(_readValue);
    element.append(_inputElement);
  }
}