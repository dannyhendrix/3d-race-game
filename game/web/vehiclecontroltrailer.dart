import "package:preloader/preloader.dart";
import "package:logging/logging.dart";
import "package:micromachines/game.dart";
import "package:renderlayer/renderlayer.dart";
import "package:gameutils/gameloop.dart";
import "package:gameutils/math.dart";
import "dart:html";
import "dart:math" as Math;
import "dart:convert";

void main()
{
  //logger
  Logger.root.level = Level.OFF;

  print("Hi");

  VehicleSettings vehicleSettings = new VehicleSettings();

  var txtArea = new TextAreaElement();
  txtArea.value = jsonEncode(vehicleSettings.data);
  document.body.append(txtArea);
  txtArea.onChange.listen((Event e){
    vehicleSettings.data = jsonDecode(txtArea.value);
  });


  var currentValueXInput = new InputWithDoubleValue(0.0, "X");
  var currentValueYInput = new InputWithDoubleValue(0.0, "Y");
  var currentRotationInput = new InputWithDoubleValue(0.0, "Rotation");
  var currentSpeedInput = new InputWithDoubleValue(0.0, "Current speed");
  var currentStandStillInput = new InputWithDoubleValue(0.0, "Stand still delay");

  var isAcceleratingInput = new InputWithBoolValue(false, "Accelerate");
  var isBrakeInput = new InputWithBoolValue(false, "Brake/Reverse");
  var isSteerLeftInput = new InputWithBoolValue(false, "Steer left");
  var isSteerRightInput = new InputWithBoolValue(false, "Steer right");

  document.body.append(new HRElement());
  for(var input in [currentValueXInput,currentValueYInput,currentSpeedInput,currentRotationInput,currentStandStillInput]) document.body.append(input.element);

  document.body.append(new HRElement());
  for(var input in [isAcceleratingInput,isBrakeInput,isSteerLeftInput,isSteerRightInput]) document.body.append(input.element);


  var visualObject = new DivElement();
  visualObject.setAttribute("style","position:absolute; left:0px; top:0px; height:20px; width:30px; background:blue; border-right:2px solid red;");
  document.body.append(visualObject);

  var visualObjectTrailer = new DivElement();
  visualObjectTrailer.setAttribute("style","position:absolute; left:0px; top:0px; height:20px; width:30px; background:green; border-right:2px solid red;");
  document.body.append(visualObjectTrailer);

  var elMarker = new DivElement();
  elMarker.setAttribute("style","position:absolute; left:0px; top:0px; height:2px; width:2px; background:red;");
  document.body.append(elMarker);

  currentStandStillInput.setValue(vehicleSettings.getValue(VehicleSettingKeys.standstill_delay));

  double rTrailer = 0.0;

  Point2d vehicleSize = new Point2d(30.0,20.0);
  Point2d trailerSize = new Point2d(30.0,20.0);
  Point2d vehicleSnapPoint = new Point2d(-15.0,0.0);
  Point2d trailerSnapPoint = new Point2d(15.0+13.0,0.0);
  Point2d trailerWheelPoint = new Point2d(-10.0,0.0);


  Point2d p = new Point2d(300.0,300.0);
  Point2d pTrailer = p-vehicleSnapPoint-trailerSnapPoint;

  GameLoop loop = new GameLoop((int frame){
    //Read values from html dom
    //controls
    bool acc = isAcceleratingInput.getValue();
    bool brake = isBrakeInput.getValue();
    bool left = isSteerLeftInput.getValue();
    bool right = isSteerRightInput.getValue();

    //state
    double _speed = currentSpeedInput.getValue();
    double r = currentRotationInput.getValue();
    int currentStandStillDelay = currentStandStillInput.getValue().toInt();

    //Steering
    r = _applySteering(r,vehicleSettings.getValue(VehicleSettingKeys.steering_speed), left, right);

    //Apply Forces
    bool wasStandingStill = _speed == 0;
    _speed = _applyAccelerationAndBrake(_speed,
        vehicleSettings.getValue(VehicleSettingKeys.acceleration),
        vehicleSettings.getValue(VehicleSettingKeys.reverse_acceleration),
        vehicleSettings.getValue(VehicleSettingKeys.brake_speed),
        vehicleSettings.getValue(VehicleSettingKeys.acceleration_max),
        vehicleSettings.getValue(VehicleSettingKeys.reverse_acceleration_max),
        currentStandStillDelay==0, acc, brake);
    _speed = _applyFriction(_speed,vehicleSettings.getValue(VehicleSettingKeys.friction));
    currentStandStillDelay = _updateStandStillDelay(currentStandStillDelay,vehicleSettings.getValue(VehicleSettingKeys.standstill_delay), wasStandingStill, _speed==0);

    Vector vector = new Vector.fromAngleRadians(r,_speed);
    p += vector;

    //Trailer
    //pTrailer = p+vehicleSnapPoint-trailerSnapPoint;

    Matrix2d Mv = new Matrix2d.translationPoint(p);
    Mv = Mv.rotate(r);
    Matrix2d Mt = new Matrix2d.translationPoint(pTrailer);
    Mt = Mt.rotate(rTrailer);
    var A = Mv.apply(vehicleSnapPoint);
    var B = Mt.apply(trailerWheelPoint);
    //var force = (new Matrix2d.rotation(rTrailer)).apply(new Point2d(15.0,0.0));
    rTrailer = B.angleWith(A);

    Matrix2d M = new Matrix2d.translationPoint(A);
    M = M.rotate(rTrailer);
    pTrailer = M.apply(-trailerSnapPoint);

    elMarker.style.top = "${A.y-1}px";
    elMarker.style.left = "${A.x-1}px";

    //Write values back to htmlDom
    currentValueXInput.setValue(p.x);
    currentValueYInput.setValue(p.y);
    currentRotationInput.setValue(r);
    currentSpeedInput.setValue(_speed);
    currentStandStillInput.setValue(currentStandStillDelay.toDouble());

    //visual update
    visualObject.style.top = "${p.y-(vehicleSize.y/2)}px";
    visualObject.style.left = "${p.x-(vehicleSize.x/2)}px";
    visualObject.style.transform = "rotate(${r}rad)";
    visualObjectTrailer.style.top = "${pTrailer.y-(trailerSize.y/2)}px";
    visualObjectTrailer.style.left = "${pTrailer.x-(trailerSize.x/2)}px";
    visualObjectTrailer.style.transform = "rotate(${rTrailer}rad)";
  });

  document.body.append(createButton("Start/pause animation",(Event e){loop.pause();}));
  document.body.append(createButton("Reset position",(Event e){p=new Point2d(300.0,300.0);}));


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
double _applyFriction(double V, double F){
  if(V > 0) V -= Math.min(V,F);
  else if(V < 0) V += Math.min(-V,F);
  return V;
}
double _applyAccelerationAndBrake(double V, double A, double R, double B, double MaxA, double MaxR, bool canStartFromZero, bool acc, bool brake){
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
int _updateStandStillDelay(int currentStandStillDelay, int standStillDelay, bool wasStandingStill, bool standingStill){
  if(!standingStill || !wasStandingStill) return standStillDelay;

  currentStandStillDelay -= 1;
  if(currentStandStillDelay < 0)
    currentStandStillDelay = 0;

  return currentStandStillDelay;
}
double _applySteering(double r, double S, bool left, bool right){
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