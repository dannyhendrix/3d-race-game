import "dart:html";
import "dart:math" as Math;
import 'package:gameutils/math.dart';
import "package:micromachines/definitions.dart";
import "package:micromachines/leveleditor.dart";
import "package:renderlayer/renderlayer.dart";

void main(){
  var preview = new StartingPositionsPreview2();
  document.body.append(preview.layer.canvas);
  document.body.append(createTitle("Starting position"));
  document.body.append(createSlider("startAngle",0.0,2*Math.pi,0.1,preview.startAngle,(String val){ preview.startAngle = double.parse(val); preview.refresh();  }));
  document.body.append(createSlider("totalCars",1,10,1,preview.totalCars*1.0,(String val){ preview.totalCars = int.parse(val); preview.refresh();  }));
  document.body.append(createSlider("vehicleW",1.0,60.0,1.0,preview.vehicleW,(String val){ preview.vehicleW = double.parse(val); preview.refresh();  }));
  document.body.append(createSlider("vehicleH",1.0,60.0,1.0,preview.vehicleH,(String val){ preview.vehicleH = double.parse(val); preview.refresh();  }));
  document.body.append(createSlider("spaceBetweenVehicleW",0.0,10.0,1.0,preview.spaceBetweenVehicleW,(String val){ preview.spaceBetweenVehicleW = double.parse(val); preview.refresh();  }));
  document.body.append(createSlider("spaceBetweenVehicleH",0.0,10.0,1.0,preview.spaceBetweenVehicleH,(String val){ preview.spaceBetweenVehicleH = double.parse(val); preview.refresh();  }));
  document.body.append(createSlider("availableH",1.0,180.0,1.0,preview.availableH,(String val){ preview.availableH = double.parse(val); preview.refresh();  }));
  preview.refresh();
}

class StartingPositionsPreview2{
  StartingPositions startingPositions = new StartingPositions();
  StartingPositionsPreview startingPositionsPreview = new StartingPositionsPreview();

  RenderLayer layer;

  double startAngle = 0.0;
  int totalCars = 8;
  double vehicleW = 30.0;
  double vehicleH = 15.0;
  double spaceBetweenVehicleW = 1.0;
  double spaceBetweenVehicleH = 1.0;
  double availableH = 100.0;
  Vector start = new Vector(0.0,0.0);

  StartingPositionsPreview2(){
    layer = new RenderLayer.withSize(200,200);
  }

  void refresh(){
    var positions = startingPositions.DetermineStartPositions2(start, startAngle, totalCars, vehicleW, vehicleH, spaceBetweenVehicleW, spaceBetweenVehicleH, availableH);
    layer.clear();
    paint(positions);
  }

  void paint(List<StartingPosition> positions){
    var centerX = layer.actualwidth ~/2;
    var centerY = layer.actualheight ~/2;
    var radius = availableH~/2;

    // move to canvas center
    layer.ctx.save();
    layer.ctx.translate(centerX, centerY);

    // circle
    layer.ctx.beginPath();
    layer.ctx.arc(0.0, 0.0, radius, 0, Math.pi * 2);
    layer.ctx.strokeStyle = "blue";
    layer.ctx.stroke();
    layer.ctx.closePath();

    // center line
    layer.ctx.save();
    layer.ctx.rotate(startAngle);
    layer.ctx.beginPath();
    layer.ctx.moveTo(-radius, 0);
    layer.ctx.lineTo(radius, 0);
    layer.ctx.closePath();
    layer.ctx.stroke();
    layer.ctx.restore();

    // starting positions
    startingPositionsPreview.paintPositions(layer.ctx, positions, vehicleW, vehicleH);

    // restore canvas from center to 0,0
    layer.ctx.restore();
  }
}


Element createTitle(String label){
  Element el = new HeadingElement.h2();
  el.text = label;
  return el;
}

Element createSlider(String label, double min, double max, double step, double val, Function onChange){
  DivElement el = new DivElement();
  el.appendText(label);
  SpanElement el_val = new SpanElement();
  el_val.text = val.toString();
  InputElement el_in = new InputElement(type:"range");
  el_in.min = min.toString();
  el_in.max = max.toString();
  el_in.value = val.toString();
  el_in.step = step.toString();
  el_in.onMouseMove.listen((Event e){
    onChange(el_in.value);
    el_val.text = el_in.value;
  });
  el.append(el_in);
  el.append(el_val);
  onChange(el_in.value);
  return el;
}
Element createButton(String text, Function onClick){
  var element = new ButtonElement();
  element.text = text;
  element.onClick.listen((Event e){
    onClick();
  });
  return element;
}