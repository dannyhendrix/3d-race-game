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

  var currentValueInput = new InputWithDoubleValue(0.0, "Current position");
  var currentSpeedInput = new InputWithDoubleValue(0.0, "Current speed");
  var currentStandStillInput = new InputWithDoubleValue(0.0, "Stand still delay");

  var maxSpeedInput = new InputWithDoubleValue(2.0, "Max speed forward");
  var accelerationSpeedInput = new InputWithDoubleValue(0.2, "Max acceleration forward");
  var maxSpeedReverseInput = new InputWithDoubleValue(2.0, "Max speed backward");
  var accelerationSpeedReverseInput = new InputWithDoubleValue(0.2, "Max acceleration reverse backward");
  var brakeForceInput = new InputWithDoubleValue(0.2, "Braking force");
  var standStillDelayInput = new InputWithDoubleValue(20.0, "Stand still delay");
  var frictionInput = new InputWithDoubleValue(0.05, "Vehicle friction");

  var isAcceleratingInput = new InputWithBoolValue(false, "Accelerate");
  var isBrakeInput = new InputWithBoolValue(false, "Brake/Reverse");

  document.body.append(new HRElement());
  for(var input in [currentValueInput,currentSpeedInput,currentStandStillInput]) document.body.append(input.element);
  document.body.append(new HRElement());
  for(var input in [maxSpeedInput,accelerationSpeedInput,maxSpeedReverseInput,accelerationSpeedReverseInput,brakeForceInput,standStillDelayInput,frictionInput]) document.body.append(input.element);
  document.body.append(new HRElement());
  for(var input in [isAcceleratingInput,isBrakeInput]) document.body.append(input.element);


  var visualObject = new DivElement();
  visualObject.setAttribute("style","position:absolute; left:0px; top:0px; height:10px; width:10px; background:blue;");
  document.body.append(visualObject);

  currentStandStillInput.setValue(standStillDelayInput.getValue());

  GameLoop loop = new GameLoop((int frame){
    bool acc = isAcceleratingInput.getValue();
    bool brake = isBrakeInput.getValue();

    double V = currentSpeedInput.getValue();
    double A = accelerationSpeedInput.getValue();
    double MA = maxSpeedInput.getValue();
    double B = brakeForceInput.getValue();
    double R = accelerationSpeedReverseInput.getValue();
    double MR = maxSpeedReverseInput.getValue();
    double F = frictionInput.getValue();

    int inZero = currentStandStillInput.getValue().toInt();
    bool wasInZero = V == 0;

    if(acc && brake){
      if(V>0) V -= B;
      else if(V<0) V += B;
    }else{
      if(inZero == 0)
      {
        if(V==0){
          if(acc) V += A;
          if(brake) V -= R;
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
    }

    if(V > MA) V = MA;
    if(V < -MR) V = -MR;
    if(V > 0) V -= Math.min(V,F);
    else if(V < 0) V += Math.min(-V,F);

    if(V == 0){
      if(wasInZero){
        inZero -= 1;
        if(inZero < 0) inZero = 0;
      }
      else inZero = standStillDelayInput.getValue().toInt();
    }

    currentStandStillInput.setValue(inZero.toDouble());

    currentSpeedInput.setValue(V);
    currentValueInput.setValue(currentValueInput.getValue() + V);

    visualObject.style.top = "${currentValueInput.getValue()}px";
  });

  document.body.append(createButton("Start/pause animation",(Event e){loop.pause();}));
  document.body.append(createButton("Reset position",(Event e){currentValueInput.setValue(0.0);}));


  var handleKey = (KeyboardEvent e)
  {
    int key = e.keyCode;
    bool down = e.type == "keydown";//event.KEYDOWN
    Control control;
    if(key == 38)//up
      isBrakeInput.setValue(down);
    else if(key == 40)//down
      isAcceleratingInput.setValue(down);
    else return;

    e.preventDefault();
  };

  document.onKeyDown.listen(handleKey);
  document.onKeyUp.listen(handleKey);
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