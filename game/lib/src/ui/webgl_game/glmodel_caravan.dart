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
      new GlModelInstance(collection.getModelBuffer(_ModelWheel), colorWheel, wheelPositionRight, "caravan"),
      new GlModelInstance(collection.getModelBuffer(_ModelWheel), colorWheel, wheelPositionLeft, "caravan"),
      new GlModelInstance(collection.getModelBuffer(_ModelBody), colorBase, modelGroundOffset, "caravan"),
      new GlModelInstance(collection.getModelBuffer(_ModelStripe), colorStripe, modelGroundOffset, "caravan"),
      new GlModelInstance(collection.getModelBuffer(_ModelWindows), colorWindow, modelGroundOffset, "caravan"),
    ]);
  }
  GlModel loadModel(GlModelCollection collection){
    var to = 4.0;
    collection.loadModel(_ModelBody, new GlAreaModel([
      //floor
      new GlRectangle.withWD(-w.h,0.0, -d.h, w.v, d.v, true,to+d.v+to+w.v,to+d.v),
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
      new GlRectangle.withWD(-w.h+wWindowRear.v,h.v, d.h-dWindow.v-dStripeRoofRight.v, wRoof.v, dStripeRoofRight.v, false,to+d.v+to+w.v,dStripeRoofRight.v+dStripeRoofMid.v),
      new GlRectangle.withWD(-w.h+wWindowRear.v,h.v, -d.h+dWindow.v, wRoof.v, dStripeRoofLeft.v, false,to+d.v+to+w.v,0),
      //front
      new GlRectangle.withHD(w.h,0.0, -d.h, hCarBottom.v, d.v, true,0,0),
      //rear
      new GlRectangle.withHD(-w.h,0.0, -d.h, hCarBottom.v, d.v, false, 0,to+hCarBottom.v),
      //right side
      //bottom
      new GlRectangle.withWH(-w.h,0.0, d.h, w.v, hCarBottom.v, true,to+d.v,0),
      //left side
      //bottom
      new GlRectangle.withWH(-w.h,0.0, -d.h, w.v, hCarBottom.v, false,to+d.v,to+hCarBottom.v),
    ]));

    collection.loadModel(_ModelStripe, new GlAreaModel([
      //roof
      new GlRectangle.withWD(-w.h+wWindowRear.v,h.v, -d.h+dWindow.v+dStripeRoofLeft.v, wRoof.v, dStripeRoofMid.v, false,to+d.v+to+w.v,dStripeRoofRight.v),
    ]));

    collection.loadModel(_ModelWindows, new GlAreaModel([
      //WindowFront
      new GlTriangle([
        new GlPoint(w.h, hCarBottom.v, d.h,0,80+25.5),
        new GlPoint(w.h-wWindowFront.v, h.v, -d.h+dWindow.v,27,80),
        new GlPoint(w.h-wWindowFront.v, h.v, d.h-dWindow.v,3,80),
      ]),
      new GlTriangle([
        new GlPoint(w.h,hCarBottom.v,d.h,0,80+25.5),
        new GlPoint(w.h,hCarBottom.v,-d.h,d.v,80+25.5),
        new GlPoint(w.h-wWindowFront.v, h.v, -d.h+dWindow.v,27,80),
      ]),
      //WindowRear
      new GlTriangle([
        new GlPoint(-w.h, hCarBottom.v, d.h,d.v,110+25.5),
        new GlPoint(-w.h+wWindowRear.v, h.v, d.h-dWindow.v,d.v-dWindow.v,110),
        new GlPoint(-w.h+wWindowRear.v, h.v, -d.h+dWindow.v,dWindow.v,110),
      ]),
      new GlTriangle([
        new GlPoint(-w.h,hCarBottom.v,d.h,d.v,110+25.5),
        new GlPoint(-w.h+wWindowRear.v, h.v, -d.h+dWindow.v,dWindow.v,110),
        new GlPoint(-w.h,hCarBottom.v,-d.h,0,110+25.5),
      ]),
      //windowLeft
      new GlTriangle([
        new GlPoint(-w.h,hCarBottom.v,d.h,to+d.v+0,80+25.1),
        new GlPoint(w.h-wWindowFront.v,h.v,d.h-dWindow.v,to+d.v+w.v-wWindowFront.v,80),
        new GlPoint(-w.h+wWindowRear.v,h.v,d.h-dWindow.v,to+d.v+wWindowRear.v,80),
      ]),
      new GlTriangle([
        new GlPoint(-w.h,hCarBottom.v,d.h,to+d.v+0,80+25.1),
        new GlPoint(w.h,hCarBottom.v,d.h,to+d.v+w.v,80+25.1),
        new GlPoint(w.h-wWindowFront.v,h.v,d.h-dWindow.v,to+d.v+w.v-wWindowFront.v,80),
      ]),
      //windowRight
      new GlTriangle([
        new GlPoint(-w.h,hCarBottom.v,-d.h,to+d.v+w.v,110+25.1),
        new GlPoint(-w.h+wWindowRear.v,h.v,-d.h+dWindow.v,to+d.v+w.v-wWindowRear.v,110),
        new GlPoint(w.h-wWindowFront.v,h.v,-d.h+dWindow.v, to+d.v+wWindowFront.v,110),
      ]),
      new GlTriangle([
        new GlPoint(-w.h,hCarBottom.v,-d.h,to+d.v+w.v,110+25.1),
        new GlPoint(w.h-wWindowFront.v,h.v,-d.h+dWindow.v, to+d.v+wWindowFront.v,110),
        new GlPoint(w.h,hCarBottom.v,-d.h,to+d.v+0,110+25.1),
      ]),
    ]));
    collection.loadModel(_ModelWheel, new GlCube.fromTopCenter(0.0,0.0,0.0,wWheel.v,hWheel.v,dWheel.v,0,150));
  }
}