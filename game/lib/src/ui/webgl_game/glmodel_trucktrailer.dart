part of webgl_game;

class GlModel_TruckTrailer{

  static const String _ModelBody = "trucktrailer_body";
  static const String _ModelStripe = "trucktrailer_stripe";
  static const String _ModelWheel = "trucktrailer_wheel";


  // For now, use truck scale
  static const double sx = 50.0/1.0;
  static const double sy = 70.0/1.0;
  static const double sz = 40.0/1.0;

  GlColor colorWindows = new GlColor(0.2,0.2,0.2);
  GlColor color1 = new GlColor(1.0,1.0,1.0);
  GlColor color2 = new GlColor(0.5,0.5,0.5);

  DoubleHelper h = new DoubleHelper(1.0,sy);
  DoubleHelper hLoader = new DoubleHelper(0.3,sy);

  DoubleHelper d = new DoubleHelper(1.0,sz);

  DoubleHelper dStripeRoofLeft = new DoubleHelper(0.3,sz);
  DoubleHelper dStripeRoofMid = new DoubleHelper(0.4,sz);
  DoubleHelper dStripeRoofRight = new DoubleHelper(0.3,sz);

  DoubleHelper w = new DoubleHelper(2.0,sx);
  DoubleHelper wLoader = new DoubleHelper(0.5,sx);

  DoubleHelper wWheelOffsetRear = new DoubleHelper(0.3,sx);
  DoubleHelper wWheelOffsetRear2 = new DoubleHelper(0.6,sx);
  DoubleHelper dWheelOffsetIn = new DoubleHelper(0.1,sz);
  DoubleHelper hWheelOffsetIn = new DoubleHelper(0.1,sy);
  DoubleHelper wWheel = new DoubleHelper(0.2,sx);
  DoubleHelper dWheel = new DoubleHelper(0.4,sz);
  DoubleHelper hWheel = new DoubleHelper(0.2,sy);

  GlModelInstanceCollection getModelInstance(GlModelCollection collection, GlColor colorBase, GlColor colorStripe, GlColor colorWindow){

    GlMatrix wheelPositionRight = GlMatrix.translationMatrix(-w.h+wWheelOffsetRear.v,hWheelOffsetIn.v,-d.h+dWheelOffsetIn.v);
    GlMatrix wheelPositionRight2 = GlMatrix.translationMatrix(-w.h+wWheelOffsetRear2.v,hWheelOffsetIn.v,-d.h+dWheelOffsetIn.v);
    GlMatrix wheelPositionLeft =  GlMatrix.translationMatrix(-w.h+wWheelOffsetRear.v,hWheelOffsetIn.v,d.h-dWheelOffsetIn.v).multThis(GlMatrix.rotationYMatrix(Math.pi));
    GlMatrix wheelPositionLeft2 =  GlMatrix.translationMatrix(-w.h+wWheelOffsetRear2.v,hWheelOffsetIn.v,d.h-dWheelOffsetIn.v).multThis(GlMatrix.rotationYMatrix(Math.pi));

    var colorWheel = new GlColor(0.2,0.2,0.2);
    return new GlModelInstanceCollection([
      new GlModelInstance(collection.getModelBuffer(_ModelWheel), colorWheel, wheelPositionRight),
      new GlModelInstance(collection.getModelBuffer(_ModelWheel), colorWheel, wheelPositionRight2),
      new GlModelInstance(collection.getModelBuffer(_ModelWheel), colorWheel, wheelPositionLeft),
      new GlModelInstance(collection.getModelBuffer(_ModelWheel), colorWheel, wheelPositionLeft2),
      new GlModelInstance(collection.getModelBuffer(_ModelBody), colorBase),
      new GlModelInstance(collection.getModelBuffer(_ModelStripe), colorStripe),
    ]);
  }
  GlModel loadModel(GlModelCollection collection){
    collection.loadModel(_ModelBody, new GlAreaModel([
      //floor
      new GlRectangle.withWD(-w.h,0.0, -d.h, w.v-wLoader.v, d.v, true),
      new GlRectangle.withWD(w.h-wLoader.v,hLoader.v, -d.h, wLoader.v, d.v, true),
      //roof
      new GlRectangle.withWD(-w.h,h.v, d.h-dStripeRoofRight.v, w.v, dStripeRoofRight.v, false),
      new GlRectangle.withWD(-w.h,h.v, -d.h, w.v, dStripeRoofLeft.v, false),
      //front
      new GlRectangle.withHD(w.h,hLoader.v, -d.h, h.v-hLoader.v, d.v, true),
      new GlRectangle.withHD(w.h-wLoader.v,0.0, -d.h, hLoader.v, d.v, true),
      //rear
      new GlRectangle.withHD(-w.h,0.0, -d.h, h.v, d.v, false),
      //right side
      //bottom
      new GlRectangle.withWH(-w.h,0.0, d.h, w.v-wLoader.v, hLoader.v, true),
      new GlRectangle.withWH(-w.h,hLoader.v, d.h, w.v, h.v - hLoader.v, true),
      //left side
      //bottom
      new GlRectangle.withWH(-w.h,0.0, -d.h, w.v-wLoader.v, hLoader.v, false),
      new GlRectangle.withWH(-w.h,hLoader.v, -d.h, w.v, h.v - hLoader.v, false),
    ]));

    collection.loadModel(_ModelStripe, new GlAreaModel([
      //roof
      new GlRectangle.withWD(-w.h,h.v, -d.h+dStripeRoofLeft.v, w.v, dStripeRoofMid.v, false),
    ]));

    collection.loadModel(_ModelWheel, new GlCube.fromTopCenter(0.0,0.0,0.0,wWheel.v,hWheel.v,dWheel.v));
  }
}