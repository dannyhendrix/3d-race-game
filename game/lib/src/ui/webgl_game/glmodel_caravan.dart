part of webgl_game;

class GlModel_Caravan{

  static const String _ModelBody = "caravan_body";
  static const String _ModelStripe = "caravan_stripe";
  static const String _ModelWindows = "caravan_windows";
  static const String _ModelWheel = "caravan_wheel";

  static const double sx = 50.0/1.0;
  static const double sy = 50.0/1.0;
  static const double sz = 30.0/1.0;
  static const double sxBar = 15.0/1.0;

  GlColor colorWindows = new GlColor(0.2,0.2,0.2);
  GlColor color1 = new GlColor(1.0,1.0,1.0);
  GlColor color2 = new GlColor(0.5,0.5,0.5);

  DoubleHelper h = new DoubleHelper(1.2,sy);
  DoubleHelper hCarBottom = new DoubleHelper(0.7,sy);
  DoubleHelper hWindow = new DoubleHelper(0.5,sy);

  DoubleHelper d = new DoubleHelper(1.0,sz);
  DoubleHelper dRoof = new DoubleHelper(0.8,sz);
  DoubleHelper dWindow = new DoubleHelper(0.1,sz);

  DoubleHelper dStripeRoofLeft = new DoubleHelper(0.2,sz);
  DoubleHelper dStripeRoofMid = new DoubleHelper(0.4,sz);
  DoubleHelper dStripeRoofRight = new DoubleHelper(0.2,sz);

  DoubleHelper w = new DoubleHelper(1.0,sx);
  DoubleHelper wRoof = new DoubleHelper(0.8,sx);
  DoubleHelper wWindowFront = new DoubleHelper(0.1,sx);
  DoubleHelper wWindowRear = new DoubleHelper(0.1,sx);

  DoubleHelper dWheelOffsetIn = new DoubleHelper(0.1,sz);
  DoubleHelper hWheelOffsetIn = new DoubleHelper(0.1,sy);
  DoubleHelper wWheel = new DoubleHelper(0.2,sx);
  DoubleHelper dWheel = new DoubleHelper(0.4,sz);
  DoubleHelper hWheel = new DoubleHelper(0.3,sy);

  DoubleHelper wBar = new DoubleHelper(1.0,sxBar);
  DoubleHelper dBar = new DoubleHelper(0.2,sz);
  DoubleHelper hBar = new DoubleHelper(0.2,sy);

  GlModelInstanceCollection getModelInstance(GlModelCollection collection, GlColor colorBase, GlColor colorStripe, GlColor colorWindow){

    GlMatrix wheelPositionRight = GlMatrix.translationMatrix(0.0,hWheelOffsetIn.v,-d.h+dWheelOffsetIn.v);
    GlMatrix wheelPositionLeft =  GlMatrix.translationMatrix(0.0,hWheelOffsetIn.v,d.h-dWheelOffsetIn.v)*GlMatrix.rotationYMatrix(Math.PI);

    var colorWheel = new GlColor(0.2,0.2,0.2);
    return new GlModelInstanceCollection([
      new GlModelInstance(collection.getModelBuffer(_ModelWheel), colorWheel, wheelPositionRight),
      new GlModelInstance(collection.getModelBuffer(_ModelWheel), colorWheel, wheelPositionLeft),
      new GlModelInstance(collection.getModelBuffer(_ModelBody), colorBase),
      new GlModelInstance(collection.getModelBuffer(_ModelStripe), colorStripe),
      new GlModelInstance(collection.getModelBuffer(_ModelWindows), colorWindow),
    ]);
  }
  GlModel loadModel(GlModelCollection collection){
    collection.loadModel(_ModelBody, new GlAreaModel([
      //floor
      new GlRectangle.withWD(-w.h,0.0, -d.h, w.v, d.v, true),
      new GlTriangle([
        new GlPoint(w.h,0.0,-dBar.h),
        new GlPoint(w.h+wBar.v,0.0,0.0),
        new GlPoint(w.h,0.0,dBar.h),
      ]),
      new GlTriangle([
        new GlPoint(w.h,0.0,-dBar.h),
        new GlPoint(w.h,hBar.v,0.0),
        new GlPoint(w.h+wBar.v,0.0,0.0),
      ]),
      new GlTriangle([
        new GlPoint(w.h,0.0,dBar.h),
        new GlPoint(w.h+wBar.v,0.0,0.0),
        new GlPoint(w.h,hBar.v,0.0),
      ]),
      //roof
      new GlRectangle.withWD(-w.h+wWindowRear.v,h.v, d.h-dWindow.v-dStripeRoofRight.v, wRoof.v, dStripeRoofRight.v, false),
      new GlRectangle.withWD(-w.h+wWindowRear.v,h.v, -d.h+dWindow.v, wRoof.v, dStripeRoofLeft.v, false),
      //front
      new GlRectangle.withHD(w.h,0.0, -d.h, hCarBottom.v, d.v, true),
      //rear
      new GlRectangle.withHD(-w.h,0.0, -d.h, hCarBottom.v, d.v, false),
      //right side
      //bottom
      new GlRectangle.withWH(-w.h,0.0, d.h, w.v, hCarBottom.v, true),
      //left side
      //bottom
      new GlRectangle.withWH(-w.h,0.0, -d.h, w.v, hCarBottom.v, false),
    ]));

    collection.loadModel(_ModelStripe, new GlAreaModel([
      //roof
      new GlRectangle.withWD(-w.h+wWindowRear.v,h.v, -d.h+dWindow.v+dStripeRoofLeft.v, wRoof.v, dStripeRoofMid.v, false),
    ]));

    collection.loadModel(_ModelWindows, new GlAreaModel([
      //WindowFront
      new GlTriangle([
        new GlPoint(w.h, hCarBottom.v, d.h),
        new GlPoint(w.h-wWindowFront.v, h.v, -d.h+dWindow.v),
        new GlPoint(w.h-wWindowFront.v, h.v, d.h-dWindow.v),
      ]),
      new GlTriangle([
        new GlPoint(w.h,hCarBottom.v,d.h),
        new GlPoint(w.h,hCarBottom.v,-d.h),
        new GlPoint(w.h-wWindowFront.v, h.v, -d.h+dWindow.v),
      ]),
      //WindowRear
      new GlTriangle([
        new GlPoint(-w.h, hCarBottom.v, d.h),
        new GlPoint(-w.h+wWindowRear.v, h.v, d.h-dWindow.v),
        new GlPoint(-w.h+wWindowRear.v, h.v, -d.h+dWindow.v),
      ]),
      new GlTriangle([
        new GlPoint(-w.h,hCarBottom.v,d.h),
        new GlPoint(-w.h+wWindowRear.v, h.v, -d.h+dWindow.v),
        new GlPoint(-w.h,hCarBottom.v,-d.h),
      ]),
      //windowLeft
      new GlTriangle([
        new GlPoint(-w.h,hCarBottom.v,d.h),
        new GlPoint(w.h-wWindowFront.v,h.v,d.h-dWindow.v),
        new GlPoint(-w.h+wWindowRear.v,h.v,d.h-dWindow.v),
      ]),
      new GlTriangle([
        new GlPoint(-w.h,hCarBottom.v,d.h),
        new GlPoint(w.h,hCarBottom.v,d.h),
        new GlPoint(w.h-wWindowFront.v,h.v,d.h-dWindow.v),
      ]),
      //windowRight
      new GlTriangle([
        new GlPoint(-w.h,hCarBottom.v,-d.h),
        new GlPoint(-w.h+wWindowRear.v,h.v,-d.h+dWindow.v),
        new GlPoint(w.h-wWindowFront.v,h.v,-d.h+dWindow.v),
      ]),
      new GlTriangle([
        new GlPoint(-w.h,hCarBottom.v,-d.h),
        new GlPoint(w.h-wWindowFront.v,h.v,-d.h+dWindow.v),
        new GlPoint(w.h,hCarBottom.v,-d.h),
      ]),
    ]));
    collection.loadModel(_ModelWheel, new GlCube.fromTopCenter(0.0,0.0,0.0,wWheel.v,hWheel.v,dWheel.v));
  }
}