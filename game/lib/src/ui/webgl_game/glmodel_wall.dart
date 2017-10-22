part of webgl_game;

class GlModel_Wall{

  static const String _Model = "wall";

  GlModelInstanceCollection getModelInstance(GlModelCollection collection, double scaleX, double scaleY, double scaleZ){

    GlMatrix transform = GlMatrix.scalingMatrix(scaleX, scaleY, scaleZ);

    var color = new GlColor(1.0,1.0,1.0);
    return new GlModelInstanceCollection([
      new GlModelInstance(collection.getModelBuffer(_Model), color, transform),
    ]);
  }
  GlModel loadModel(GlModelCollection collection){
    collection.loadModel(_Model, new GlCube.fromTopCenter(0.0,0.0,0.0,1.0,1.0,1.0));
  }
}