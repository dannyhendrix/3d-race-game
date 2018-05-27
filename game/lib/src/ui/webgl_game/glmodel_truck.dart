part of webgl_game;

class GlModel_Truck{

  static const String _ModelBody = "truck_body";
  static const String _ModelStripe = "truck_stripe";
  static const String _ModelWindows = "truck_windows";
  static const String _ModelWheel = "truck_wheel";

  static const double sx = 50.0/1.0;
  static const double sy = 70.0/1.0;
  static const double sz = 40.0/1.0;

  GlColor colorWindows = new GlColor(0.2,0.2,0.2);
  GlColor color1 = new GlColor(1.0,1.0,1.0);
  GlColor color2 = new GlColor(0.5,0.5,0.5);

  DoubleHelper h = new DoubleHelper(1.0,sy);
  DoubleHelper hLoader = new DoubleHelper(0.3,sy);
  DoubleHelper hCabin = new DoubleHelper(0.6,sy);
  DoubleHelper hWindow = new DoubleHelper(0.4,sy);

  DoubleHelper d = new DoubleHelper(1.0,sz);
  DoubleHelper dRoof = new DoubleHelper(0.8,sz);
  DoubleHelper dWindow = new DoubleHelper(0.1,sz);

  DoubleHelper dStripeLeft = new DoubleHelper(0.3,sz);
  DoubleHelper dStripeMid = new DoubleHelper(0.4,sz);
  DoubleHelper dStripeRight = new DoubleHelper(0.3,sz);

  DoubleHelper dStripeRoofLeft = new DoubleHelper(0.2,sz);
  DoubleHelper dStripeRoofMid = new DoubleHelper(0.4,sz);
  DoubleHelper dStripeRoofRight = new DoubleHelper(0.2,sz);

  DoubleHelper w = new DoubleHelper(1.0,sx);
  DoubleHelper wCabin = new DoubleHelper(0.5,sx);
  DoubleHelper wRoof = new DoubleHelper(0.4,sx);
  DoubleHelper wLoader = new DoubleHelper(0.5,sx);
  DoubleHelper wWindowFront = new DoubleHelper(0.1,sx);

  DoubleHelper wWheelOffsetRear = new DoubleHelper(0.2,sx);
  DoubleHelper wWheelOffsetFront = new DoubleHelper(0.2,sx);
  DoubleHelper dWheelOffsetIn = new DoubleHelper(0.1,sz);
  DoubleHelper hWheelOffsetIn = new DoubleHelper(0.1,sy);
  DoubleHelper wWheel = new DoubleHelper(0.2,sx);
  DoubleHelper dWheel = new DoubleHelper(0.4,sz);
  DoubleHelper hWheel = new DoubleHelper(0.2,sy);

  GlModelInstanceCollection getModelInstance(GlModelCollection collection, GlColor colorBase, GlColor colorStripe, GlColor colorWindow){

    GlMatrix wheelPositionFrontRight = GlMatrix.translationMatrix(w.h-wWheelOffsetFront.v,hWheelOffsetIn.v,-d.h+dWheelOffsetIn.v);
    GlMatrix wheelPositionRearRight = GlMatrix.translationMatrix(-w.h+wWheelOffsetRear.v,hWheelOffsetIn.v,-d.h+dWheelOffsetIn.v);
    GlMatrix wheelPositionFrontLeft =  GlMatrix.translationMatrix(w.h-wWheelOffsetFront.v,hWheelOffsetIn.v,d.h-dWheelOffsetIn.v).multThis(GlMatrix.rotationYMatrix(Math.PI));
    GlMatrix wheelPositionRearLeft = GlMatrix.translationMatrix(-w.h+wWheelOffsetRear.v,hWheelOffsetIn.v,d.h-dWheelOffsetIn.v).multThis(GlMatrix.rotationYMatrix(Math.PI));

    var colorWheel = new GlColor(0.2,0.2,0.2);
    return new GlModelInstanceCollection([
      new GlModelInstance(collection.getModelBuffer(_ModelWheel), colorWheel, wheelPositionFrontRight),
      new GlModelInstance(collection.getModelBuffer(_ModelWheel), colorWheel, wheelPositionFrontLeft),
      new GlModelInstance(collection.getModelBuffer(_ModelWheel), colorWheel, wheelPositionRearRight),
      new GlModelInstance(collection.getModelBuffer(_ModelWheel), colorWheel, wheelPositionRearLeft),
      new GlModelInstance(collection.getModelBuffer(_ModelBody), colorBase),
      new GlModelInstance(collection.getModelBuffer(_ModelStripe), colorStripe),
      new GlModelInstance(collection.getModelBuffer(_ModelWindows), colorWindow),
    ]);
  }
  GlModel loadModel(GlModelCollection collection){
    collection.loadModel(_ModelBody, new GlAreaModel([
      //floor
      new GlRectangle.withWD(-w.h,0.0, -d.h, w.v, d.v, true),
      //loader top
      new GlRectangle.withWD(-w.h,hLoader.v, -d.h, wLoader.v, d.v, false),
      //roof
      new GlRectangle.withWD(w.h-wCabin.v,h.v, d.h-dWindow.v-dStripeRoofRight.v, wRoof.v, dStripeRoofRight.v, false),
      new GlRectangle.withWD(w.h-wCabin.v,h.v, -d.h+dWindow.v, wRoof.v, dStripeRoofLeft.v, false),
      //front
      new GlRectangle.withHD(w.h,0.0, -d.h, hCabin.v, d.v, true),
      //rear
      new GlRectangle.withHD(-w.h,0.0, -d.h, hLoader.v, d.v, false),
      //TopCabinRear
      new GlTriangle([
        new GlPoint(w.h-wCabin.v, hCabin.v, d.h),
        new GlPoint(w.h-wCabin.v, h.v, d.h-dWindow.v),
        new GlPoint(w.h-wCabin.v, h.v, -d.h+dWindow.v),
      ]),
      new GlTriangle([
        new GlPoint(w.h-wCabin.v,hCabin.v,d.h),
        new GlPoint(w.h-wCabin.v, h.v, -d.h+dWindow.v),
        new GlPoint(w.h-wCabin.v,hCabin.v,-d.h),
      ]),
      //rear cabin
      new GlRectangle.withHD(-w.h+wLoader.v,hLoader.v, -d.h, hCabin.v-hLoader.v, d.v, false),
      //right side
      //bottom
      new GlRectangle.withWH(-w.h,0.0, d.h, w.v, hLoader.v, true),
      new GlRectangle.withWH(-w.h + wLoader.v,hLoader.v, d.h, wCabin.v, hCabin.v - hLoader.v, true),
      //left side
      //bottom
      new GlRectangle.withWH(-w.h,0.0, -d.h, w.v, hLoader.v, false),
      new GlRectangle.withWH(-w.h + wLoader.v,hLoader.v, -d.h, wCabin.v, hCabin.v - hLoader.v, false),
    ]));

    collection.loadModel(_ModelStripe, new GlAreaModel([
      //roof
      new GlRectangle.withWD(w.h-wCabin.v,h.v, -d.h+dWindow.v+dStripeRoofLeft.v, wRoof.v, dStripeRoofMid.v, false),
    ]));

    collection.loadModel(_ModelWindows, new GlAreaModel([
      //WindowFront
      new GlTriangle([
        new GlPoint(w.h, hCabin.v, d.h),
        new GlPoint(w.h-wWindowFront.v, h.v, -d.h+dWindow.v),
        new GlPoint(w.h-wWindowFront.v, h.v, d.h-dWindow.v),
      ]),
      new GlTriangle([
        new GlPoint(w.h,hCabin.v,d.h),
        new GlPoint(w.h,hCabin.v,-d.h),
        new GlPoint(w.h-wWindowFront.v, h.v, -d.h+dWindow.v),
      ]),
      //windowLeft
      new GlTriangle([
        new GlPoint(-w.h+wLoader.v,hCabin.v,d.h),
        new GlPoint(w.h-wWindowFront.v,h.v,d.h-dWindow.v),
        new GlPoint(-w.h+wLoader.v,h.v,d.h-dWindow.v),
      ]),
      new GlTriangle([
        new GlPoint(-w.h+wLoader.v,hCabin.v,d.h),
        new GlPoint(w.h,hCabin.v,d.h),
        new GlPoint(w.h-wWindowFront.v,h.v,d.h-dWindow.v),
      ]),
      //windowRight
      new GlTriangle([
        new GlPoint(-w.h+wLoader.v,hCabin.v,-d.h),
        new GlPoint(-w.h+wLoader.v,h.v,-d.h+dWindow.v),
        new GlPoint(w.h-wWindowFront.v,h.v,-d.h+dWindow.v),
      ]),
      new GlTriangle([
        new GlPoint(-w.h+wLoader.v,hCabin.v,-d.h),
        new GlPoint(w.h-wWindowFront.v,h.v,-d.h+dWindow.v),
        new GlPoint(w.h,hCabin.v,-d.h),
      ]),
    ]));
    collection.loadModel(_ModelWheel, new GlCube.fromTopCenter(0.0,0.0,0.0,wWheel.v,hWheel.v,dWheel.v));
  }
}