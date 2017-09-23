part of webgl;

//json -> GlModel -> Float32List
abstract class GlModelPart{
  List<double> toDoubleVertex();
  int getNumberOfTriangles() => 0;
  List<double> toNormalsVertex();
}

class GlPoint extends GlModelPart{
  double x,y,z;
  GlPoint([this.x = 0.0, this.y = 0.0, this.z=0.0]);
  List<double> toDoubleVertex() => [x,y,z];
  List<double> toNormalsVertex() => [0.0,0.0,0.0];
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
  List<double> toNormalsVertex(){
    /*
    double val = 0.0;
    var i = 0;
    var p = points[i];
    for(int i = 1; i < points.length; i++){
      var p2 = points[i];
      val += (p2.x-p.x)*(p2.y+p.y);
      p = p2;
    }
    bool clockwise = val > 0;
    */
/*
    var Vx =  points[1].x - points[0].x;
    var Vy =  points[1].y - points[0].y;
    var Vz =  points[1].z - points[0].z;
    var Wx =  points[2].x - points[0].x;
    var Wy =  points[2].y - points[0].y;
    var Wz =  points[2].z - points[0].z;
    var Nx=((Vy*Wz)-(Vz*Wy));
    var Ny=((Vz*Wx)-(Vx*Wz));
    var Nz=((Vx*Wy)-(Vy*Wx));

    var normalX=Nx/(Nx.abs()+Ny.abs()+Nz.abs());
    var normalY=Ny/(Nx.abs()+Ny.abs()+Nz.abs());
    var normalZ=Nz/(Nx.abs()+Ny.abs()+Nz.abs());
*/
    double x1 = points[0].x;
    double x2 = points[1].x;
    double x3 = points[2].x;
    double y1 = points[0].y;
    double y2 = points[1].y;
    double y3 = points[2].y;
    double z1 = points[0].z;
    double z2 = points[1].z;
    double z3 = points[2].z;
    double normalX = (y2-y1)*(z3-z1)-(y3-y1)*(z2-z1);
    double normalY = (z2-z1)*(x3-x1)-(x2-x1)*(z3-z1);
    double normalZ = (x2-x1)*(y3-y1)-(x3-x1)*(y2-y1);
    return [
      normalX,normalY,normalZ,
      normalX,normalY,normalZ,
      normalX,normalY,normalZ
    ];

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
  List<double> toNormalsVertex(){
    List<double> result = [];
    for(GlTriangle o in triangles)result.addAll(o.toNormalsVertex());
    return result;
  }
  int getNumberOfTriangles() => triangles.length;
}

class GlModel{
  List<GlArea> areas;
  GlModel([List<GlArea> areas]): areas = areas ?? [];
  GlModelBuffer createBuffers(GlRenderLayer layer){
    Buffer vertexBuffer = _loadVertexInBuffer(layer);
    Buffer normalsBuffer = _loadNormalsInBuffer(layer);
    return new GlModelBuffer(vertexBuffer, normalsBuffer, _getNumberOfTriangles());
  }
  void addArea(GlArea area) => areas.add(area);
  Buffer _loadVertexInBuffer(GlRenderLayer layer){
    Buffer buffer = layer.ctx.createBuffer();
    layer.ctx.bindBuffer(ARRAY_BUFFER, buffer);
    layer.ctx.bufferData(ARRAY_BUFFER, new Float32List.fromList(_toDoubleVertex()), STATIC_DRAW);
    return buffer;
  }
  Buffer _loadNormalsInBuffer(GlRenderLayer layer){
    Buffer buffer = layer.ctx.createBuffer();
    layer.ctx.bindBuffer(ARRAY_BUFFER, buffer);
    layer.ctx.bufferData(ARRAY_BUFFER, new Float32List.fromList(_toNormalsVertex()), STATIC_DRAW);
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
  List<double> _toNormalsVertex(){
    List<double> result = [];
    for(GlArea area in areas) result.addAll(area.toNormalsVertex());
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
  Buffer normalsBuffer;
  int numberOfTriangles;
  GlModelBuffer(this.vertexBuffer, this.normalsBuffer, this.numberOfTriangles);
}
class GlModelInstance{
  GlModelBuffer modelBuffer;
  GlColor color;
  double x,y,z;
  double rx=0.0,ry=0.0,rz=0.0;
  double r=1.0,g=1.0,b=1.0,a=1.0;
  GlModelInstance(this.modelBuffer, this.color, [this.x=0.0,this.y=0.0,this.z=0.0]);
}
class GlModelInstanceCollection{
  List<GlModelInstance> modelInstances;
  GlModelInstanceCollection([List<GlModelInstance> modelInstances]): modelInstances = modelInstances ?? [];
}
class GlColor{
  double r,g,b,a;
  GlColor([this.r=1.0,this.g=1.0,this.b=1.0,this.a=1.0]);
}