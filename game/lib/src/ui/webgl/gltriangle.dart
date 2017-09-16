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
  GlCube(double w, double h, double d){
    addArea(new GlRectangle.withWH(0.0,0.0,0.0,w,h, true));
    addArea(new GlRectangle.withWH(0.0,0.0,-d,w,h, false));
    addArea(new GlRectangle.withHD(0.0,0.0,-d,h,d, false));
    addArea(new GlRectangle.withHD(w,0.0,-d,h,d, true));
    addArea(new GlRectangle.withWD(0.0,h,-d,w,d, false));
    addArea(new GlRectangle.withWD(0.0,0.0,-d,w,d, true));
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
//TODO: test
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
//TODO: test
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