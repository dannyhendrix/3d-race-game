import "dart:html";
import "dart:math" as Math;
import "package:micromachines/webgl.dart";
import "dart:web_gl";

GlRenderLayer layer;
List<GlModelInstanceCollection> modelInstances = [];
GlCameraDistanseToTarget camera;

double rx = 0.5, ry = 2.6, rz=0.0;
double ox = 0.0, oy = 0.0, oz=40.0;
double lx = 0.5, ly = 0.5, lz = 0.5;
double lightImpact = 0.5;

double wr = 0.5, wg = 0.5, wb = 0.5;
double c1r = 0.5, c1g = 0.5, c1b = 0.5;
double c2r = 0.5, c2g = 0.5, c2b = 0.5;

void main(){
  double windowW = 500.0;
  double windowH = 400.0;
  layer = new GlRenderLayer.withSize(windowW.toInt(),windowH.toInt(), true);
  document.body.append(layer.canvas);

  // Tell WebGL how to convert from clip space to pixels
  layer.ctx.viewport(0, 0, layer.canvas.width, layer.canvas.height);
  layer.setClearColor(new GlColor(0.4,0.4,0.4));

  //3 set view perspective
  camera = new GlCameraDistanseToTarget();
  camera.setPerspective(aspect : windowW / windowH);

  //4 create models
  modelInstances.add(createXYZMark());
   var car = createVehicleModel(5.0,4.0,3.0);
  modelInstances.add(car);

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

  document.body.append(createTitle("Color window"));
  document.body.append(createSlider("r",0.0,1.0,0.1,wr,(String val){ wr = double.parse(val); car.modelInstances[2].color = new GlColor(wr,wg,wb); draw(); }));
  document.body.append(createSlider("g",0.0,1.0,0.1,wg,(String val){ wg = double.parse(val); car.modelInstances[2].color = new GlColor(wr,wg,wb); draw(); }));
  document.body.append(createSlider("b",0.0,1.0,0.1,wb,(String val){ wb = double.parse(val); car.modelInstances[2].color = new GlColor(wr,wg,wb); draw(); }));

  document.body.append(createTitle("Color1"));
  document.body.append(createSlider("r",0.0,1.0,0.1,c1r,(String val){ c1r = double.parse(val); car.modelInstances[0].color = new GlColor(c1r,c1g,c1b); draw(); }));
  document.body.append(createSlider("g",0.0,1.0,0.1,c1g,(String val){ c1g = double.parse(val); car.modelInstances[0].color = new GlColor(c1r,c1g,c1b); draw(); }));
  document.body.append(createSlider("b",0.0,1.0,0.1,c1b,(String val){ c1b = double.parse(val); car.modelInstances[0].color = new GlColor(c1r,c1g,c1b); draw(); }));
  document.body.append(createTitle("Color2"));
  document.body.append(createSlider("r",0.0,1.0,0.1,c2r,(String val){ c2r = double.parse(val); car.modelInstances[1].color = new GlColor(c2r,c2g,c2b); draw(); }));
  document.body.append(createSlider("g",0.0,1.0,0.1,c2g,(String val){ c2g = double.parse(val); car.modelInstances[1].color = new GlColor(c2r,c2g,c2b); draw(); }));
  document.body.append(createSlider("b",0.0,1.0,0.1,c2b,(String val){ c2b = double.parse(val); car.modelInstances[1].color = new GlColor(c2r,c2g,c2b); draw(); }));

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

  DoubleHelper d = new DoubleHelper(1.0,sz);
  DoubleHelper dRoof = new DoubleHelper(0.8,sz);
  DoubleHelper dWindow = new DoubleHelper(0.1,sz);

  DoubleHelper dStripeLeft = new DoubleHelper(0.3,sz);
  DoubleHelper dStripeMid = new DoubleHelper(0.4,sz);
  DoubleHelper dStripeRight = new DoubleHelper(0.3,sz);

  DoubleHelper dStripeRoofLeft = new DoubleHelper(0.2,sz);
  DoubleHelper dStripeRoofMid = new DoubleHelper(0.4,sz);
  DoubleHelper dStripeRoofRight = new DoubleHelper(0.2,sz);

  DoubleHelper w = new DoubleHelper(1.0,sx);
  DoubleHelper wHood = new DoubleHelper(0.3,sx);
  DoubleHelper wRoof = new DoubleHelper(0.3,sx);
  DoubleHelper wRear = new DoubleHelper(0.2,sx);
  DoubleHelper wWindowFront = new DoubleHelper(0.1,sx);
  DoubleHelper wWindowRear = new DoubleHelper(0.1,sx);

  GlModelBuffer model = new GlAreaModel([
    //floor
    new GlRectangle.withWD(-w.h,0.0, -d.h, w.v, d.v, true),
    //hood
    new GlRectangle.withWD(w.h-wHood.v,hCarBottom.v, d.h-dStripeRight.v, wHood.v, dStripeRight.v, false),
    new GlRectangle.withWD(w.h-wHood.v,hCarBottom.v, -d.h, wHood.v, dStripeLeft.v, false),
    //rear top
    new GlRectangle.withWD(-w.h,hCarBottom.v, d.h-dStripeRight.v, wRear.v, dStripeRight.v, false),
    new GlRectangle.withWD(-w.h,hCarBottom.v, -d.h, wRear.v, dStripeLeft.v, false),
    //roof
    new GlRectangle.withWD(-w.h+wRear.v+wWindowRear.v,h.v, d.h-dWindow.v-dStripeRoofRight.v, wRoof.v, dStripeRoofRight.v, false),
    new GlRectangle.withWD(-w.h+wRear.v+wWindowRear.v,h.v, -d.h+dWindow.v, wRoof.v, dStripeRoofLeft.v, false),
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

  GlModelBuffer modelStripe = new GlAreaModel([
    //hood
    new GlRectangle.withWD(w.h-wHood.v,hCarBottom.v, -d.h+dStripeLeft.v, wHood.v, dStripeMid.v, false),
    //rear top
    new GlRectangle.withWD(-w.h,hCarBottom.v, -d.h+dStripeLeft.v, wRear.v, dStripeMid.v, false),
    //roof
    new GlRectangle.withWD(-w.h+wRear.v+wWindowRear.v,h.v, -d.h+dWindow.v+dStripeRoofLeft.v, wRoof.v, dStripeRoofMid.v, false),

  ]).createBuffers(layer);

  GlModelBuffer modelWindows = new GlAreaModel([
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


  var color = new GlColor(1.0,1.0,0.0);
  var color2 = new GlColor(0.0,0.0,1.0);
  var colorWindows = new GlColor(0.0,0.0,0.2);
  return new GlModelInstanceCollection([new GlModelInstance(model, color),new GlModelInstance(modelStripe, color2),new GlModelInstance(modelWindows, colorWindows)]);
}

GlModelInstanceCollection createXYZMark(){
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

void draw(){
  layer.clearForNextFrame();
  camera.setCameraAngleAndOffset(new GlVector(0.0,0.0,0.0),rx:rx,ry:ry,rz:rz,offsetX:ox,offsetY:oy,offsetZ:oz);
  var viewProjectionMatrix = camera.cameraMatrix;//createMatrix();
  var worldMatrix = GlMatrix.rotationYMatrix(0.0);

  //2 call draw method with buffer
  for(GlModelInstanceCollection m in modelInstances){

    GlMatrix objPerspective = viewProjectionMatrix*worldMatrix*m.CreateTransformMatrix();

    for(GlModelInstance mi in m.modelInstances){
      layer.setWorld(worldMatrix,objPerspective*mi.CreateTransformMatrix(), new GlVector(lx,ly,lz),lightImpact);
      layer.drawModel(mi);
    }
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