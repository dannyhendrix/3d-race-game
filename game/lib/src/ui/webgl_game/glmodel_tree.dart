part of webgl_game;

class GlModel_Tree{

  static const String _ModelTrunk = "tree_trunk";
  static const String _ModelLeaves = "tree_leaves";

  static const double scaleX = 20.0/1.0;
  static const double scaleY = 200.0/1.0;
  static const double scaleZ = 20.0/1.0;

  GlColor colorTrunk = new GlColor(1.0,0.7,0.6);
  GlColor colorLeaves = new GlColor(0.0,1.0,0.0);

  DoubleHelper h = new DoubleHelper(1.0,scaleY);
  DoubleHelper hLeaves = new DoubleHelper(0.7,scaleY);
  DoubleHelper hTrunk = new DoubleHelper(0.3,scaleY);

  //DoubleHelper d = new DoubleHelper(3.0,scaleZ);
  DoubleHelper dLeaves = new DoubleHelper(4.0,scaleZ);
  DoubleHelper dTrunk = new DoubleHelper(1.0,scaleZ);

  //DoubleHelper w = new DoubleHelper(3.0,scaleZ);
  DoubleHelper wLeaves = new DoubleHelper(4.0,scaleX);
  DoubleHelper wTrunk = new DoubleHelper(1.0,scaleX);

  GlModelInstanceCollection getModelInstance(GlModelCollection collection){
    return new GlModelInstanceCollection([
      new GlModelInstance(collection.getModelBuffer(_ModelLeaves), colorLeaves),
      new GlModelInstance(collection.getModelBuffer(_ModelTrunk), colorTrunk),
    ]);
  }
  GlModel loadModel(GlModelCollection collection){

    collection.loadModel(_ModelTrunk, new GlAreaModel([
      // top
      //new GlRectangle.withWD(-wTrunk.h, hTrunk.v, -dTrunk.h, wTrunk.v, dTrunk.v, false),
      new GlRectangle.withWD(-wTrunk.h,0.0, -dTrunk.h, wTrunk.v, dTrunk.v, true),
      //front
      new GlRectangle.withWH(-wTrunk.h,0.0, -dTrunk.h, wTrunk.v, hTrunk.v, false),
      //back
      new GlRectangle.withWH(-wTrunk.h,0.0, dTrunk.h, wTrunk.v, hTrunk.v, true),
      //left
      new GlRectangle.withHD(-wTrunk.h,0.0, -dTrunk.h, hTrunk.v, dTrunk.v, false),
      new GlRectangle.withHD(wTrunk.h,0.0, -dTrunk.h, hTrunk.v, dTrunk.v, true),
    ]));

    collection.loadModel(_ModelLeaves, new GlAreaModel([

      //bottom square
      //4 triangle to top
      new GlRectangle.withWD(-wLeaves.h, hTrunk.v, -dLeaves.h, wLeaves.v, dLeaves.v, true),

      new GlTriangle([
        new GlPoint(-wLeaves.h, hTrunk.v, -dLeaves.h),
        new GlPoint(0.0, h.v, 0.0),
        new GlPoint(wLeaves.h, hTrunk.v, -dLeaves.h),
      ]),
      new GlTriangle([
        new GlPoint(-wLeaves.h, hTrunk.v, dLeaves.h),
        new GlPoint(wLeaves.h, hTrunk.v, dLeaves.h),
        new GlPoint(0.0, h.v, 0.0),
      ]),
      new GlTriangle([
        new GlPoint(wLeaves.h, hTrunk.v, -dLeaves.h),
        new GlPoint(0.0, h.v, 0.0),
        new GlPoint(wLeaves.h, hTrunk.v, dLeaves.h),
      ]),
      new GlTriangle([
        new GlPoint(-wLeaves.h, hTrunk.v, -dLeaves.h),
        new GlPoint(-wLeaves.h, hTrunk.v, dLeaves.h),
        new GlPoint(0.0, h.v, 0.0),
      ]),
    ]));
  }
}