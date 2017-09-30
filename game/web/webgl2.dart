import "dart:html";
import "dart:math" as Math;
import "package:micromachines/webgl.dart";
import "dart:web_gl";

GlRenderLayer layer;
List<GlModelInstance> modelInstances = [];
GlCameraDistanseToTarget camera;

double rx = 0.0, ry = 0.0, rz=0.0;
double ox = 0.0, oy = 0.0, oz=10.0;
double lx = 0.5, ly = 0.5, lz = 0.5;
double lightImpact = 0.5;

void main(){
  layer = new GlRenderLayer.withSize(400,500, true);
  document.body.append(layer.canvas);

  // Tell WebGL how to convert from clip space to pixels
  layer.ctx.viewport(0, 0, layer.canvas.width, layer.canvas.height);
  layer.setClearColor(new GlColor(0.4,0.4,0.4));

  //3 set view perspective
  camera = new GlCameraDistanseToTarget();
  camera.setPerspective(aspect : 400.0 / 500.0);

  //4 create models
  createXYZMark().modelInstances.forEach((GlModelInstance model) => modelInstances.add(model));
  createVehicleModel(5.0,5.0,15.0).modelInstances.forEach((GlModelInstance model) => modelInstances.add(model));

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

  draw();
}

class DoubleHelper{
  double v;
  double h;
  DoubleHelper(double v, double s) : v = v*s, h = v*s/2;
}

GlModelInstanceCollection createVehicleModel(double sx, double sy, double sz){
  DoubleHelper h = new DoubleHelper(1.0,sy);
  DoubleHelper hCarBottom = new DoubleHelper(0.5,sy);
  DoubleHelper hWindow = new DoubleHelper(0.5,sy);

  DoubleHelper d = new DoubleHelper(1.0,sx);
  DoubleHelper dRoof = new DoubleHelper(0.8,sx);
  DoubleHelper dWindow = new DoubleHelper(0.1,sx);

  DoubleHelper w = new DoubleHelper(1.0,sz);
  DoubleHelper wHood = new DoubleHelper(0.3,sz);
  DoubleHelper wRoof = new DoubleHelper(0.3,sz);
  DoubleHelper wRear = new DoubleHelper(0.2,sz);
  DoubleHelper wWindowFront = new DoubleHelper(0.1,sz);
  DoubleHelper wWindowRear = new DoubleHelper(0.1,sz);

  GlModelBuffer model = new GlModel([
    //floor
    new GlRectangle.withWD(-w.h,0.0, -d.h, w.v, d.v, true),
    //hood
    new GlRectangle.withWD(w.h-wHood.v,hCarBottom.v, -d.h, wHood.v, d.v, false),
    //rear top
    new GlRectangle.withWD(-w.h,hCarBottom.v, -d.h, wRear.v, d.v, false),
    //roof
    new GlRectangle.withWD(-w.h+wRear.v+wWindowRear.v,h.v, -d.h+dWindow.v, wRoof.v, dRoof.v, false),
    //front
    new GlRectangle.withHD(w.h,0.0, -d.h, hCarBottom.v, d.v, true),
    //rear
    new GlRectangle.withHD(-w.h,0.0, -d.h, hCarBottom.v, d.v, false),
    //right side
    //bottom
    new GlRectangle.withWH(-w.h,0.0, d.h, w.v, hCarBottom.v, true),
    //left side
    //bottom
    new GlRectangle.withWH(-w.h,0.0, -d.h, w.v, hCarBottom.v, false),

  ]).createBuffers(layer);
  GlModelBuffer modelWindows = new GlModel([
    //WindowFront
    new GlTriangle([
      new GlPoint(w.h-wHood.v, hCarBottom.v, d.h),
      new GlPoint(w.h-wHood.v-wWindowFront.v, h.v, -d.h+dWindow.v),
      new GlPoint(w.h-wHood.v-wWindowFront.v, h.v, d.h-dWindow.v),
    ]),
    new GlTriangle([
      new GlPoint(w.h-wHood.v,hCarBottom.v,d.h),
      new GlPoint(w.h-wHood.v,hCarBottom.v,-d.h),
      new GlPoint(w.h-wHood.v-wWindowFront.v, h.v, -d.h+dWindow.v),
    ]),
    //WindowRear
    new GlTriangle([
      new GlPoint(-w.h+wRear.v, hCarBottom.v, d.h),
      new GlPoint(-w.h+wRear.v+wWindowRear.v, h.v, d.h-dWindow.v),
      new GlPoint(-w.h+wRear.v+wWindowRear.v, h.v, -d.h+dWindow.v),
    ]),
    new GlTriangle([
      new GlPoint(-w.h+wRear.v,hCarBottom.v,d.h),
      new GlPoint(-w.h+wRear.v+wWindowRear.v, h.v, -d.h+dWindow.v),
      new GlPoint(-w.h+wRear.v,hCarBottom.v,-d.h),
    ]),
    //windowLeft
    new GlTriangle([
      new GlPoint(-w.h+wRear.v,hCarBottom.v,d.h),
      new GlPoint(w.h-wHood.v-wWindowFront.v,h.v,d.h-dWindow.v),
      new GlPoint(-w.h+wRear.v+wWindowRear.v,h.v,d.h-dWindow.v),
    ]),
    new GlTriangle([
      new GlPoint(-w.h+wRear.v,hCarBottom.v,d.h),
      new GlPoint(w.h-wHood.v,hCarBottom.v,d.h),
      new GlPoint(w.h-wHood.v-wWindowFront.v,h.v,d.h-dWindow.v),
    ]),
    //windowRight
    new GlTriangle([
      new GlPoint(-w.h+wRear.v,hCarBottom.v,-d.h),
      new GlPoint(-w.h+wRear.v+wWindowRear.v,h.v,-d.h+dWindow.v),
      new GlPoint(w.h-wHood.v-wWindowFront.v,h.v,-d.h+dWindow.v),
    ]),
    new GlTriangle([
      new GlPoint(-w.h+wRear.v,hCarBottom.v,-d.h),
      new GlPoint(w.h-wHood.v-wWindowFront.v,h.v,-d.h+dWindow.v),
      new GlPoint(w.h-wHood.v,hCarBottom.v,-d.h),
    ]),
  ]).createBuffers(layer);


  var color = new GlColor(1.0,1.0,1.0);
  var colorWindows = new GlColor(0.0,0.0,1.0);
  return new GlModelInstanceCollection([new GlModelInstance(model, color),new GlModelInstance(modelWindows, colorWindows)]);
}

GlModelInstanceCollection createXYZMark(){
  GlModelBuffer xaxis = new GlModel([
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

  GlModelBuffer yaxis = new GlModel([
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

  GlModelBuffer zaxis = new GlModel([
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