import "dart:html";
import "dart:math" as Math;
import "package:micromachines/webgl.dart";
import "package:micromachines/webgl_game.dart";
import "dart:web_gl";

GlRenderLayer layer;
List<GlModelInstanceCollection> modelInstances = [];
GlCameraDistanseToTarget camera;

double rx = 0.5, ry = 2.6, rz=0.0;
double ox = 0.0, oy = 0.0, oz=400.0;
double lx = 0.5, ly = 0.5, lz = 0.5;
double lightImpact = 0.5;

double wr = 0.5, wg = 0.5, wb = 0.5;
double c1r = 0.5, c1g = 0.5, c1b = 0.5;
double c2r = 0.5, c2g = 0.5, c2b = 0.5;

void main(){
  double windowW = 500.0;
  double windowH = 400.0;
  layer = new GlRenderLayer.withSize(windowW.toInt(),windowH.toInt(), false);
  document.body.append(layer.canvas);

  // Tell WebGL how to convert from clip space to pixels
  layer.ctx.viewport(0, 0, layer.canvas.width, layer.canvas.height);
  layer.setClearColor(new GlColor(0.4,0.4,0.4));

  //3 set view perspective
  camera = new GlCameraDistanseToTarget();
  camera.setPerspective(aspect : windowW / windowH);

  //4 create models
  modelInstances.add(createXYZMark());
  GlModelCollection modelCollection = new GlModelCollection(layer);
  GlModel_Vehicle vehicleModel = new GlModel_Vehicle();
  GlModel_Truck truckModel = new GlModel_Truck();
  GlModel_TruckTrailer trucktrailerModel = new GlModel_TruckTrailer();
  GlModel_Tree treeModel = new GlModel_Tree();
  GlModel_Wall wallModel = new GlModel_Wall();
  vehicleModel.loadModel(modelCollection);
  truckModel.loadModel(modelCollection);
  trucktrailerModel.loadModel(modelCollection);
  treeModel.loadModel(modelCollection);
  wallModel.loadModel(modelCollection);
  var car = vehicleModel.getModelInstance(modelCollection, new GlColor(1.0,0.0,0.0), new GlColor(1.0,1.0,0.0), new GlColor(0.0,0.0,0.3));
  var truck = truckModel.getModelInstance(modelCollection, new GlColor(1.0,0.0,0.0), new GlColor(1.0,1.0,0.0), new GlColor(0.0,0.0,0.3));
  var trailer = trucktrailerModel.getModelInstance(modelCollection, new GlColor(1.0,0.0,0.0), new GlColor(1.0,1.0,0.0), new GlColor(0.0,0.0,0.3));
  var tree = treeModel.getModelInstance(modelCollection);
  truck.move(GlMatrix.translationMatrix(60.0,0.0,0.0));

/*
  var color = new GlColor(1.0,0.5,0.0);
  var colorPoles = new GlColor(0.6,0.6,0.6);
  List<Polygon> absoluteCollisionFields = o.getAbsoluteCollisionFields();
  Point2d wallLeftPosition = absoluteCollisionFields[0].center;
  Point2d wallRightPosition = absoluteCollisionFields[1].center;
  modelInstances.add(new GlModelInstanceFromModelStatic(wallLeftPosition.x,75.0,wallLeftPosition.y, 0.0,-o.r,0.0, wallModel
      .getModelInstance(modelCollection, o.wallW, 150.0, o.wallH,colorPoles)));
  modelInstances.add(new GlModelInstanceFromModelStatic(wallRightPosition.x,75.0,wallRightPosition.y, 0.0,-o.r,0.0, wallModel
      .getModelInstance(modelCollection, o.wallW, 150.0, o.wallH,colorPoles)));
  modelInstances.add(new GlModelInstanceFromModelStatic(o.position.x,150.0-30.0,o.position.y, 0.0,-o.r,0.0, wallModel
      .getModelInstance(modelCollection, o.w-o.wallW-o.wallW, 60.0, 4.0,color)));
*/
  modelInstances.add(tree);
  //modelInstances.add(truck);
  //modelInstances.add(trailer);
  /*
  document.body.append(createTitle("Light"));
  document.body.append(createSlider("Light % impact",0.0,1.0,0.1,lightImpact,(String val){ lightImpact = double.parse(val); draw(); }));
  document.body.append(createSlider("Light % comming from x",0.0,1.0,0.1,lx,(String val){ lx = double.parse(val); draw(); }));
  document.body.append(createSlider("Light % comming from y",0.0,1.0,0.1,ly,(String val){ ly = double.parse(val); draw(); }));
  document.body.append(createSlider("Light % comming from z",0.0,1.0,0.1,lz,(String val){ lz = double.parse(val); draw(); }));
  */
  document.body.append(createTitle("Camera position"));
  document.body.append(createSlider("offsetx",0.0,300.0,1.0,ox,(String val){ ox = double.parse(val); draw(); }));
  document.body.append(createSlider("offsety",0.0,300.0,1.0,oy,(String val){ oy = double.parse(val); draw(); }));
  document.body.append(createSlider("offsetz",0.0,900.0,1.0,oz,(String val){ oz = double.parse(val); draw(); }));
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
  GlMatrix viewProjectionMatrix = camera.cameraMatrix;//createMatrix();
  GlMatrix worldMatrix = GlMatrix.rotationYMatrix(0.0);

  //2 call draw method with buffer
  for(GlModelInstanceCollection m in modelInstances){
    GlMatrix matrix = m.CreateTransformMatrix().multThis(worldMatrix);
    GlMatrix objPerspective = viewProjectionMatrix.clone().multThis(matrix);

    for(GlModelInstance mi in m.modelInstances){
      layer.setWorld(worldMatrix,objPerspective.clone().multThis(mi.CreateTransformMatrix()), new GlVector(lx,ly,lz),lightImpact);
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