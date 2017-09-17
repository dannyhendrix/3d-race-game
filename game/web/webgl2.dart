import "dart:html";
import "dart:math" as Math;
import "package:micromachines/webgl.dart";
import "dart:web_gl";

GlRenderLayer layer;
List<GlModelInstance> modelInstances = [];
GlCamera camera;

double lx = 0.2,ly = 0.2,lz = 0.2;

void main(){
  layer = new GlRenderLayer.withSize(400,500);
  document.body.append(layer.canvas);

  // Tell WebGL how to convert from clip space to pixels
  layer.ctx.viewport(0, 0, layer.canvas.width, layer.canvas.height);
  layer.setClearColor(new GlColor(0.0,0.0,1.0));

  //create all buffer
  GlModelBuffer cube = new GlCube.fromTopCenter(0.0,0.0,0.0,150.0,200.0,150.0).createBuffers(layer);
  //modelInstances.add(new GlModelInstance(cube, new GlColor()));
  var m2 = new GlModelInstance(cube,new GlColor(),-320.0,-100.0,-100.0);
  m2.ry = 1.0;
  modelInstances.add(m2);

  GlModelBuffer model = new GlModel([
    new GlTriangle([
      new GlPoint(0.0,0.0,0.0),
      new GlPoint(2.0,0.0,0.0),
      new GlPoint(0.0,1.0,0.0),
    ]),
    new GlTriangle([
      new GlPoint(0.0,0.0,0.0),
      new GlPoint(0.0,1.0,0.0),
      new GlPoint(2.0,0.0,0.0),
    ])
  ]).createBuffers(layer);
  modelInstances.add(new GlModelInstance(model, new GlColor(1.0,0.0,0.0)));
  GlModelBuffer model2 = new GlModel([
    new GlTriangle([
      new GlPoint(0.0,0.0,0.0),
      new GlPoint(0.0,2.0,0.0),
      new GlPoint(1.0,0.0,0.0),
    ]),
    new GlTriangle([
      new GlPoint(0.0,0.0,0.0),
      new GlPoint(0.0,1.0,0.0),
      new GlPoint(2.0,0.0,0.0),
    ])
  ]).createBuffers(layer);
  modelInstances.add(new GlModelInstance(model2, new GlColor(0.0,1.0,0.0)));

  //3 set view perspective
  camera = new GlCamera(400.0 / 500.0);
  camera.x = 300.0;

  document.body.append(createSlider("lx",0.0,2.0,0.1,lx,(String val){ lx = double.parse(val)-1.0; draw(); }));
  document.body.append(createSlider("ly",0.0,2.0,0.1,ly,(String val){ ly = double.parse(val)-1.0; draw(); }));
  document.body.append(createSlider("lz",0.0,2.0,0.1,lz,(String val){ lz = double.parse(val)-1.0; draw(); }));
  document.body.append(createSlider("cx",0.0,500.0,1.0,camera.x,(String val){ camera.x = double.parse(val); draw(); }));
  document.body.append(createSlider("cy",0.0,500.0,1.0,camera.y,(String val){ camera.y = double.parse(val); draw(); }));
  document.body.append(createSlider("cz",0.0,500.0,1.0,camera.z,(String val){ camera.z = double.parse(val); draw(); }));
  document.body.append(createSlider("fieldOfViewRadians",0.0,Math.PI,0.1,camera.fieldOfViewRadians,(String val){ camera.fieldOfViewRadians = double.parse(val); draw(); }));

  draw();
}

void draw(){
  layer.clearForNextFrame();

  var viewProjectionMatrix = camera.createMatrix();
  var worldMatrix = GlMatrix.rotationYMatrix(0.0);

  //2 call draw method with buffer
  for(GlModelInstance m in modelInstances){
    GlMatrix objPerspective = worldMatrix.translate(m.x,m.y,m.z);
    objPerspective = objPerspective.rotateX(m.rx);
    objPerspective = objPerspective.rotateY(m.ry);
    objPerspective = objPerspective.rotateZ(m.rz);
    layer.setWorld(objPerspective,viewProjectionMatrix*objPerspective, new GlVector(lx,ly,lz));
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