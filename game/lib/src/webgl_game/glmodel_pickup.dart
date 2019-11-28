part of webgl_game;

class GlModel_Pickup {
  static const String _ModelBody = "pickup_body";
  static const String _ModelStripe = "pickup_stripe";
  static const String _ModelWindows = "pickup_windows";
  static const String _ModelWheel = "pickup_wheel";

  static const double sx = 70.0;
  static const double sy = 50.0;
  static const double sz = 30.0;

  GlColor colorWindows = new GlColor(0.2, 0.2, 0.2);
  GlColor color1 = new GlColor(1.0, 1.0, 1.0);
  GlColor color2 = new GlColor(0.5, 0.5, 0.5);

  DoubleHelper h = new DoubleHelper.scaled(sy, 1.0);
  DoubleHelper hCarBottom = new DoubleHelper.scaled(sy, 0.5);
  DoubleHelper hWindow = new DoubleHelper.scaled(sy, 0.5);

  DoubleHelper d = new DoubleHelper.scaled(sz, 1.0);
  DoubleHelper dRoof = new DoubleHelper.scaled(sz, 0.8);
  DoubleHelper dWindow = new DoubleHelper.scaled(sz, 0.1);

  DoubleHelper dStripeLeft = new DoubleHelper.scaled(sz, 0.3);
  DoubleHelper dStripeMid = new DoubleHelper.scaled(sz, 0.4);
  DoubleHelper dStripeRight = new DoubleHelper.scaled(sz, 0.3);

  DoubleHelper dStripeRoofLeft = new DoubleHelper.scaled(sz, 0.2);
  DoubleHelper dStripeRoofMid = new DoubleHelper.scaled(sz, 0.4);
  DoubleHelper dStripeRoofRight = new DoubleHelper.scaled(sz, 0.2);

  DoubleHelper w = new DoubleHelper.scaled(sx, 1.0);
  DoubleHelper wHood = new DoubleHelper.scaled(sx, 0.3);
  DoubleHelper wRoof = new DoubleHelper.scaled(sx, 0.2);
  DoubleHelper wRear = new DoubleHelper.scaled(sx, 0.4);
  DoubleHelper wWindowFront = new DoubleHelper.scaled(sx, 0.1);
  DoubleHelper wWindowRear = new DoubleHelper.scaled(sx, 0.0);

  DoubleHelper wWheelOffsetRear = new DoubleHelper.scaled(sx, 0.2);
  DoubleHelper wWheelOffsetFront = new DoubleHelper.scaled(sx, 0.2);
  DoubleHelper dWheelOffsetIn = new DoubleHelper(0.0);
  DoubleHelper hWheelOffsetIn = new DoubleHelper(0.0);
  DoubleHelper wWheel = new DoubleHelper(20.0);
  DoubleHelper dWheel = new DoubleHelper(18.0);
  DoubleHelper hWheel = new DoubleHelper(20.0);

  GlModelInstanceCollection getModelInstance(GlModelCollection collection, GlColor colorBase, GlColor colorStripe, GlColor colorWindow) {
    GlMatrix wheelPositionFrontRight = GlMatrix.translationMatrix(w.h - wWheelOffsetFront.v, hWheel.h + hWheelOffsetIn.v, -d.h + dWheelOffsetIn.v);
    GlMatrix wheelPositionRearRight = GlMatrix.translationMatrix(-w.h + wWheelOffsetRear.v, hWheel.h + hWheelOffsetIn.v, -d.h + dWheelOffsetIn.v);
    GlMatrix wheelPositionFrontLeft = GlMatrix.translationMatrix(w.h - wWheelOffsetFront.v, hWheel.h + hWheelOffsetIn.v, d.h - dWheelOffsetIn.v).multThis(GlMatrix.rotationYMatrix(pi));
    GlMatrix wheelPositionRearLeft = GlMatrix.translationMatrix(-w.h + wWheelOffsetRear.v, hWheel.h + hWheelOffsetIn.v, d.h - dWheelOffsetIn.v).multThis(GlMatrix.rotationYMatrix(pi));
    GlMatrix modelGroundOffset = GlMatrix.translationMatrix(0.0, hWheel.h, 0.0);

    var colorWheel = new GlColor(0.2, 0.2, 0.2);
    return new GlModelInstanceCollection([
      new GlModelInstance(collection.getModelBuffer(_ModelWheel), colorWheel, wheelPositionFrontRight),
      new GlModelInstance(collection.getModelBuffer(_ModelWheel), colorWheel, wheelPositionFrontLeft),
      new GlModelInstance(collection.getModelBuffer(_ModelWheel), colorWheel, wheelPositionRearRight),
      new GlModelInstance(collection.getModelBuffer(_ModelWheel), colorWheel, wheelPositionRearLeft),
      new GlModelInstance(collection.getModelBuffer(_ModelBody), colorBase, modelGroundOffset),
      new GlModelInstance(collection.getModelBuffer(_ModelStripe), colorStripe, modelGroundOffset),
      new GlModelInstance(collection.getModelBuffer(_ModelWindows), colorWindow, modelGroundOffset),
    ]);
  }

  GlModel loadModel(GlModelCollection collection) {
    collection.loadModel(
        _ModelBody,
        new GlAreaModel([
          //floor
          new GlRectangle.withWD(-w.h, 0.0, -d.h, w.v, d.v, true),
          //hood
          new GlRectangle.withWD(w.h - wHood.v, hCarBottom.v, d.h - dStripeRight.v, wHood.v, dStripeRight.v, false),
          new GlRectangle.withWD(w.h - wHood.v, hCarBottom.v, -d.h, wHood.v, dStripeLeft.v, false),
          //rear top
          //new GlRectangle.withWD(-w.h,hCarBottom.v, d.h-dStripeRight.v, wRear.v, dStripeRight.v, false),
          //new GlRectangle.withWD(-w.h,hCarBottom.v, -d.h, wRear.v, dStripeLeft.v, false),
          new GlRectangle.withWD(-w.h, hCarBottom.v, -d.h, wRear.v, d.v, false),
          //roof
          new GlRectangle.withWD(-w.h + wRear.v + wWindowRear.v, h.v, d.h - dWindow.v - dStripeRoofRight.v, wRoof.v, dStripeRoofRight.v, false),
          new GlRectangle.withWD(-w.h + wRear.v + wWindowRear.v, h.v, -d.h + dWindow.v, wRoof.v, dStripeRoofLeft.v, false),
          //front
          new GlRectangle.withHD(w.h, 0.0, -d.h, hCarBottom.v, d.v, true),
          //rear
          new GlRectangle.withHD(-w.h, 0.0, -d.h, hCarBottom.v, d.v, false),
          //right side
          //bottom
          new GlRectangle.withWH(-w.h, 0.0, d.h, w.v, hCarBottom.v, true),
          //left side
          //bottom
          new GlRectangle.withWH(-w.h, 0.0, -d.h, w.v, hCarBottom.v, false),
        ]));

    collection.loadModel(
        _ModelStripe,
        new GlAreaModel([
          //hood
          new GlRectangle.withWD(w.h - wHood.v, hCarBottom.v, -d.h + dStripeLeft.v, wHood.v, dStripeMid.v, false),
          //rear top
          //new GlRectangle.withWD(-w.h,hCarBottom.v, -d.h+dStripeLeft.v, wRear.v, dStripeMid.v, false),
          //roof
          new GlRectangle.withWD(-w.h + wRear.v + wWindowRear.v, h.v, -d.h + dWindow.v + dStripeRoofLeft.v, wRoof.v, dStripeRoofMid.v, false),
        ]));

    collection.loadModel(
        _ModelWindows,
        new GlAreaModel([
          //WindowFront
          new GlTriangle([
            new GlPoint(w.h - wHood.v, hCarBottom.v, d.h),
            new GlPoint(w.h - wHood.v - wWindowFront.v, h.v, -d.h + dWindow.v),
            new GlPoint(w.h - wHood.v - wWindowFront.v, h.v, d.h - dWindow.v),
          ]),
          new GlTriangle([
            new GlPoint(w.h - wHood.v, hCarBottom.v, d.h),
            new GlPoint(w.h - wHood.v, hCarBottom.v, -d.h),
            new GlPoint(w.h - wHood.v - wWindowFront.v, h.v, -d.h + dWindow.v),
          ]),
          //WindowRear
          new GlTriangle([
            new GlPoint(-w.h + wRear.v, hCarBottom.v, d.h),
            new GlPoint(-w.h + wRear.v + wWindowRear.v, h.v, d.h - dWindow.v),
            new GlPoint(-w.h + wRear.v + wWindowRear.v, h.v, -d.h + dWindow.v),
          ]),
          new GlTriangle([
            new GlPoint(-w.h + wRear.v, hCarBottom.v, d.h),
            new GlPoint(-w.h + wRear.v + wWindowRear.v, h.v, -d.h + dWindow.v),
            new GlPoint(-w.h + wRear.v, hCarBottom.v, -d.h),
          ]),
          //windowLeft
          new GlTriangle([
            new GlPoint(-w.h + wRear.v, hCarBottom.v, d.h),
            new GlPoint(w.h - wHood.v - wWindowFront.v, h.v, d.h - dWindow.v),
            new GlPoint(-w.h + wRear.v + wWindowRear.v, h.v, d.h - dWindow.v),
          ]),
          new GlTriangle([
            new GlPoint(-w.h + wRear.v, hCarBottom.v, d.h),
            new GlPoint(w.h - wHood.v, hCarBottom.v, d.h),
            new GlPoint(w.h - wHood.v - wWindowFront.v, h.v, d.h - dWindow.v),
          ]),
          //windowRight
          new GlTriangle([
            new GlPoint(-w.h + wRear.v, hCarBottom.v, -d.h),
            new GlPoint(-w.h + wRear.v + wWindowRear.v, h.v, -d.h + dWindow.v),
            new GlPoint(w.h - wHood.v - wWindowFront.v, h.v, -d.h + dWindow.v),
          ]),
          new GlTriangle([
            new GlPoint(-w.h + wRear.v, hCarBottom.v, -d.h),
            new GlPoint(w.h - wHood.v - wWindowFront.v, h.v, -d.h + dWindow.v),
            new GlPoint(w.h - wHood.v, hCarBottom.v, -d.h),
          ]),
        ]));
    collection.loadModel(_ModelWheel, new GlCube.fromTopCenter(0.0, 0.0, 0.0, wWheel.v, hWheel.v, dWheel.v));
  }
}
