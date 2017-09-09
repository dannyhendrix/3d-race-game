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

  print("Hi");

  var currentValueXInput = new InputWithDoubleValue(0.0, "X");
  var currentValueYInput = new InputWithDoubleValue(0.0, "Y");
  var currentRotationInput = new InputWithDoubleValue(0.0, "Rotation");
  var currentSpeedInput = new InputWithDoubleValue(0.0, "Current speed");
  var currentStandStillInput = new InputWithDoubleValue(0.0, "Stand still delay");

  var maxSpeedInput = new InputWithDoubleValue(6.0, "Max speed forward");
  var accelerationSpeedInput = new InputWithDoubleValue(0.4, "Max acceleration forward");
  var maxSpeedReverseInput = new InputWithDoubleValue(2.0, "Max speed backward");
  var accelerationSpeedReverseInput = new InputWithDoubleValue(0.2, "Max acceleration reverse backward");
  var brakeForceInput = new InputWithDoubleValue(0.2, "Braking force");
  var standStillDelayInput = new InputWithDoubleValue(6.0, "Stand still delay");
  var frictionInput = new InputWithDoubleValue(0.05, "Vehicle friction");


  var steerAccInput = new InputWithDoubleValue(0.05, "Steer acc");

  var isAcceleratingInput = new InputWithBoolValue(false, "Accelerate");
  var isBrakeInput = new InputWithBoolValue(false, "Brake/Reverse");
  var isSteerLeftInput = new InputWithBoolValue(false, "Steer left");
  var isSteerRightInput = new InputWithBoolValue(false, "Steer right");

  document.body.append(new HRElement());
  for(var input in [currentValueXInput,currentValueYInput,currentSpeedInput,currentRotationInput,currentStandStillInput]) document.body.append(input.element);
  document.body.append(new HRElement());
  for(var input in [maxSpeedInput,accelerationSpeedInput,maxSpeedReverseInput,accelerationSpeedReverseInput,brakeForceInput,standStillDelayInput,frictionInput]) document.body.append(input.element);
  document.body.append(new HRElement());
  for(var input in [steerAccInput]) document.body.append(input.element);
  document.body.append(new HRElement());
  for(var input in [isAcceleratingInput,isBrakeInput,isSteerLeftInput,isSteerRightInput]) document.body.append(input.element);


  var visualObject = new DivElement();
  visualObject.setAttribute("style","position:absolute; left:0px; top:0px; height:30px; width:20px; background:blue; border-top:2px solid red;");
  document.body.append(visualObject);

  currentStandStillInput.setValue(standStillDelayInput.getValue());

  Point p = new Point(300.0,300.0);

  GameLoop loop = new GameLoop((int frame){
    //Read values from html dom
    bool acc = isAcceleratingInput.getValue();
    bool brake = isBrakeInput.getValue();
    bool left = isSteerLeftInput.getValue();
    bool right = isSteerRightInput.getValue();

    double V = currentSpeedInput.getValue();
    double A = accelerationSpeedInput.getValue();
    double MA = maxSpeedInput.getValue();
    double B = brakeForceInput.getValue();
    double R = accelerationSpeedReverseInput.getValue();
    double MR = maxSpeedReverseInput.getValue();
    double F = frictionInput.getValue();
    double r = currentRotationInput.getValue();
    double S = steerAccInput.getValue();

    int standStillDelay = currentStandStillInput.getValue().toInt();

    //Steering
    r = applySteering(r,S, left, right);

    //Apply Forces
    bool wasStandingStill = V == 0;
    V = applyAccelerationAndBrake( V, A, R, B, MA, MR, standStillDelay==0, acc, brake);
    V = applyFriction(V,F);
    standStillDelay = updateStandStillDelay(standStillDelay,standStillDelayInput.getValue().toInt(), wasStandingStill, V==0);

    Vector v = new Vector.fromAngleRadians(r,V);
    p += v;

    //Write values back to htmlDom
    currentValueXInput.setValue(v.x);
    currentValueYInput.setValue(v.y);
    currentRotationInput.setValue(r);
    currentSpeedInput.setValue(V);
    currentStandStillInput.setValue(standStillDelay.toDouble());

    visualObject.style.top = "${p.y}px";
    visualObject.style.left = "${p.x}px";
    visualObject.style.transform = "rotate(${r}rad)";
  });

  document.body.append(createButton("Start/pause animation",(Event e){loop.pause();}));
  document.body.append(createButton("Reset position",(Event e){p=new Point(300.0,300.0);}));


  var handleKey = (KeyboardEvent e)
  {
    int key = e.keyCode;
    bool down = e.type == "keydown";//event.KEYDOWN
    Control control;
    if(key == 38)//up
      isAcceleratingInput.setValue(down);
    else if(key == 40)//down
      isBrakeInput.setValue(down);
    else if(key == 37)//left
      isSteerLeftInput.setValue(down);
    else if(key == 39)//right
      isSteerRightInput.setValue(down);
    else return;

    e.preventDefault();
  };

  document.onKeyDown.listen(handleKey);
  document.onKeyUp.listen(handleKey);
}


/*Forces
 */
double applyFriction(double V, double F){
  if(V > 0) V -= Math.min(V,F);
  else if(V < 0) V += Math.min(-V,F);
  return V;
}
double applyAccelerationAndBrake(double V, double A, double R, double B, double MaxA, double MaxR, bool canStartFromZero, bool acc, bool brake){
  if(acc && brake){
    if(V>0) V -= B;
    else if(V<0) V += B;
  }else{
    if(V==0){
      if(canStartFromZero)
      {
        if (acc) V += A;
        if (brake) V -= R;
      }
    }
    else if(V>0){
      if(acc) V += A;
      if(brake) V -= Math.min(V,B);
    }
    else if(V<0){
      if(acc) V +=  Math.min(-V,B);
      if(brake) V -= R;
    }
  }
  if(V > MaxA) V = MaxA;
  if(V < -MaxR) V = -MaxR;
  return V;
}
int updateStandStillDelay(int currentStandStillDelay, int standStillDelay, bool wasStandingStill, bool standingStill){
  if(!standingStill || !wasStandingStill) return standStillDelay;

  currentStandStillDelay -= 1;
  if(currentStandStillDelay < 0)
    currentStandStillDelay = 0;

  return currentStandStillDelay;
}
double applySteering(double r, double S, bool left, bool right){
  if(left && !right)
    r -= S;
  else if(!left && right)
    r += S;
  return r;
}

class InputWithValue<T>{
  T _value;
  Element element;
  T getValue() => _value;
  void setValue(T v){
    _value = v;
  }
}

Element createButton(String labelText, Function onClick){
  var btn = new ButtonElement();
  btn.text = labelText;
  btn.onClick.listen(onClick);
  return btn;
}

class InputWithDoubleValue extends InputWithValue<double>{
  InputElement _inputElement;

  void setValue(double v){
    _value = v;
    _inputElement.value = _value.toString();
  }

  InputWithDoubleValue(double value, String labelText){
    _value = value;
    element = new DivElement();
    _inputElement = new InputElement();
    _inputElement.onChange.listen((Event e){
      _value = double.parse(_inputElement.value);
    });
    _inputElement.value = _value.toString();
    var label = new SpanElement();
    label.text = labelText;
    label.style.width = "300px";
    label.style.display = "inline-block";
    element.append(label);
    element.append(_inputElement);
  }
}
class InputWithBoolValue extends InputWithValue<bool>{
  CheckboxInputElement _inputElement;

  void setValue(bool v){
    _value = v;
    _inputElement.checked = _value;
  }

  InputWithBoolValue(bool value, String labelText){
    _value = value;
    element = new DivElement();
    _inputElement = new CheckboxInputElement();
    _inputElement.onChange.listen((Event e){
      _value = _inputElement.checked;
    });
    _inputElement.checked = _value;
    var label = new SpanElement();
    label.text = labelText;
    label.style.width = "300px";
    label.style.display = "inline-block";
    element.append(label);
    element.append(_inputElement);
  }
}