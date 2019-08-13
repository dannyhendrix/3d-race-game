import "dart:html";
import "dart:math" as Math;
import "package:webgl/webgl.dart";
import "package:micromachines/webgl_game.dart";

void applyView(GlPreview preview, double rx, double ry, double rz){
  preview.rx = rx;
  preview.ry = ry;
  preview.rz = rz;
  preview.draw();
}

void main(){
  GlPreview preview;
  preview = new GlPreview(800.0,500.0,(GlModelCollection modelCollection){
    var model = new GlModel_Pickup();
    model.loadModel(modelCollection);
    var instance = model
        .getModelInstance(modelCollection, new GlColor(0.0, 0.0, 1.0), new GlColor(1.0, 0.0, 0.0), new GlColor(0.0, 0.0, 0.3));
    var xyzMark = createXYZMark(preview.layer);
    return [xyzMark, instance];

  });
  preview.background = new GlColor(.8,.8,.8);
  preview.ox = 0.0;
  preview.oy = 16.0;
  preview.oz = 240.0;
  preview.rx = 1.0;
  preview.ry = 2.6;
  preview.rz = 5.8;
  preview.lx = 0.3;
  preview.ly = 0.7;
  preview.lz = 0.1;
  preview.create();
  preview.draw();

  document.body.append(preview.layer.canvas);
  document.body.append(createTitle("Camera position"));
  document.body.append(createSlider("offsetx",0.0,300.0,1.0,preview.ox,(String val){ preview.ox = double.parse(val); preview.draw(); }));
  document.body.append(createSlider("offsety",0.0,300.0,1.0,preview.oy,(String val){ preview.oy = double.parse(val); preview.draw(); }));
  document.body.append(createSlider("offsetz",0.0,900.0,1.0,preview.oz,(String val){ preview.oz = double.parse(val); preview.draw(); }));
  document.body.append(createSlider("rotatex",0.0,2*Math.pi,0.1,preview.rx,(String val){ preview.rx = double.parse(val); preview.draw(); }));
  document.body.append(createSlider("rotatey",0.0,2*Math.pi,0.1,preview.ry,(String val){ preview.ry = double.parse(val); preview.draw(); }));
  document.body.append(createSlider("rotatez",0.0,2*Math.pi,0.1,preview.rz,(String val){ preview.rz = double.parse(val); preview.draw(); }));
  document.body.append(createSlider("lightx",-1.0,1.0,0.1,preview.lx,(String val){ preview.lx = double.parse(val); preview.draw(); }));
  document.body.append(createSlider("lighty",-1.0,1.0,0.1,preview.ly,(String val){ preview.ly = double.parse(val); preview.draw(); }));
  document.body.append(createSlider("lightz",-1.0,1.0,0.1,preview.lz,(String val){ preview.lz = double.parse(val); preview.draw(); }));
  document.body.append(createSlider("light",0.0,1.0,0.05,preview.lightImpact,(String val){ preview.lightImpact = double.parse(val); preview.draw(); }));

  document.body.append(createButton("Right side",(){ applyView(preview, 0.0,0.0,0.0); }));
  document.body.append(createButton("Left side",(){ applyView(preview, 0.0,Math.pi,0.0); }));
  document.body.append(createButton("Front side",(){ applyView(preview, 0.0,Math.pi*0.5,0.0); }));
  document.body.append(createButton("Rear side",(){ applyView(preview, 0.0,Math.pi*1.5,0.0); }));
  document.body.append(createButton("Top",(){ applyView(preview, Math.pi*1.5,0.0,0.0); }));
  document.body.append(createButton("Bottom",(){ applyView(preview, Math.pi*0.5,0.0,0.0); }));
  document.body.append(createButton("Reset",(){ applyView(preview, 1.0,2.6,5.8); }));
}


GlModelInstanceCollection createXYZMark(GlRenderLayer layer){
  GlModelBuffer xaxis = new GlAreaModel([
    new GlTriangle([
      new GlPoint(0.0,0.0,0.0),
      new GlPoint(2.0,0.0,0.0),
      new GlPoint(0.0,1.0,0.0),
    ]),
    new GlTriangle([
      new GlPoint(0.0,0.0,0.0),
      new GlPoint(0.0,1.0,0.0),
      new GlPoint(2.0,0.0,0.0),
    ]),
  ]).createBuffers(layer);

  GlModelBuffer yaxis = new GlAreaModel([
    new GlTriangle([
      new GlPoint(0.0,0.0,0.0),
      new GlPoint(0.0,0.0,-2.0),
      new GlPoint(1.0,0.0,0.0),
    ]),
    new GlTriangle([
      new GlPoint(0.0,0.0,0.0),
      new GlPoint(1.0,0.0,0.0),
      new GlPoint(0.0,0.0,-2.0),
    ]),
  ]).createBuffers(layer);

  GlModelBuffer zaxis = new GlAreaModel([
    new GlTriangle([
      new GlPoint(0.0,0.0,0.0),
      new GlPoint(0.0,2.0,0.0),
      new GlPoint(0.0,0.0,-1.0),
    ]),
    new GlTriangle([
      new GlPoint(0.0,0.0,0.0),
      new GlPoint(0.0,0.0,-1.0),
      new GlPoint(0.0,2.0,0.0),
    ]),
  ]).createBuffers(layer);
  return new GlModelInstanceCollection([
    new GlModelInstance(xaxis, new GlColor(1.0,0.0,0.0)),
    new GlModelInstance(yaxis, new GlColor(0.0,0.0,1.0)),
    new GlModelInstance(zaxis, new GlColor(0.0,1.0,0.0))
  ]);
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