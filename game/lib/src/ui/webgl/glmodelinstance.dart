part of webgl;

class GlModelBuffer{
  Buffer vertexBuffer;
  Buffer normalsBuffer;
  int numberOfTriangles;
  GlModelBuffer(this.vertexBuffer, this.normalsBuffer, this.numberOfTriangles);
}
class GlModelInstance{
  GlModelBuffer modelBuffer;
  GlColor color;
  GlMatrix transformMatrix;//TODO: use this matrix to translate, rotate and scale objects
  GlModelInstance(this.modelBuffer, this.color);
}

class GlModelInstanceCollection{
  List<GlModelInstance> modelInstances;
  double x,y,z;
  double rx=0.0,ry=0.0,rz=0.0;
  GlMatrix transformMatrix;//TODO: use this matrix to translate, rotate and scale object collections (and remove x,y,z,rx,ry,rz
  GlModelInstanceCollection([List<GlModelInstance> modelInstances, this.x=0.0,this.y=0.0,this.z=0.0]): modelInstances = modelInstances ?? [];
}

class GlColor{
  double r,g,b,a;
  GlColor([this.r=1.0,this.g=1.0,this.b=1.0,this.a=1.0]);
}