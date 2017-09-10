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
RenderLayer3d layer;
Render render;
Game game;

InputWithValue currentValueXInput;
InputWithValue currentValueYInput;
InputWithValue currentValueZInput;
InputWithValue currentValueRXInput;
InputWithValue currentValueRYInput;
InputWithValue currentValueRZInput;

void main()
{
  //logger
  Logger.root.level = Level.OFF;

  layer = new RenderLayer3d(500,500);
  el_Fps = new DivElement();
  print("Hi");

  document.body.append(layer.canvas);
  document.body.append(el_Fps);

  render = new Render(layer);

  el_Fps = new DivElement();

  game = new Game();
  game.init();
  game.start();


  for(GameObject o in game.gameobjects){
    double h = o is Wall ? 50.0 : 30.0;
    render.drawobjects.add(new GlCubeGameObject(o, h, layer.ctx));
  }



  currentValueXInput = new InputWithDoubleValue(0.0, "X", (Event e){ render.x = currentValueXInput.getValue(); });
  currentValueYInput = new InputWithDoubleValue(0.0, "Y", (Event e){ render.y = currentValueYInput.getValue(); });
  currentValueZInput = new InputWithDoubleValue(0.0, "Z", (Event e){ render.z = currentValueZInput.getValue(); });
  currentValueRXInput = new InputWithDoubleValue(0.0, "RX", (Event e){ render.rx = currentValueRXInput.getValue(); });
  currentValueRYInput = new InputWithDoubleValue(0.0, "RY", (Event e){ render.ry = currentValueRYInput.getValue(); });
  currentValueRZInput = new InputWithDoubleValue(0.0, "RZ", (Event e){ render.rz = currentValueRZInput.getValue(); });




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
      control = Control.Accelerate;
    else if(key == 40)//down
      control = Control.Brake;
    else if(key == 37)//left
      control = Control.SteerLeft;
    else if(key == 39)//right
      control = Control.SteerRight;
    else return;

    e.preventDefault();
    game.player.onControl(control, down);
  };

  document.onKeyDown.listen(handleKey);
  document.onKeyUp.listen(handleKey);

  document.body.append(currentValueXInput.element);
  document.body.append(currentValueYInput.element);
  document.body.append(currentValueZInput.element);
  document.body.append(currentValueRXInput.element);
  document.body.append(currentValueRYInput.element);
  document.body.append(currentValueRZInput.element);
}

/**
 * This is the infinite animation loop; we request that the web browser
 * call us back every time its ready for a new frame to be rendered. The [time]
 * parameter is an increasing value based on when the animation loop started.
 */
tick(time) {
  window.animationFrame.then(tick);
  frameCount(time);
  //render.cube2.z += 0.01;
  //render.y += 0.01;
  //render.z += 0.01;

  game.update();
  render.x = -game.player.vehicle.position.x;
  //render.z = -game.player.vehicle.position.y+50.0;
  //render.ry = -game.player.vehicle.r;

  currentValueXInput.setValue(render.x);
  currentValueYInput.setValue(render.y);
  currentValueZInput.setValue(render.z);
  currentValueRXInput.setValue(render.rx);
  currentValueRYInput.setValue(render.ry);
  currentValueRZInput.setValue(render.rz);

  render.drawScene(layer);
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