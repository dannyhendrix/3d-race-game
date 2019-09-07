part of webgl;

class GlPoint extends GlModelPart{
  double x,y,z;
  double tx, ty;
  GlPoint([this.x = 0.0, this.y = 0.0, this.z=0.0, this.tx = 0.0, this.ty=0.0]);
  List<double> toDoubleVertex() => [x,y,z];
  List<double> toNormalsVertex() => [0.0,0.0,0.0];
  List<double> toTextureVertex(double textureSize) => [tx/textureSize,ty/textureSize];
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

  List<double> toTextureVertex(double textureSize){
    List<double> result = [];
    for(GlPoint o in points)result.addAll(o.toTextureVertex(textureSize));
    return result;
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
  List<double> toTextureVertex(double textureSize){
    List<double> result = [];
    for(GlTriangle o in triangles)result.addAll(o.toTextureVertex(textureSize));
    return result;
  }
  int getNumberOfTriangles() => triangles.length;
}

class GlRectangle extends GlArea{
  GlRectangle.withWH(double x, double y, double z, double w, double h, [bool facingFront=true, double toffsetx=0.0, double toffsety=0.0]){

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
    var tx1 = toffsetx;
    var tx2 = (toffsetx+w);
    var ty2 = toffsety;//y is reversed. in texture the top is 0
    var ty1 = (toffsety+h);

    if(facingFront)
    {
      addTriangle(new GlTriangle([
        new GlPoint(x, y, z, tx1, ty1),
        new GlPoint(x + w, y, z, tx2, ty1),
        new GlPoint(x, y + h, z, tx1, ty2)
      ]));
      addTriangle(new GlTriangle([
        new GlPoint(x + w, y, z, tx2, ty1),
        new GlPoint(x + w, y + h, z, tx2, ty2),
        new GlPoint(x, y + h, z, tx1, ty2)
      ]));
    }else{
      // reverse texture x
      var t = ty1;
      ty1 = ty2;
      ty2 = t;
      addTriangle(new GlTriangle([
        new GlPoint(x, y, z, tx1, ty1),
        new GlPoint(x, y + h, z, tx1, ty2),
        new GlPoint(x + w, y, z, tx2, ty1),
      ]));
      addTriangle(new GlTriangle([
        new GlPoint(x + w, y, z, tx2, ty1),
        new GlPoint(x, y + h, z, tx1, ty2),
        new GlPoint(x + w, y + h, z, tx2, ty2),
      ]));
    }
  }
  GlRectangle.withWD(double x, double y, double z, double w, double d, [bool facingFront=true, double toffsetx=0.0, double toffsety=0.0]){
    var tx2 = toffsetx;
    var tx1 = (toffsetx+w);
    var ty1 = toffsety;
    var ty2 = (toffsety+d);
    if(facingFront)
    {
      addTriangle(new GlTriangle([
        new GlPoint(x, y, z, tx1, ty1),
        new GlPoint(x + w, y, z, tx2, ty1),
        new GlPoint(x, y, z+d, tx1, ty2)
      ]));
      addTriangle(new GlTriangle([
        new GlPoint(x + w, y, z, tx2, ty1),
        new GlPoint(x + w, y, z+d, tx2, ty2),
        new GlPoint(x, y, z+d, tx1, ty2)
      ]));
    }else{
      var t = ty1;
      ty1 = ty2;
      ty2 = t;
      addTriangle(new GlTriangle([
        new GlPoint(x, y, z, tx1,ty1),
        new GlPoint(x, y, z+d,tx1,ty2),
        new GlPoint(x + w, y, z,tx2,ty1),
      ]));
      addTriangle(new GlTriangle([
        new GlPoint(x + w, y, z, tx2,ty1),
        new GlPoint(x, y, z+d, tx1,ty2),
        new GlPoint(x + w, y, z+d, tx2,ty2),
      ]));
    }
  }
  GlRectangle.withHD(double x, double y, double z, double h, double d, [bool facingFront=true, double toffsetx=0.0, double toffsety=0.0]){
    var tx2 = toffsetx;
    var tx1 = (toffsetx+d);
    var ty2 = toffsety;
    var ty1 = (toffsety+h);
    if(facingFront)
    {
      addTriangle(new GlTriangle([
        new GlPoint(x, y, z, tx1, ty1),
        new GlPoint(x, y+h, z, tx1, ty2),
        new GlPoint(x, y, z+d, tx2, ty1)
      ]));
      addTriangle(new GlTriangle([
        new GlPoint(x, y+h, z, tx1, ty2),
        new GlPoint(x, y+h, z+d, tx2, ty2),
        new GlPoint(x, y, z+d, tx2, ty1)
      ]));
    }else{
      // reverse texture x
      var t = ty1;
      ty1 = ty2;
      ty2 = t;
      addTriangle(new GlTriangle([
        new GlPoint(x, y, z, tx1, ty1),
        new GlPoint(x, y, z+d, tx2, ty1),
        new GlPoint(x, y+h, z, tx1, ty2),
      ]));
      addTriangle(new GlTriangle([
        new GlPoint(x, y+h, z, tx1, ty2),
        new GlPoint(x, y, z+d, tx2, ty1),
        new GlPoint(x, y+h, z+d, tx2, ty2),
      ]));
    }
  }
}