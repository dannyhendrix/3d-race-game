part of webgl;

class GlModelBuffer{
  Buffer vertexBuffer;
  Buffer normalsBuffer;
  Buffer textureBuffer;
  int numberOfTriangles;
  GlModelBuffer(this.vertexBuffer, this.normalsBuffer, this.textureBuffer, this.numberOfTriangles);
}
class GlModelInstance{
  GlModelBuffer modelBuffer;
  GlColor color;
  GlMatrix _transformMatrix;
  String texture;
  GlMatrix CreateTransformMatrix() => _transformMatrix;
  GlModelInstance(this.modelBuffer, this.color, [this._transformMatrix, this.texture]){
    if(_transformMatrix == null){
      _transformMatrix = GlMatrix.identityMatrix();
    }
  }
}

class GlModelInstanceCollection{
  List<GlModelInstance> modelInstances;
  GlMatrix _transformMatrix;
  GlMatrix CreateTransformMatrix() => _transformMatrix;
  GlModelInstanceCollection([List<GlModelInstance> modelInstances, this._transformMatrix]): modelInstances = modelInstances ?? []{
    if(_transformMatrix == null){
      _transformMatrix = GlMatrix.identityMatrix();
    }
  }
  void move(GlMatrix m){
    _transformMatrix = _transformMatrix.multThis(m);
  }
}

class GlColor{
  double r,g,b,a;
  GlColor([this.r=1.0,this.g=1.0,this.b=1.0,this.a=1.0]);
}