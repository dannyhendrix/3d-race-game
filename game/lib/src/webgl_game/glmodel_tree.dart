part of webgl_game;

class GlModel_Tree{

  static const String _ModelTrunk = "tree_trunk";
  static const String _ModelLeaves = "tree_leaves";

  static const double scaleX = 20.0/1.0;
  static const double scaleY = 200.0/1.0;
  static const double scaleZ = 20.0/1.0;

  GlColor colorTrunk = new GlColor(1.0,0.7,0.6);
  GlColor colorLeaves = new GlColor(0.0,1.0,0.0);

  DoubleHelper h = new DoubleHelper.scaled(scaleY,1.0);
  DoubleHelper hLeaves = new DoubleHelper.scaled(scaleY,0.7);
  DoubleHelper hTrunk = new DoubleHelper.scaled(scaleY,0.3);

  //DoubleHelper d = new DoubleHelper.scaled(scaleZ,3.0);
  DoubleHelper dLeaves = new DoubleHelper.scaled(scaleZ,4.0);
  DoubleHelper dTrunk = new DoubleHelper.scaled(scaleZ,1.0);

  //DoubleHelper w = new DoubleHelper.scaled(scaleZ,3.0);
  DoubleHelper wLeaves = new DoubleHelper.scaled(scaleX,4.0);
  DoubleHelper wTrunk = new DoubleHelper.scaled(scaleX,1.0);

  GlModelInstanceCollection getModelInstance(GlModelCollection collection){
    return new GlModelInstanceCollection([
      new GlModelInstance(collection.getModelBuffer(_ModelLeaves), colorLeaves, null, "tree"),
      new GlModelInstance(collection.getModelBuffer(_ModelTrunk), colorTrunk, null, "tree"),
    ]);
  }
  GlModel loadModel(GlModelCollection collection){

    collection.loadModel(_ModelTrunk, new GlAreaModel([
      // top
      //new GlRectangle.withWD(-wTrunk.h, hTrunk.v, -dTrunk.h, wTrunk.v, dTrunk.v, false),
      new GlRectangle.withWD(-wTrunk.h,0.0, -dTrunk.h, wTrunk.v, dTrunk.v, true, 100,64),
      //front
      new GlRectangle.withWH(-wTrunk.h,0.0, -dTrunk.h, wTrunk.v, hTrunk.v, false, 100,0),
      //back
      new GlRectangle.withWH(-wTrunk.h,0.0, dTrunk.h, wTrunk.v, hTrunk.v, true, 100,0),
      //left
      new GlRectangle.withHD(-wTrunk.h,0.0, -dTrunk.h, hTrunk.v, dTrunk.v, false, 100,0),
      new GlRectangle.withHD(wTrunk.h,0.0, -dTrunk.h, hTrunk.v, dTrunk.v, true, 100,0),
    ]));

    collection.loadModel(_ModelLeaves, new GlAreaModel([

      //bottom square
      //4 triangle to top
      new GlRectangle.withWD(-wLeaves.h, hTrunk.v, -dLeaves.h, wLeaves.v, dLeaves.v, true, 0,150),

      new GlTriangle([
        new GlPoint(-wLeaves.h, hTrunk.v, -dLeaves.h,0,146),
        new GlPoint(0.0, h.v, 0.0,40,0),
        new GlPoint(wLeaves.h, hTrunk.v, -dLeaves.h,80,146),
      ]),
      new GlTriangle([
        new GlPoint(-wLeaves.h, hTrunk.v, dLeaves.h,0,146),
        new GlPoint(wLeaves.h, hTrunk.v, dLeaves.h,80,146),
        new GlPoint(0.0, h.v, 0.0,40,0),
      ]),
      new GlTriangle([
        new GlPoint(wLeaves.h, hTrunk.v, -dLeaves.h,0,146),
        new GlPoint(0.0, h.v, 0.0,40,0),
        new GlPoint(wLeaves.h, hTrunk.v, dLeaves.h,80,146),
      ]),
      new GlTriangle([
        new GlPoint(-wLeaves.h, hTrunk.v, -dLeaves.h,0,146),
        new GlPoint(-wLeaves.h, hTrunk.v, dLeaves.h,80,146),
        new GlPoint(0.0, h.v, 0.0,40,0),
      ]),
    ]));
  }
}