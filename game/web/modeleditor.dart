import "dart:html";
import "dart:math" as Math;
import "package:webgl/webgl.dart";
import "package:renderlayer/renderlayer.dart";
import "package:dashboard/uihelper.dart";
import "package:dependencyinjection/dependencyinjection.dart";

void applyView(GlPreview preview, double rx, double ry, double rz) {
  preview.rx = rx;
  preview.ry = ry;
  preview.rz = rz;
  preview.draw();
}

void main() {
  var lifetime = DependencyBuilderFactory().createNew((builder) {
    builder.registerModule(UiComposition());
    builder.registerType((lifetime) => new RenderTexture(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => new PointEditor(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => new PreviewMenu(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => new TextureMenu(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => new TriangleEditor(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => new TriangleSelector(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
  });

  var models = getRawModels();
  setTexture(models);

  PreviewMenu previewMenu = lifetime.resolve();
  document.body.append(previewMenu.element);
  previewMenu.repaint(models, 0, 0);
  TextureMenu textureMenu = lifetime.resolve();
  document.body.append(textureMenu.element);
  textureMenu.repaint(models, 0, 0);

  TriangleEditor triangleEditor;
  TriangleSelector triangleSelector;
  triangleEditor = lifetime.resolve<TriangleEditor>()
    ..setOnValueChange(() {
      var m = triangleSelector.getSelectedModelIndex();
      var t = triangleSelector.getSelectedTriangleIndex();
      models[m].areas[t] = triangleEditor.getPoint();
      setTexture(models);

      previewMenu.repaint(models, m, t);
      textureMenu.repaint(models, m, t);
      triangleEditor.setTriangle(models[m].areas[t]);
    });
  triangleSelector = lifetime.resolve<TriangleSelector>()
    ..setOnValueChange(() {
      var m = triangleSelector.getSelectedModelIndex();
      var t = triangleSelector.getSelectedTriangleIndex();
      previewMenu.repaint(models, m, t);
      textureMenu.repaint(models, m, t);
      triangleEditor.setTriangle(models[m].areas[t]);
    });
  print(triangleSelector.element);
  document.body.append(triangleSelector.element);

  document.body.append(triangleEditor.element);
}

void setTexture(List<GlAreaModel> models) {
  for (var model in models) {
    for (GlTriangle triangle in model.areas) {
      var pa = triangle.points[0];
      var pb = triangle.points[1];
      var pc = triangle.points[2];

      var c = lengthPoints(pa, pb);
      var a = lengthPoints(pb, pc);
      var b = lengthPoints(pc, pa);

      //print("$a $b $c");

      var A = angle(a, b, c);
      var B = angle(b, a, c);
      var C = angle(c, a, b);

      print("$A $B $C");

      pb.tx = pa.tx;
      pb.ty = pa.ty + c;
      pc.tx = pa.tx + Math.sin(A) * b;
      pc.ty = pa.ty + Math.cos(A) * b;
    }
  }
}

double angle(double a, double b, double c) => Math.acos((pow2(b) + pow2(c) - pow2(a)) / (2 * b * c));
double lengthPoints(GlPoint a, GlPoint b) => Math.sqrt(pow2(b.x - a.x) + pow2(b.y - a.y) + pow2(b.z - a.z));
double pow2(double v) => v * v;
double lengthPoint(GlPoint a) => Math.sqrt(a.x * a.x + a.y * a.y + a.z * a.z);
double dot(GlPoint a, GlPoint b) => Math.sqrt(a.x * b.x + a.y * b.y + a.z * b.z);
GlPoint subPoint(GlPoint a, GlPoint b) => GlPoint(a.x - b.x, a.y - b.y, a.z - b.z);

List<GlAreaModel> getRawModels() {
  List<GlAreaModel> models = [];
  var cube = new GlCube.fromTopCenter(0, 0, 0, 60, 100, 40, 0, 0);
  List<GlTriangle> triangles = [];
  for (var area in cube.areas) {
    if (area is GlTriangle) {
      triangles.add(area);
    }
    if (area is GlArea) {
      for (var triangle in area.triangles) {
        triangles.add(triangle);
      }
    }
  }
  models.add(GlAreaModel(triangles));

  return models;
}

class TextureMenu extends UiPanelTitled {
  RenderTexture _renderTexture;

  TextureMenu(ILifetime lifetime) : super(lifetime) {
    _renderTexture = lifetime.resolve();
  }
  @override
  void build() {
    super.build();
    changeTitle("Texture");
    appendElement(_renderTexture.layer.canvas);
  }

  void repaint(List<GlModel> models, int currentModel, int currentTriangle) {
    _renderTexture.layer.clear();
    _renderTexture.drawModels(models, currentModel, currentTriangle);
  }
}

class PreviewMenu extends UiPanelTitled {
  double ox = 0.0;
  double oy = 0.0;
  double oz = 240.0;
  double rx = 5.3;
  double ry = 0.0;
  double rz = 0.0;
  GlPreview preview;
  UiColumn _colPreview;
  UiColumn _colSliders;
  UiPanel _previewContainer;
  UiInputDoubleSlider _sliderX;
  UiInputDoubleSlider _sliderY;
  UiInputDoubleSlider _sliderZ;
  UiInputDoubleSlider _sliderRx;
  UiInputDoubleSlider _sliderRy;
  UiInputDoubleSlider _sliderRz;
  PreviewMenu(ILifetime lifetime) : super(lifetime) {
    _previewContainer = lifetime.resolve();
    _colPreview = lifetime.resolve();
    _colSliders = lifetime.resolve();
    _sliderX = lifetime.resolve();
    _sliderY = lifetime.resolve();
    _sliderZ = lifetime.resolve();
    _sliderRx = lifetime.resolve();
    _sliderRy = lifetime.resolve();
    _sliderRz = lifetime.resolve();
  }
  @override
  void build() {
    super.build();
    changeTitle("Preview");
    append(_colPreview);
    append(_colSliders);
    _colPreview.append(_previewContainer);
    _colSliders.append(_sliderX);
    _colSliders.append(_sliderY);
    _colSliders.append(_sliderZ);
    _colSliders.append(_sliderRx);
    _colSliders.append(_sliderRy);
    _colSliders.append(_sliderRz);

    _sliderX
      ..changeLabel("offsetx")
      ..setMin(0.0)
      ..setMax(300.0)
      ..setSteps(100.0)
      ..setValue(ox)
      ..onValueChange = (val) {
        ox = val;
        _repaint();
      };

    _sliderY
      ..changeLabel("offsety")
      ..setMin(0.0)
      ..setMax(300.0)
      ..setSteps(100.0)
      ..setValue(oy)
      ..onValueChange = (val) {
        oy = val;
        _repaint();
      };

    _sliderZ
      ..changeLabel("offsetz")
      ..setMin(0.0)
      ..setMax(900.0)
      ..setSteps(100.0)
      ..setValue(oz)
      ..onValueChange = (val) {
        oz = val;
        _repaint();
      };

    _sliderRx
      ..changeLabel("rotatex")
      ..setMin(0.0)
      ..setMax(2 * Math.pi)
      ..setSteps(100.0)
      ..setValue(rx)
      ..onValueChange = (val) {
        rx = val;
        _repaint();
      };

    _sliderRy
      ..changeLabel("rotatey")
      ..setMin(0.0)
      ..setMax(2 * Math.pi)
      ..setSteps(100.0)
      ..setValue(ry)
      ..onValueChange = (val) {
        ry = val;
        _repaint();
      };

    _sliderRz
      ..changeLabel("rotatez")
      ..setMin(0.0)
      ..setMax(2 * Math.pi)
      ..setSteps(100.0)
      ..setValue(rz)
      ..onValueChange = (val) {
        rz = val;
        _repaint();
      };
  }

  void repaint(List<GlModel> models, int currentModel, int currentTriangle) {
    _previewContainer.clear();
    preview = _createNewPreview(models, currentModel, currentTriangle);
    _previewContainer.appendElement(preview.layer.canvas);
    _repaint();
  }

  void _repaint() {
    preview.ox = ox;
    preview.oy = oy;
    preview.oz = oz;
    preview.rx = rx;
    preview.ry = ry;
    preview.rz = rz;
    preview.draw();
  }

  GlPreview _createNewPreview(List<GlAreaModel> rawmodels, int selectedModel, int selectTriangle) {
    GlPreview preview;
    preview = new GlPreview(800.0, 500.0, (GlModelCollection modelCollection) {
      var drawModels = [createXYZMark(preview.layer)];
      GlTriangle selectedTriangle = null;

      for (int i = 0; i < rawmodels.length; i++) {
        var isSelected = i == selectedModel && selectTriangle >= 0;
        if (isSelected) {
          selectedTriangle = rawmodels[i].areas[selectTriangle];
          //remove triangle from model
          rawmodels[i].areas.removeAt(selectTriangle);
        }
        var key = "model$i";
        modelCollection.loadModel(key, rawmodels[i]);
        var instance = new GlModelInstanceCollection([
          new GlModelInstance(modelCollection.getModelBuffer(key), new GlColor(0, 0, 1.0)),
        ]);
        drawModels.add(instance);
        if (isSelected) {
          //restore removed triangle
          rawmodels[i].areas.insert(selectTriangle, selectedTriangle);
        }
      }

      if (selectedTriangle != null) {
        var key = "selected";
        modelCollection.loadModel(key, new GlAreaModel([selectedTriangle]));
        var instance = new GlModelInstanceCollection([
          new GlModelInstance(modelCollection.getModelBuffer(key), new GlColor(1.0, 0, 0)),
        ]);
        drawModels.add(instance);
      }

      return drawModels;
    }, false);

    preview.background = new GlColor(.8, .8, .8);
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

class TriangleSelector extends UiPanelTitled {
  UiInputInt _in_modelIndex;
  UiInputInt _in_triangleIndex;

  TriangleSelector(ILifetime lifetime) : super(lifetime) {
    _in_modelIndex = lifetime.resolve();
    _in_triangleIndex = lifetime.resolve();
  }

  void setOnValueChange(Function onValueChange){
    _in_modelIndex.onValueChange = (i) => onValueChange();
    _in_triangleIndex.onValueChange = (i) => onValueChange();
  }
  int getSelectedModelIndex() => _in_modelIndex.getValue();
  int getSelectedTriangleIndex() => _in_triangleIndex.getValue();

  @override
  void build() {
    super.build();
    changeTitle("Selection");
    _in_triangleIndex.changeLabel("Triangle index");
    _in_modelIndex.changeLabel("Model index");
    append(_in_modelIndex);
    append(_in_triangleIndex);
  }
}

class TriangleEditor extends UiPanelTitled {
  PointEditor _in_point1;
  PointEditor _in_point2;
  PointEditor _in_point3;

  TriangleEditor(ILifetime lifetime) : super(lifetime) {
    _in_point1 = lifetime.resolve();
    _in_point2 = lifetime.resolve();
    _in_point3 = lifetime.resolve();
  }

  void setOnValueChange(Function onValueChange) {
    _in_point1.setOnValueChange(onValueChange);
    _in_point2.setOnValueChange(onValueChange);
    _in_point3.setOnValueChange(onValueChange);
  }

  void setTriangle(GlTriangle t) {
    _in_point1.setValue(t.points[0]);
    _in_point2.setValue(t.points[1]);
    _in_point3.setValue(t.points[2]);
  }

  GlTriangle getPoint() {
    return GlTriangle([_in_point1.getValue(), _in_point2.getValue(), _in_point3.getValue()]);
  }

  @override
  void build() {
    super.build();
    changeTitle("Triangle");
    append(_in_point1);
    append(_in_point2);
    append(_in_point3);
  }
}

class PointEditor extends UiPanelTitled {
  UiInputDouble _in_x;
  UiInputDouble _in_y;
  UiInputDouble _in_z;
  UiInputDouble _in_tx;
  UiInputDouble _in_ty;

  PointEditor(ILifetime lifetime) : super(lifetime) {
    _in_x = lifetime.resolve();
    _in_y = lifetime.resolve();
    _in_z = lifetime.resolve();
    _in_tx = lifetime.resolve();
    _in_ty = lifetime.resolve();
  }

  void setOnValueChange(Function onValueChange){
    _in_x.onValueChange = (i) => onValueChange();
    _in_y.onValueChange = (i) => onValueChange();
    _in_z.onValueChange = (i) => onValueChange();
    _in_tx.onValueChange = (i) => onValueChange();
    _in_ty.onValueChange = (i) => onValueChange();
  }

  void setValue(GlPoint point) {
    _in_x.setValue(point.x);
    _in_y.setValue(point.y);
    _in_z.setValue(point.z);
    _in_tx.setValue(point.tx);
    _in_ty.setValue(point.ty);
  }

  GlPoint getValue() {
    return GlPoint(_in_x.getValue(), _in_y.getValue(), _in_z.getValue(), _in_tx.getValue(), _in_ty.getValue());
  }

  @override
  void build() {
    super.build();
    changeTitle("Point");
    _in_x.changeLabel("x");
    _in_y.changeLabel("y");
    _in_z.changeLabel("z");
    _in_tx.changeLabel("tx");
    _in_ty.changeLabel("ty");
    append(_in_x);
    append(_in_y);
    append(_in_z);
    append(_in_tx);
    append(_in_ty);
  }
}

GlModelInstanceCollection createXYZMark(GlRenderLayer layer) {
  GlModelBuffer xaxis = new GlAreaModel([
    new GlTriangle([
      new GlPoint(0.0, 0.0, 0.0),
      new GlPoint(2.0, 0.0, 0.0),
      new GlPoint(0.0, 1.0, 0.0),
    ]),
    new GlTriangle([
      new GlPoint(0.0, 0.0, 0.0),
      new GlPoint(0.0, 1.0, 0.0),
      new GlPoint(2.0, 0.0, 0.0),
    ]),
  ]).createBuffers(layer);

  GlModelBuffer yaxis = new GlAreaModel([
    new GlTriangle([
      new GlPoint(0.0, 0.0, 0.0),
      new GlPoint(0.0, 0.0, -2.0),
      new GlPoint(1.0, 0.0, 0.0),
    ]),
    new GlTriangle([
      new GlPoint(0.0, 0.0, 0.0),
      new GlPoint(1.0, 0.0, 0.0),
      new GlPoint(0.0, 0.0, -2.0),
    ]),
  ]).createBuffers(layer);

  GlModelBuffer zaxis = new GlAreaModel([
    new GlTriangle([
      new GlPoint(0.0, 0.0, 0.0),
      new GlPoint(0.0, 2.0, 0.0),
      new GlPoint(0.0, 0.0, -1.0),
    ]),
    new GlTriangle([
      new GlPoint(0.0, 0.0, 0.0),
      new GlPoint(0.0, 0.0, -1.0),
      new GlPoint(0.0, 2.0, 0.0),
    ]),
  ]).createBuffers(layer);
  return new GlModelInstanceCollection([new GlModelInstance(xaxis, new GlColor(1.0, 0.0, 0.0)), new GlModelInstance(yaxis, new GlColor(0.0, 0.0, 1.0)), new GlModelInstance(zaxis, new GlColor(0.0, 1.0, 0.0))]);
}

class RenderTexture {
  static const int textureSize = 256;
  RenderLayer layer;

  RenderTexture() {
    layer = new RenderLayer.withSize(textureSize, textureSize);
    layer.ctx.fillStyle = "#000";
    layer.ctx.fillRect(0, 0, textureSize, textureSize);
  }
  void drawModels(List<GlAreaModel> models, int selectedModel, int selectedTriangle) {
    int im = 0;
    for (var m in models) {
      _drawModel(m, im == selectedModel && selectedTriangle >= 0 ? selectedTriangle : -1);
      im++;
    }
  }

  void _drawModel(GlAreaModel model, int selectedTriangle) {
    var it = 0;
    for (var area in model.areas) {
      _drawTriangle(area, it == selectedTriangle);
      it++;
    }
  }

  void _drawTriangle(GlTriangle triangle, bool selected) {
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
