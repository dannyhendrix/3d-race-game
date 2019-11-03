import "dart:html";
import "dart:math" as Math;
import "package:webgl/webgl.dart";
import "package:micromachines/webgl_game.dart";
import "package:renderlayer/renderlayer.dart";
import "package:micromachines/leveleditor.dart";
import "package:dashboard/uihelper.dart";

void applyView(GlPreview preview, double rx, double ry, double rz){
  preview.rx = rx;
  preview.ry = ry;
  preview.rz = rz;
  preview.draw();
}
void main(){
  var models = getRawModels();
  setTexture(models);

  var previewMenu = PreviewMenu();
  document.body.append(previewMenu.createElement());
  previewMenu.repaint(models, 0, 0);
  var textureMenu = TextureMenu();
  document.body.append(textureMenu.createElement());
  textureMenu.repaint(models, 0, 0);

  TriangleEditor triangleEditor;
  TriangleSelector triangleSelector;
  triangleEditor= TriangleEditor((){
    var m = triangleSelector.getSelectedModelIndex();
    var t = triangleSelector.getSelectedTriangleIndex();
    models[m].areas[t] = triangleEditor.getPoint();
    setTexture(models);

    previewMenu.repaint(models, m, t);
    textureMenu.repaint(models, m, t);
    triangleEditor.setTriangle(models[m].areas[t]);
  });
  triangleSelector = TriangleSelector((){
    var m = triangleSelector.getSelectedModelIndex();
    var t = triangleSelector.getSelectedTriangleIndex();
    previewMenu.repaint(models, m, t);
    textureMenu.repaint(models, m, t);
    triangleEditor.setTriangle(models[m].areas[t]);
  });
  document.body.append(triangleSelector.element);

  document.body.append(triangleEditor.element);
}

void setTexture(List<GlAreaModel> models){
  for(var model in models){
    for(GlTriangle triangle in model.areas){
      var pa = triangle.points[0];
      var pb = triangle.points[1];
      var pc = triangle.points[2];

      var c = lengthPoints(pa,pb);
      var a = lengthPoints(pb,pc);
      var b = lengthPoints(pc,pa);

      //print("$a $b $c");

      var A = angle(a,b,c);
      var B = angle(b,a,c);
      var C = angle(c,a,b);

      print("$A $B $C");

      pb.tx = pa.tx;
      pb.ty = pa.ty+c;
      pc.tx = pa.tx+ Math.sin(A) * b;
      pc.ty = pa.ty+ Math.cos(A) * b;
    }
  }
}

double angle(double a, double b, double c) => Math.acos((pow2(b)+pow2(c)-pow2(a))/(2*b*c));
double lengthPoints(GlPoint a,GlPoint b) => Math.sqrt( pow2(b.x-a.x)+pow2(b.y-a.y)+pow2(b.z-a.z) );
double pow2(double v) => v * v;
double lengthPoint(GlPoint a) => Math.sqrt( a.x * a.x + a.y * a.y + a.z * a.z );
double dot(GlPoint a,GlPoint b) => Math.sqrt( a.x * b.x + a.y * b.y + a.z * b.z );
GlPoint subPoint(GlPoint a,GlPoint b) => GlPoint( a.x - b.x ,a.y - b.y,a.z - b.z );


List<GlAreaModel> getRawModels(){
  List<GlAreaModel> models = [];
  /*
  var collection = GlModelCollectionModels();
  var model = GlModel_Vehicle();
  model.loadModel(collection);

    for(var modelpart in collection.getAllModels()){
    List<GlTriangle> triangles = [];
    var mm = modelpart as GlAreaModel;
    for(var area in mm.areas){
      if(area is GlTriangle)
      {
        triangles.add(area);
      }
      if(area is GlArea){
        for(var triangle in area.triangles){
          triangles.add(triangle);
        }
      }
    }
    models.add(GlAreaModel(triangles));
  }
  */
  var cube = new GlCube.fromTopCenter(0,0,0,60,100,40,0,0);
  List<GlTriangle> triangles = [];
  for(var area in cube.areas){
    if(area is GlTriangle)
    {
      triangles.add(area);
    }
    if(area is GlArea){
      for(var triangle in area.triangles){
        triangles.add(triangle);
      }
    }
  }
  models.add(GlAreaModel(triangles));




  return models;
}

class TextureMenu{
  RenderTexture _renderTexture;
  Element createElement(){
    _renderTexture = new RenderTexture();
    var menu = new UiPanelTitled("Texture");
    menu.appendElement(_renderTexture.layer.canvas);
    return menu.element;
  }
  void repaint(List<GlModel> models, int currentModel, int currentTriangle){
    _renderTexture.layer.clear();
    _renderTexture.drawModels(models, currentModel, currentTriangle);
  }
}

class PreviewMenu{
  double ox = 0.0;
  double oy = 0.0;
  double oz = 240.0;
  double rx = 5.3;
  double ry = 0.0;
  double rz = 0.0;
  GlPreview preview;
  Element _previewContainer;
  Element createElement(){
    var menu = UiPanelTitled("Preview");
    _previewContainer = new DivElement();
    var col_preview = UIColumn();
    var col_sliders = UIColumn();
    menu.append(col_preview);
    menu.append(col_sliders);
    col_preview.appendElement(_previewContainer);

    UiInputDoubleSlider slider;
    slider = new UiInputDoubleSlider("offsetx",0.0,300.0,100.0);
    slider.onValueChange = (val){ ox = val; _repaint(); };
    col_sliders.append(slider);
    slider.setValue(ox);

    slider = new UiInputDoubleSlider("offsety",0.0,300.0,100.0);
    slider.onValueChange = (val){ oy = val; _repaint(); };
    col_sliders.append(slider);
    slider.setValue(oy);

    slider = new UiInputDoubleSlider("offsetz",0.0,900.0,100.0);
    slider.onValueChange = (val){ oz = val; _repaint(); };
    col_sliders.append(slider);
    slider.setValue(oz);

    slider = new UiInputDoubleSlider("rotatex",0.0,2*Math.pi,100.0);
    slider.onValueChange = (val){ rx = val; _repaint(); };
    col_sliders.append(slider);
    slider.setValue(rx);

    slider = new UiInputDoubleSlider("rotatey",0.0,2*Math.pi,100.0);
    slider.onValueChange = (val){ ry = val; _repaint(); };
    col_sliders.append(slider);
    slider.setValue(ry);

    slider = new UiInputDoubleSlider("rotatez",0.0,2*Math.pi,100.0);
    slider.onValueChange = (val){ rz = val; _repaint(); };
    col_sliders.append(slider);
    slider.setValue(rz);

    return menu.element;
  }
  void repaint(List<GlModel> models, int currentModel, int currentTriangle){
    _previewContainer.children.clear();
    preview = _createNewPreview(models,currentModel,currentTriangle);
    _previewContainer.append(preview.layer.canvas);
    _repaint();
  }
  void _repaint(){
    preview.ox = ox;
    preview.oy = oy;
    preview.oz = oz;
    preview.rx = rx;
    preview.ry = ry;
    preview.rz = rz;
    preview.draw();
  }
  GlPreview _createNewPreview(List<GlAreaModel> rawmodels, int selectedModel, int selectTriangle){
    GlPreview preview;
    preview = new GlPreview(800.0,500.0,(GlModelCollection modelCollection){
      var drawModels = [createXYZMark(preview.layer)];
      GlTriangle selectedTriangle = null;

      for(int i = 0; i < rawmodels.length; i++){
        var isSelected = i == selectedModel && selectTriangle >= 0;
        if(isSelected){
          selectedTriangle =  rawmodels[i].areas[selectTriangle];
          //remove triangle from model
          rawmodels[i].areas.removeAt(selectTriangle);
        }
        var key = "model$i";
        modelCollection.loadModel(key, rawmodels[i]);
        var instance = new GlModelInstanceCollection([
          new GlModelInstance(modelCollection.getModelBuffer(key), new GlColor(0,0,1.0)),
        ]);
        drawModels.add(instance);
        if(isSelected){
          //restore removed triangle
          rawmodels[i].areas.insert(selectTriangle,selectedTriangle);
        }
      }

      if(selectedTriangle != null){
        var key = "selected";
        modelCollection.loadModel(key, new GlAreaModel([selectedTriangle]));
        var instance = new GlModelInstanceCollection([
          new GlModelInstance(modelCollection.getModelBuffer(key), new GlColor(1.0,0,0)),
        ]);
        drawModels.add(instance);
      }

      return drawModels;

    }, false);


    preview.background = new GlColor(.8,.8,.8);
    preview.ox = 0.0;
    preview.oy = 0.0;
    preview.oz = 240.0;
    preview.rx = 5.3;
    preview.ry = 0.0;
    preview.rz = 0.0;
    preview.lx = 0.3;
    preview.ly = 0.7;
    preview.lz = 0.1;
    preview.create();

    preview.draw();
    return preview;
  }
}

class TriangleSelector extends UiElement{
  UiInputInt _in_modelIndex;
  UiInputInt _in_triangleIndex;
  Function _onValueChange;

  TriangleSelector(this._onValueChange);

  int getSelectedModelIndex() => _in_modelIndex.getValue();
  int getSelectedTriangleIndex() => _in_triangleIndex.getValue();

  Element createElement(){
    var menu = new UiPanelTitled("Selection");
    _in_modelIndex = UiInputInt("Model index");
    _in_triangleIndex = UiInputInt("Triangle index");
    _in_modelIndex.onValueChange = (i) => _onValueChange();
    _in_triangleIndex.onValueChange = (i) => _onValueChange();
    menu.append(_in_modelIndex);
    menu.append(_in_triangleIndex);
    return menu.element;
  }
}

class TriangleEditor extends UiElement{
  PointEditor _in_point1;
  PointEditor _in_point2;
  PointEditor _in_point3;
  Function _onValueChange;

  TriangleEditor(this._onValueChange);

  void setTriangle(GlTriangle t){
    _in_point1.setValue(t.points[0]);
    _in_point2.setValue(t.points[1]);
    _in_point3.setValue(t.points[2]);
  }
  GlTriangle getPoint(){
    return GlTriangle([_in_point1.getValue(),_in_point2.getValue(),_in_point3.getValue()]);
  }
  Element createElement(){
    var menu = new UiPanelTitled("Triangle");
    _in_point1 = new PointEditor(_onValueChange);
    _in_point2 = new PointEditor(_onValueChange);
    _in_point3 = new PointEditor(_onValueChange);
    menu.append(_in_point1);
    menu.append(_in_point2);
    menu.append(_in_point3);
    return menu.element;
  }
}

class PointEditor extends UiElement{
  UiInputDouble _in_x;
  UiInputDouble _in_y;
  UiInputDouble _in_z;
  UiInputDouble _in_tx;
  UiInputDouble _in_ty;
  Function _onValueChange;

  PointEditor(this._onValueChange);

  void setValue(GlPoint point){
    _in_x.setValue(point.x);
    _in_y.setValue(point.y);
    _in_z.setValue(point.z);
    _in_tx.setValue(point.tx);
    _in_ty.setValue(point.ty);
  }
  GlPoint getValue(){
    return GlPoint(_in_x.getValue(),_in_y.getValue(),_in_z.getValue(),_in_tx.getValue(),_in_ty.getValue());
  }
  Element createElement(){
    var menu = new UiPanelTitled("Point");
    _in_x = new UiInputDouble("x");
    _in_y = new UiInputDouble("y");
    _in_z = new UiInputDouble("z");
    _in_tx = new UiInputDouble("tx");
    _in_ty = new UiInputDouble("ty");
    _in_x.onValueChange = (i) => _onValueChange();
    _in_y.onValueChange = (i) => _onValueChange();
    _in_z.onValueChange = (i) => _onValueChange();
    _in_tx.onValueChange = (i) => _onValueChange();
    _in_ty.onValueChange = (i) => _onValueChange();
    menu.append(_in_x);
    menu.append(_in_y);
    menu.append(_in_z);
    menu.append(_in_tx);
    menu.append(_in_ty);
    return menu.element;
  }
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

class RenderTexture{
  static const int textureSize = 256;
  RenderLayer layer;

  RenderTexture(){
    layer = new RenderLayer.withSize(textureSize,textureSize);
    layer.ctx.fillStyle = "#000";
    layer.ctx.fillRect(0, 0, textureSize, textureSize);
  }
  void drawModels(List<GlAreaModel> models, int selectedModel, int selectedTriangle)
  {
    int im = 0;
    for(var m in models){
      _drawModel(m,im == selectedModel && selectedTriangle >= 0 ? selectedTriangle : -1);
      im++;
    }
  }
  void _drawModel(GlAreaModel model, int selectedTriangle){
    var it = 0;
    for(var area in model.areas){
        _drawTriangle(area, it == selectedTriangle);
        it++;
    }
  }

  void _drawTriangle(GlTriangle triangle, bool selected){
    var color = selected ? "#F00" : "#00F";
    layer.ctx.fillStyle = color;
    var p = triangle.toTextureVertex(1.0); // returns a triangle with texture points [x1,y1,x2,y2,x3,y3]
    layer.ctx.moveTo(p[0], p[1]);
    layer.ctx.beginPath();
    layer.ctx.lineTo(p[2], p[3]);
    layer.ctx.lineTo(p[4], p[5]);
    layer.ctx.lineTo(p[0], p[1]);
    layer.ctx.fill();
    layer.ctx.closePath();
  }
}
