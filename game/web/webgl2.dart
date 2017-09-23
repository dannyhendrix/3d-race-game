import "dart:html";
import "dart:math" as Math;
import "package:micromachines/webgl.dart";
import "dart:web_gl";

GlRenderLayer layer;
List<GlModelInstance> modelInstances = [];
GlCameraDistanseToTarget camera;

double rx = 0.0, ry = 0.0, rz=0.0;
double ox = 0.0, oy = 0.0, oz=10.0;
double lx = 0.5,ly = 0.5,lz = 0.5;
//double aspect = 1.0;
double lightImpact = 0.5;

void main(){
  layer = new GlRenderLayer.withSize(400,500);
  document.body.append(layer.canvas);

  // Tell WebGL how to convert from clip space to pixels
  layer.ctx.viewport(0, 0, layer.canvas.width, layer.canvas.height);
  layer.setClearColor(new GlColor(0.4,0.4,0.4));

  //create all buffer
  GlModelBuffer cube = new GlCube.fromTopCenter(0.0,0.0,0.0,150.0,200.0,10.0).createBuffers(layer);
  //modelInstances.add(new GlModelInstance(cube, new GlColor()));
  var m2 = new GlModelInstance(cube,new GlColor(),-320.0,-100.0,-100.0);
  m2.ry = 1.0;
  //modelInstances.add(m2);

  GlModelBuffer xaxis = new GlModel([
    new GlTriangle([
      new GlPoint(0.0,0.0,0.0),
      new GlPoint(2.0,0.0,0.0),
      new GlPoint(0.0,1.0,0.0),
    ],1.0,0.0,0.0),
    new GlTriangle([
      new GlPoint(0.0,0.0,0.0),
      new GlPoint(0.0,1.0,0.0),
      new GlPoint(2.0,0.0,0.0),
    ],-1.0,0.0,0.0),
  ]).createBuffers(layer);

  GlModelBuffer yaxis = new GlModel([
    new GlTriangle([
      new GlPoint(0.0,0.0,0.0),
      new GlPoint(0.0,0.0,-2.0),
      new GlPoint(1.0,0.0,0.0),
    ],0.0,0.0,1.0),
    new GlTriangle([
      new GlPoint(0.0,0.0,0.0),
      new GlPoint(1.0,0.0,0.0),
      new GlPoint(0.0,0.0,-2.0),
    ],0.0,0.0,-1.0),
  ]).createBuffers(layer);

  GlModelBuffer zaxis = new GlModel([
    new GlTriangle([
      new GlPoint(0.0,0.0,0.0),
      new GlPoint(0.0,2.0,0.0),
      new GlPoint(0.0,0.0,-1.0),
    ],0.0,1.0,0.0),
    new GlTriangle([
      new GlPoint(0.0,0.0,0.0),
      new GlPoint(0.0,0.0,-1.0),
      new GlPoint(0.0,2.0,0.0),
    ],0.0,-1.0,0.0),
  ]).createBuffers(layer);
  modelInstances.add(new GlModelInstance(xaxis, new GlColor(1.0,0.0,0.0)));
  modelInstances.add(new GlModelInstance(yaxis, new GlColor(0.0,0.0,1.0)));
  modelInstances.add(new GlModelInstance(zaxis, new GlColor(0.0,1.0,0.0)));

  //3 set view perspective
  camera = new GlCameraDistanseToTarget();
  camera.setPerspective(aspect : 400.0 / 500.0);

  document.body.append(createTitle("Light"));
  document.body.append(createSlider("Light % impact",0.0,1.0,0.1,lightImpact,(String val){ lightImpact = double.parse(val); draw(); }));
  document.body.append(createSlider("Light % comming from x",0.0,1.0,0.1,lx,(String val){ lx = double.parse(val); draw(); }));
  document.body.append(createSlider("Light % comming from y",0.0,1.0,0.1,ly,(String val){ ly = double.parse(val); draw(); }));
  document.body.append(createSlider("Light % comming from z",0.0,1.0,0.1,lz,(String val){ lz = double.parse(val); draw(); }));
  document.body.append(createTitle("Camera position"));
  document.body.append(createSlider("offsetx",0.0,300.0,1.0,ox,(String val){ ox = double.parse(val); draw(); }));
  document.body.append(createSlider("offsety",0.0,300.0,1.0,oy,(String val){ oy = double.parse(val); draw(); }));
  document.body.append(createSlider("offsetz",0.0,300.0,1.0,oz,(String val){ oz = double.parse(val); draw(); }));
  document.body.append(createSlider("rotatex",0.0,2*Math.PI,0.1,rx,(String val){ rx = double.parse(val); draw(); }));
  document.body.append(createSlider("rotatey",0.0,2*Math.PI,0.1,ry,(String val){ ry = double.parse(val); draw(); }));
  document.body.append(createSlider("rotatez",0.0,2*Math.PI,0.1,rz,(String val){ rz = double.parse(val); draw(); }));
  //document.body.append(createSlider("fieldOfViewRadians",0.0,Math.PI,0.1,camera.fieldOfViewRadians,(String val){ camera.fieldOfViewRadians = double.parse(val); draw(); }));

  draw();
}

void draw(){
  layer.clearForNextFrame();
  camera.setCameraAngleAndOffset(new GlVector(0.0,0.0,0.0),rx:rx,ry:ry,rz:rz,offsetX:ox,offsetY:oy,offsetZ:oz);
  var viewProjectionMatrix = camera.cameraMatrix;//createMatrix();
  var worldMatrix = GlMatrix.rotationYMatrix(0.0);

  //2 call draw method with buffer
  for(GlModelInstance m in modelInstances){

    GlMatrix objPerspective = worldMatrix.translate(m.x,m.y,m.z);
    objPerspective = objPerspective.rotateX(m.rx);
    objPerspective = objPerspective.rotateY(m.ry);
    objPerspective = objPerspective.rotateZ(m.rz);

    layer.setWorld(worldMatrix,viewProjectionMatrix*objPerspective, new GlVector(lx,ly,lz),lightImpact);
    layer.drawModel(m);
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
  return el;
}