part of webgl_game;

class GlModel_Wall{

  static const String _Model = "wall";

  GlModelInstanceCollection getModelInstance(GlModelCollection collection, double scaleX, double scaleY, double scaleZ, [GlColor color = null]){

    GlMatrix transform = GlMatrix.scalingMatrix(scaleX, scaleY, scaleZ);

    color ??= new GlColor(1.0,1.0,1.0);
    return new GlModelInstanceCollection([
      new GlModelInstance(collection.getModelBuffer(_Model), color, transform/*, "wall"*/),
    ]);
  }
  GlModel loadModel(GlModelCollection collection){
    //collection.loadModel(_Model, new GlCube.fromTopCenter(0.0,0.0,0.0,1.0,1.0,1.0));
    double w = 1.0;
    double hw = w/2;
    double h = 1.0;
    //double hh = w/2;
    double d = 1.0;
    double hd = w/2;
    collection.loadModel(_Model, new GlAreaModel([
      new GlRectangle.withWH(-hw,  0.0,  hd,  w,h, true,0,0),
      new GlRectangle.withWH(-hw,  0.0,  hd-d,w,h, false,0,0),
      new GlRectangle.withHD(-hw,  0.0,  hd-d,h,d, false,0,0),
      new GlRectangle.withHD(-hw+w,0.0,  hd-d,h,d, true,0,0),
      new GlRectangle.withWD(-hw,  h,    hd-d,w,d, false,0,0),
      new GlRectangle.withWD(-hw,  0.0,  hd-d,w,d, true,0,0)
    ]));

  }
}