import "package:preloader/preloader.dart";
import "package:logging/logging.dart";
import "package:micromachines/game.dart";
import "package:micromachines/webgl.dart";
import "package:renderlayer/renderlayer.dart";
import "package:gameutils/gameloop.dart";
import "package:gameutils/math.dart";
import "dart:html";
import "dart:math" as Math;
import "dart:web_gl";

Element el_Fps;
Game game;

GlRenderLayer layer;
List<GlModelInstance> modelInstances = [];
GlCamera camera;

class GlModelInstanceFromGameObject extends GlModelInstance{
  GameObject gameObject;
  double get x => gameObject.position.x;
  double get z => gameObject.position.y;
  double get ry => -gameObject.r;
  GlColor white = new GlColor(1.0,1.0,1.0);
  GlColor red = new GlColor(1.0,0.0,0.0);
  GlColor blue = new GlColor(0.0,0.0,1.0);
  GlColor get color{
    if(!(gameObject is Vehicle)) return white;
    Vehicle v = gameObject;
    if(v.isCollided) return red;
    return blue;
  }
  GlModelInstanceFromGameObject(this.gameObject, GlModelBuffer modelBuffer):super(modelBuffer, new GlColor());
}

void main()
{
  //logger
  Logger.root.level = Level.OFF;

  layer = new GlRenderLayer.withSize(400,500);
  el_Fps = new DivElement();
  document.body.append(layer.canvas);
  document.body.append(el_Fps);
  print("Hi");

  // Tell WebGL how to convert from clip space to pixels
  layer.ctx.viewport(0, 0, layer.canvas.width, layer.canvas.height);

  //3 set view perspective
  camera = new GlCamera(400.0 / 500.0);
  camera.y = 800.0;
  camera.x = 100.0;
  camera.z = -100.0;

  game = new Game();
  game.init();
  game.start();

  //create all buffer
  for(GameObject o in game.gameobjects){
    double h = o is Wall ? 150.0 : 80.0;
    GlModelBuffer cube = new GlCube.fromTopCenter(0.0,0.0,0.0,o.w,h,o.h).createBuffers(layer);
    modelInstances.add(new GlModelInstanceFromGameObject(o, cube));
  }

  GlModel worldModel = new GlModel([new GlRectangle.withWD(0.0,0.0,0.0,1500.0,800.0,false)]);
  GlModelBuffer world = worldModel.createBuffers(layer);
  modelInstances.add(new GlModelInstance(world, new GlColor(0.3,0.3,0.3)));

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
      game.players[0].onControl(Control.Accelerate,down);
    else if(key == 40)//down
      game.players[0].onControl(Control.Brake,down);
    else if(key == 37)//left
      game.players[0].onControl(Control.SteerLeft,down);
    else if(key == 39)//right
      game.players[0].onControl(Control.SteerRight,down);

    else if(key == 87)//w
      game.players[1].onControl(Control.Accelerate,down);
    else if(key == 83)//s
      game.players[1].onControl(Control.Brake,down);
    else if(key == 65)//a
      game.players[1].onControl(Control.SteerLeft,down);
    else if(key == 68)//d
      game.players[1].onControl(Control.SteerRight,down);
    else return;

    e.preventDefault();
  };

  InputWithDoubleValue currentValueXInput;
  currentValueXInput = new InputWithDoubleValue(camera.x, "X", (Event e){ camera.x = currentValueXInput.getValue(); });
  document.body.append(currentValueXInput.element);
  InputWithDoubleValue currentValueYInput;
  currentValueYInput = new InputWithDoubleValue(camera.y, "Y", (Event e){ camera.y = currentValueYInput.getValue(); });
  document.body.append(currentValueYInput.element);
  InputWithDoubleValue currentValueZInput;
  currentValueZInput = new InputWithDoubleValue(camera.z, "Z", (Event e){ camera.z = currentValueZInput.getValue(); });
  document.body.append(currentValueZInput.element);

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

  camera.tx = game.players[0].vehicle.position.x;
  camera.x = game.players[0].vehicle.position.x;
  camera.tz = game.players[0].vehicle.position.y;
  camera.z = game.players[0].vehicle.position.y-300.0;
  var viewProjectionMatrix = camera.createMatrix();//perspective*viewMatrix;


  // Draw a F at the origin
  var worldMatrix = GlMatrix.rotationYMatrix(0.0);

  // Multiply the matrices.
  var worldViewProjectionMatrix = viewProjectionMatrix * worldMatrix;


  //2 call draw method with buffer
  for(GlModelInstance m in modelInstances){
    GlMatrix objPerspective = worldMatrix.translate(m.x,m.y,m.z);
    objPerspective = objPerspective.rotateX(m.rx);
    objPerspective = objPerspective.rotateY(m.ry);
    objPerspective = objPerspective.rotateZ(m.rz);
    layer.setWorld(objPerspective,viewProjectionMatrix*objPerspective, new GlVector(-1.0,0.8,0.6));
    layer.drawModel(m);
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