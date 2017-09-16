part of webgl;

//json -> GlModel -> Float32List
abstract class GlModelPart{
  List<double> toDoubleVertex();
  int getNumberOfTriangles() => 0;
}

class GlPoint extends GlModelPart{
  double x,y,z;
  GlPoint([this.x = 0.0, this.y = 0.0, this.z=0.0]);
  List<double> toDoubleVertex() => [x,y,z];
}

class GlTriangle extends GlModelPart{
  List<GlPoint> points;
  GlTriangle([List<GlPoint> points]): points = points ?? [];
  List<double> toDoubleVertex(){
    List<double> result = [];
    for(GlPoint o in points)result.addAll(o.toDoubleVertex());
    return result;
  }
  int getNumberOfTriangles() => 1;
  List<double> toLightVertex(){
    //TODO
    bool clockwise = true;
    double valX = 0.0;
    double valY = 0.0;
    double valZ = 0.0;
    if(clockwise) return [-valX,-valY,-valZ];
  }
}

class GlArea extends GlModelPart{
  List<GlTriangle> triangles;
  GlArea([List<GlTriangle> triangles]): triangles = triangles ?? [];
  void addTriangle(GlTriangle triangle) => triangles.add(triangle);
  List<double> toDoubleVertex(){
    List<double> result = [];
    for(GlTriangle o in triangles)result.addAll(o.toDoubleVertex());
    return result;
  }
  int getNumberOfTriangles() => triangles.length;
}

class GlModel{
  List<GlArea> areas;
  GlModel([List<GlArea> areas]): areas = areas ?? [];
  GlModelBuffer createBuffers(GlRenderLayer layer){
    Buffer vertexBuffer = _loadVertexInBuffer(layer);
    Buffer colorBuffer = _loadColorInBuffer(layer);
    return new GlModelBuffer(vertexBuffer, colorBuffer, _getNumberOfTriangles());
  }
  void addArea(GlArea area) => areas.add(area);
  Buffer _loadVertexInBuffer(GlRenderLayer layer){
    Buffer buffer = layer.ctx.createBuffer();
    layer.ctx.bindBuffer(ARRAY_BUFFER, buffer);
    layer.ctx.bufferData(ARRAY_BUFFER, new Float32List.fromList(_toDoubleVertex()), STATIC_DRAW);
    return buffer;
  }
  Buffer _loadColorInBuffer(GlRenderLayer layer){
    Buffer buffer = layer.ctx.createBuffer();
    layer.ctx.bindBuffer(ARRAY_BUFFER, buffer);
    layer.ctx.bufferData(ARRAY_BUFFER, new Float32List.fromList([1.0,1.0,1.0,1.0]), STATIC_DRAW);
    return buffer;
  }
  int _getNumberOfTriangles(){
    int total = 0;
    for(GlArea area in areas) total += area.getNumberOfTriangles();
    return total;
  }
  List<double> _toDoubleVertex(){
    List<double> result = [];
    for(GlArea area in areas) result.addAll(area.toDoubleVertex());
    return result;
  }
}

class GlCube extends GlModel{
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

class GlRectangle extends GlArea{
  GlRectangle.withWH(double x, double y, double z, double w, double h, [bool facingFront=true]){

    /**
     * clockwise facing triangles (facing front)
     *      /\           ---->
     *    /   \          |  /
     *    <----          |/
     *
     * counter clockwise facing triangles (facing back)
     *      /\           <----
     *    /   \          |  /
     *    ---->          |/
     */

    if(facingFront)
    {
      addTriangle(new GlTriangle([
        new GlPoint(x, y, z),
        new GlPoint(x + w, y, z),
        new GlPoint(x, y + h, z)
      ]));
      addTriangle(new GlTriangle([
        new GlPoint(x + w, y, z),
        new GlPoint(x + w, y + h, z),
        new GlPoint(x, y + h, z)
      ]));
    }else{
      addTriangle(new GlTriangle([
        new GlPoint(x, y, z),
        new GlPoint(x, y + h, z),
        new GlPoint(x + w, y, z),
      ]));
      addTriangle(new GlTriangle([
        new GlPoint(x + w, y, z),
        new GlPoint(x, y + h, z),
        new GlPoint(x + w, y + h, z),
      ]));
    }
  }
  GlRectangle.withWD(double x, double y, double z, double w, double d, [bool facingFront=true]){
    if(facingFront)
    {
      addTriangle(new GlTriangle([
        new GlPoint(x, y, z),
        new GlPoint(x + w, y, z),
        new GlPoint(x, y, z+d)
      ]));
      addTriangle(new GlTriangle([
        new GlPoint(x + w, y, z),
        new GlPoint(x + w, y, z+d),
        new GlPoint(x, y, z+d)
      ]));
    }else{
      addTriangle(new GlTriangle([
        new GlPoint(x, y, z),
        new GlPoint(x, y, z+d),
        new GlPoint(x + w, y, z),
      ]));
      addTriangle(new GlTriangle([
        new GlPoint(x + w, y, z),
        new GlPoint(x, y, z+d),
        new GlPoint(x + w, y, z+d),
      ]));
    }
  }
  GlRectangle.withHD(double x, double y, double z, double h, double d, [bool facingFront=true]){
    if(facingFront)
    {
      addTriangle(new GlTriangle([
        new GlPoint(x, y, z),
        new GlPoint(x, y+h, z),
        new GlPoint(x, y, z+d)
      ]));
      addTriangle(new GlTriangle([
        new GlPoint(x, y+h, z),
        new GlPoint(x, y+h, z+d),
        new GlPoint(x, y, z+d)
      ]));
    }else{
      addTriangle(new GlTriangle([
        new GlPoint(x, y, z),
        new GlPoint(x, y, z+d),
        new GlPoint(x, y+h, z),
      ]));
      addTriangle(new GlTriangle([
        new GlPoint(x, y+h, z),
        new GlPoint(x, y, z+d),
        new GlPoint(x, y+h, z+d),
      ]));
    }
  }
}

class GlModelBuffer{
  Buffer vertexBuffer;
  Buffer colorBuffer;
  int numberOfTriangles;
  GlModelBuffer(this.vertexBuffer, this.colorBuffer, this.numberOfTriangles);
}
class GlModelInstance{
  GlModelBuffer modelBuffer;
  double x,y,z;
  double rx=0.0,ry=0.0,rz=0.0;
  double r=1.0,g=1.0,b=1.0,a=1.0;
  GlModelInstance(this.modelBuffer, [this.x=0.0,this.y=0.0,this.z=0.0]);
}