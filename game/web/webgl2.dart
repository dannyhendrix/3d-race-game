import "dart:html";
import "dart:math" as Math;
import "package:micromachines/webgl.dart";
import "dart:web_gl";

GlRenderLayer layer;
List<GlModelInstance> modelInstances = [];
GlCamera camera;

void main(){
  layer = new GlRenderLayer.withSize(400,500);
  document.body.append(layer.canvas);

  // Tell WebGL how to convert from clip space to pixels
  layer.ctx.viewport(0, 0, layer.canvas.width, layer.canvas.height);

  //create all buffer
  GlModelBuffer cube = new GlCube.fromTopCenter(0.0,0.0,0.0,150.0,200.0,150.0).createBuffers(layer);
  modelInstances.add(new GlModelInstance(cube));
  var m2 = new GlModelInstance(cube,-320.0,-100.0,-100.0);
  m2.ry = 1.0;
  modelInstances.add(m2);

  //3 set view perspective
  camera = new GlCamera(400.0 / 500.0);

  document.body.append(createSlider("tx",0.0,500.0,1.0,camera.x,(String val){ camera.x = double.parse(val); draw(); }));
  document.body.append(createSlider("ty",0.0,500.0,1.0,camera.y,(String val){ camera.y = double.parse(val); draw(); }));
  document.body.append(createSlider("tz",0.0,500.0,1.0,camera.z,(String val){ camera.z = double.parse(val); draw(); }));
  document.body.append(createSlider("rx",0.0,2*Math.PI,0.1,camera.rx,(String val){ camera.rx = double.parse(val); draw(); }));
  document.body.append(createSlider("ry",0.0,2*Math.PI,0.1,camera.ry,(String val){ camera.ry = double.parse(val); draw(); }));
  document.body.append(createSlider("rz",0.0,2*Math.PI,0.1,camera.rz,(String val){ camera.rz = double.parse(val); draw(); }));
  document.body.append(createSlider("fieldOfViewRadians",0.0,Math.PI,0.1,camera.fieldOfViewRadians,(String val){ camera.fieldOfViewRadians = double.parse(val); draw(); }));
  document.body.append(new HRElement());
  document.body.append(createSlider("cameraAngleRadians",0.0,2*Math.PI,0.1,camera.cameraAngleRadians,(String val){ camera.cameraAngleRadians = double.parse(val); draw(); }));
  document.body.append(createSlider("cameraRadiusRadians",0.0,500.0,0.1,camera.cameraRadiusRadians,(String val){ camera.cameraRadiusRadians = double.parse(val); draw(); }));

  draw();
}

void draw(){
  layer.clearForNextFrame();

  var viewProjectionMatrix = camera.createMatrix();//perspective*viewMatrix;


  //2 call draw method with buffer
  for(GlModelInstance m in modelInstances){
    GlMatrix objPerspective = viewProjectionMatrix.translate(m.x,m.y,m.z);
    objPerspective = objPerspective.rotateX(m.rx);
    objPerspective = objPerspective.rotateY(m.ry);
    objPerspective = objPerspective.rotateZ(m.rz);
    layer.setPerspective(objPerspective);
    layer.drawModel(m);
  }
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
  return el;
}