import "dart:html";
import "dart:math" as Math;
import "package:webgl/webgl.dart";
import "package:micromachines/webgl_game.dart";
import "package:renderlayer/renderlayer.dart";
import "package:micromachines/leveleditor.dart";

void applyView(GlPreview preview, double rx, double ry, double rz){
  preview.rx = rx;
  preview.ry = ry;
  preview.rz = rz;
  preview.draw();
}
void main(){
  var models = getRawModels();

  var previewMenu = PreviewMenu();
  document.body.append(previewMenu.createElement());
  previewMenu.repaint(models, 0, 0);

  TriangleEditor triangleEditor;
  TriangleSelector triangleSelector;
  triangleEditor= TriangleEditor((){
    var m = triangleSelector.getSelectedModelIndex();
    var t = triangleSelector.getSelectedTriangleIndex();
    models[m].areas[t] = triangleEditor.getPoint();

    previewMenu.repaint(models, m, t);
    triangleEditor.setTriangle(models[m].areas[t]);
  });
  triangleSelector = TriangleSelector((){
    var m = triangleSelector.getSelectedModelIndex();
    var t = triangleSelector.getSelectedTriangleIndex();
    previewMenu.repaint(models, m, t);
    triangleEditor.setTriangle(models[m].areas[t]);
  });
  document.body.append(triangleSelector.createElement());

  document.body.append(triangleEditor.createElement());
}

GlPreview createNewPreview(List<GlAreaModel> rawmodels, int selectedModel, int selectTriangle){
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

List<GlAreaModel> getRawModels(){
  var collection = GlModelCollectionModels();
  var model = GlModel_Vehicle();
  model.loadModel(collection);

  List<GlAreaModel> models = [];
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
  return models;
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
    var menu = UIMenu("Preview");
    _previewContainer = new DivElement();
    var el = menu.createElement();
    var col_preview = UIColumn();
    var col_sliders = UIColumn();
    menu.append(col_preview.createElement());
    menu.append(col_sliders.createElement());
    col_preview.append(_previewContainer);

    InputFormDoubleSlider slider;
    slider = new InputFormDoubleSlider("offsetx",0.0,300.0,100.0);
    slider.onValueChange = (val){ ox = val; _repaint(); };
    col_sliders.append(slider.createElement());
    slider.setValue(ox);

    slider = new InputFormDoubleSlider("offsety",0.0,300.0,100.0);
    slider.onValueChange = (val){ oy = val; _repaint(); };
    col_sliders.append(slider.createElement());
    slider.setValue(oy);

    slider = new InputFormDoubleSlider("offsetz",0.0,900.0,100.0);
    slider.onValueChange = (val){ oz = val; _repaint(); };
    col_sliders.append(slider.createElement());
    slider.setValue(oz);

    slider = new InputFormDoubleSlider("rotatex",0.0,2*Math.pi,100.0);
    slider.onValueChange = (val){ rx = val; _repaint(); };
    col_sliders.append(slider.createElement());
    slider.setValue(rx);

    slider = new InputFormDoubleSlider("rotatey",0.0,2*Math.pi,100.0);
    slider.onValueChange = (val){ ry = val; _repaint(); };
    col_sliders.append(slider.createElement());
    slider.setValue(ry);

    slider = new InputFormDoubleSlider("rotatez",0.0,2*Math.pi,100.0);
    slider.onValueChange = (val){ rz = val; _repaint(); };
    col_sliders.append(slider.createElement());
    slider.setValue(rz);

    return el;
  }
  void repaint(List<GlModel> models, int currentModel, int currentTriangle){
    _previewContainer.children.clear();
    preview = createNewPreview(models,currentModel,currentTriangle);
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

}

class TriangleSelector{
  InputFormInt _in_modelIndex;
  InputFormInt _in_triangleIndex;
  Function _onValueChange;

  TriangleSelector(this._onValueChange);

  int getSelectedModelIndex() => _in_modelIndex.getValue();
  int getSelectedTriangleIndex() => _in_triangleIndex.getValue();

  Element createElement(){
    var menu = new UIMenu("Selection");
    _in_modelIndex = InputFormInt("Model index");
    _in_triangleIndex = InputFormInt("Triangle index");
    _in_modelIndex.onValueChange = (i) => _onValueChange();
    _in_triangleIndex.onValueChange = (i) => _onValueChange();
    var el = menu.createElement();
    menu.append(_in_modelIndex.createElement());
    menu.append(_in_triangleIndex.createElement());
    return el;
  }
}

class TriangleEditor{
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
    var menu = new UIMenu("Triangle");
    _in_point1 = new PointEditor(_onValueChange);
    _in_point2 = new PointEditor(_onValueChange);
    _in_point3 = new PointEditor(_onValueChange);
    var el = menu.createElement();
    menu.append(_in_point1.createElement());
    menu.append(_in_point2.createElement());
    menu.append(_in_point3.createElement());
    return el;
  }
}

class PointEditor{
  InputFormDouble _in_x;
  InputFormDouble _in_y;
  InputFormDouble _in_z;
  Function _onValueChange;

  PointEditor(this._onValueChange);

  void setValue(GlPoint point){
    _in_x.setValue(point.x);
    _in_y.setValue(point.y);
    _in_z.setValue(point.z);
  }
  GlPoint getValue(){
    return GlPoint(_in_x.getValue(),_in_y.getValue(),_in_z.getValue());
  }
  Element createElement(){
    var menu = new UIMenu("Point");
    _in_x = new InputFormDouble("x");
    _in_y = new InputFormDouble("y");
    _in_z = new InputFormDouble("z");
    _in_x.onValueChange = (i) => _onValueChange();
    _in_y.onValueChange = (i) => _onValueChange();
    _in_z.onValueChange = (i) => _onValueChange();
    var el = menu.createElement();
    menu.append(_in_x.createElement());
    menu.append(_in_y.createElement());
    menu.append(_in_z.createElement());
    return el;
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


