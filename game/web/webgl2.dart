import "dart:html";
import "dart:math" as Math;
import "package:micromachines/webgl.dart";
import "dart:web_gl";

GlRenderLayer layer;
List<GlModelBuffer> models = [];
GlMatrix perspective;
GlMatrix cameraMatrix;
GlMatrix viewMatrix;

double tx=0.0, ty=0.0, tz=360.0;
double rx=0.0, ry=0.0, rz=0.0;
double fieldOfViewRadians=2.0;
double cameraAngleRadians=1.0;
double cameraRadiusRadians=100.0;
double zNear = 1.0;
double zFar = 2000.0;
double aspect = 1.0;

void main(){
  layer = new GlRenderLayer.withSize(400,500);
  document.body.append(layer.canvas);

  // Tell WebGL how to convert from clip space to pixels
  layer.ctx.viewport(0, 0, layer.canvas.width, layer.canvas.height);

  //create all buffer
  models.add(new GlCube(20.0,0.0,0.0,150.0,200.0,150.0).createBuffers(layer));
  models.add(new GlCube(-320.0,-100.0,-100.0,150.0,200.0,150.0).createBuffers(layer));

  //3 set view perspective
  aspect = 400.0 / 500.0;

  document.body.append(createSlider("tx",0.0,500.0,1.0,tx,(String val){ tx = double.parse(val); draw(); }));
  document.body.append(createSlider("ty",0.0,500.0,1.0,ty,(String val){ ty = double.parse(val); draw(); }));
  document.body.append(createSlider("tz",0.0,500.0,1.0,tz,(String val){ tz = double.parse(val); draw(); }));
  document.body.append(createSlider("rx",0.0,2*Math.PI,0.1,rx,(String val){ rx = double.parse(val); draw(); }));
  document.body.append(createSlider("ry",0.0,2*Math.PI,0.1,ry,(String val){ ry = double.parse(val); draw(); }));
  document.body.append(createSlider("rz",0.0,2*Math.PI,0.1,rz,(String val){ rz = double.parse(val); draw(); }));
  document.body.append(createSlider("fieldOfViewRadians",0.0,Math.PI,0.1,fieldOfViewRadians,(String val){ fieldOfViewRadians = double.parse(val); draw(); }));
  document.body.append(new HRElement());
  document.body.append(createSlider("cameraAngleRadians",0.0,2*Math.PI,0.1,cameraAngleRadians,(String val){ cameraAngleRadians = double.parse(val); draw(); }));
  document.body.append(createSlider("cameraRadiusRadians",0.0,500.0,0.1,cameraRadiusRadians,(String val){ cameraRadiusRadians = double.parse(val); draw(); }));

  draw();
}

void draw(){
  layer.clearForNextFrame();

  //1 set perspective
  perspective = GlMatrix.perspectiveMatrix(fieldOfViewRadians, aspect, zNear, zFar);
  perspective = perspective.translate(tx, ty, -tz);
  perspective = perspective.rotateX(rx);
  perspective = perspective.rotateY(ry);
  perspective = perspective.rotateZ(rz);

  //4 create camera
  cameraMatrix = GlMatrix.rotationYMatrix(cameraAngleRadians);
  cameraMatrix = cameraMatrix.translate(0.0, 0.0, cameraRadiusRadians * 1.5);

  var targetPosition = new GlVector(0.0,0.0,0.0);
  var cameraPosition = new GlVector(cameraMatrix.val(3,0),cameraMatrix.val(3,1), cameraMatrix.val(3,2));
  var up = new GlVector(0.0, 1.0, 0.0);
  cameraMatrix = GlMatrix.lookAtMatrix(cameraPosition, targetPosition, up);

  viewMatrix = cameraMatrix.inverse();
  var viewProjectionMatrix = perspective*viewMatrix;
  layer.setPerspective(viewProjectionMatrix);

  //2 call draw method with buffer
  for(GlModelBuffer m in models) layer.drawModel(m);
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