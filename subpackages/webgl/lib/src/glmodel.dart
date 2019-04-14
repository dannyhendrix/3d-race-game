part of webgl;

//json -> GlModel -> Float32List
abstract class GlModelPart{
  List<double> toDoubleVertex();
  int getNumberOfTriangles() => 0;
  List<double> toNormalsVertex();
}

abstract class GlModel{
  GlModelBuffer createBuffers(GlRenderLayer layer);

  Buffer loadInBuffer(List<double> data, GlRenderLayer layer){
    Buffer buffer = layer.ctx.createBuffer();
    layer.ctx.bindBuffer(WebGL.ARRAY_BUFFER, buffer);
    layer.ctx.bufferData(WebGL.ARRAY_BUFFER, new Float32List.fromList(data), WebGL.STATIC_DRAW);
    return buffer;
  }
}

class GlJsonModel extends GlModel{
  List<double> model;
  List<double> normals;
  int numberOfTriangles;
  GlJsonModel(Map json){
    model = json["model"];
    normals = json["normals"];
    numberOfTriangles = model.length~/9;
  }
  GlModelBuffer createBuffers(GlRenderLayer layer){
    Buffer vertexBuffer = loadInBuffer(model,layer);
    Buffer normalsBuffer = loadInBuffer(normals,layer);
    return new GlModelBuffer(vertexBuffer, normalsBuffer, numberOfTriangles);
  }
}

class GlAreaModel extends GlModel{
  List<GlModelPart> areas;
  GlAreaModel([List<GlModelPart> areas]): areas = areas ?? [];
  GlModelBuffer createBuffers(GlRenderLayer layer){
    Buffer vertexBuffer = loadInBuffer(_toDoubleVertex(),layer);
    Buffer normalsBuffer = loadInBuffer(_toNormalsVertex(), layer);
    return new GlModelBuffer(vertexBuffer, normalsBuffer, _getNumberOfTriangles());
  }
  void addArea(GlModelPart area) => areas.add(area);

  int _getNumberOfTriangles(){
    int total = 0;
    for(GlModelPart area in areas) total += area.getNumberOfTriangles();
    return total;
  }
  List<double> _toDoubleVertex(){
    List<double> result = [];
    for(GlModelPart area in areas) result.addAll(area.toDoubleVertex());
    return result;
  }
  List<double> _toNormalsVertex(){
    List<double> result = [];
    for(GlModelPart area in areas) result.addAll(area.toNormalsVertex());
    return result;
  }
}

class GlCube extends GlAreaModel{
  GlCube.fromTopCenter(double x, double y, double z, double w, double h, double d){
    double hw = w/2;
    double hh = h/2;
    double hd = d/2;
    addArea(new GlRectangle.withWH(x-hw,  y-hh,  z+hd,  w,h, true));
    addArea(new GlRectangle.withWH(x-hw,  y-hh,  z+hd-d,w,h, false));
    addArea(new GlRectangle.withHD(x-hw,  y-hh,  z+hd-d,h,d, false));
    addArea(new GlRectangle.withHD(x-hw+w,y-hh,  z+hd-d,h,d, true));
    addArea(new GlRectangle.withWD(x-hw,  y-hh+h,z+hd-d,w,d, false));
    addArea(new GlRectangle.withWD(x-hw,  y-hh,  z+hd-d,w,d, true));
  }
  GlCube.fromTopLeft(double x, double y, double z, double w, double h, double d){
    addArea(new GlRectangle.withWH(x,y,z,w,h, true));
    addArea(new GlRectangle.withWH(x,y,z-d,w,h, false));
    addArea(new GlRectangle.withHD(x,y,z-d,h,d, false));
    addArea(new GlRectangle.withHD(x+w,y,z-d,h,d, true));
    addArea(new GlRectangle.withWD(x,y+h,z-d,w,d, false));
    addArea(new GlRectangle.withWD(x,y,z-d,w,d, true));
  }
}
