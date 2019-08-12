part of webgl_game;

class GlModel_Caravan{

  static const String _ModelBody = "caravan_body";
  static const String _ModelStripe = "caravan_stripe";
  static const String _ModelWindows = "caravan_windows";
  static const String _ModelWheel = "caravan_wheel";

  static const double sx = 50.0;
  static const double sy = 50.0;
  static const double sz = 30.0;
  static const double sxBar = 15.0;

  GlColor colorWindows = new GlColor(0.2,0.2,0.2);
  GlColor color1 = new GlColor(1.0,1.0,1.0);
  GlColor color2 = new GlColor(0.5,0.5,0.5);

  DoubleHelper h = new DoubleHelper.scaled(sy,1.2);
  DoubleHelper hCarBottom = new DoubleHelper.scaled(sy,0.7);
  DoubleHelper hWindow = new DoubleHelper.scaled(sy,0.5);

  DoubleHelper d = new DoubleHelper.scaled(sz,1.0);
  DoubleHelper dRoof = new DoubleHelper.scaled(sz,0.8);
  DoubleHelper dWindow = new DoubleHelper.scaled(sz,0.1);

  DoubleHelper dStripeRoofLeft = new DoubleHelper.scaled(sz,0.2);
  DoubleHelper dStripeRoofMid = new DoubleHelper.scaled(sz,0.4);
  DoubleHelper dStripeRoofRight = new DoubleHelper.scaled(sz,0.2);

  DoubleHelper w = new DoubleHelper.scaled(sx,1.0);
  DoubleHelper wRoof = new DoubleHelper.scaled(sx,0.8);
  DoubleHelper wWindowFront = new DoubleHelper.scaled(sx,0.1);
  DoubleHelper wWindowRear = new DoubleHelper.scaled(sx,0.1);

  DoubleHelper dWheelOffsetIn = new DoubleHelper.scaled(sz,0.05);
  DoubleHelper hWheelOffsetIn = new DoubleHelper.scaled(sy,0.05);

  DoubleHelper wWheel = new DoubleHelper(12.0);
  DoubleHelper dWheel = new DoubleHelper(10.0);
  DoubleHelper hWheel = new DoubleHelper(12.0);

  DoubleHelper wBar = new DoubleHelper.scaled(sxBar,1.0);
  DoubleHelper dBar = new DoubleHelper.scaled(sz,0.2);
  DoubleHelper hBar = new DoubleHelper.scaled(sy,0.2);

  GlModelInstanceCollection getModelInstance(GlModelCollection collection, GlColor colorBase, GlColor colorStripe, GlColor colorWindow){

    GlMatrix wheelPositionRight = GlMatrix.translationMatrix(0.0,hWheel.h+hWheelOffsetIn.v,-d.h+dWheelOffsetIn.v);
    GlMatrix wheelPositionLeft =  GlMatrix.translationMatrix(0.0,hWheel.h+hWheelOffsetIn.v,d.h-dWheelOffsetIn.v).multThis(GlMatrix.rotationYMatrix(Math.pi));
    GlMatrix modelGroundOffset = GlMatrix.translationMatrix(0.0,hWheel.h,0.0);

    var colorWheel = new GlColor(0.2,0.2,0.2);
    return new GlModelInstanceCollection([
      new GlModelInstance(collection.getModelBuffer(_ModelWheel), colorWheel, wheelPositionRight),
      new GlModelInstance(collection.getModelBuffer(_ModelWheel), colorWheel, wheelPositionLeft),
      new GlModelInstance(collection.getModelBuffer(_ModelBody), colorBase, modelGroundOffset),
      new GlModelInstance(collection.getModelBuffer(_ModelStripe), colorStripe, modelGroundOffset),
      new GlModelInstance(collection.getModelBuffer(_ModelWindows), colorWindow, modelGroundOffset),
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