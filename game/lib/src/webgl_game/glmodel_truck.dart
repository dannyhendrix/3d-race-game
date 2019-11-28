part of webgl_game;

class GlModel_Truck {
  static const String _ModelBody = "truck_body";
  static const String _ModelStripe = "truck_stripe";
  static const String _ModelWindows = "truck_windows";
  static const String _ModelWheel = "truck_wheel";

  static const double sx = 50.0 / 1.0;
  static const double sy = 70.0 / 1.0;
  static const double sz = 40.0 / 1.0;

  GlColor colorWindows = new GlColor(0.2, 0.2, 0.2);
  GlColor color1 = new GlColor(1.0, 1.0, 1.0);
  GlColor color2 = new GlColor(0.5, 0.5, 0.5);

  DoubleHelper h = new DoubleHelper.scaled(sy, 1.0);
  DoubleHelper hLoader = new DoubleHelper.scaled(sy, 0.3);
  DoubleHelper hCabin = new DoubleHelper.scaled(sy, 0.6);
  DoubleHelper hWindow = new DoubleHelper.scaled(sy, 0.4);

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
  DoubleHelper wCabin = new DoubleHelper.scaled(sx, 0.5);
  DoubleHelper wRoof = new DoubleHelper.scaled(sx, 0.4);
  DoubleHelper wLoader = new DoubleHelper.scaled(sx, 0.5);
  DoubleHelper wWindowFront = new DoubleHelper.scaled(sx, 0.1);

  DoubleHelper wWheelOffsetRear = new DoubleHelper.scaled(sx, 0.2);
  DoubleHelper wWheelOffsetFront = new DoubleHelper.scaled(sx, 0.2);
  DoubleHelper dWheelOffsetIn = new DoubleHelper.scaled(sz, 0.05);
  DoubleHelper hWheelOffsetIn = new DoubleHelper.scaled(sy, 0.1);

  DoubleHelper wWheel = new DoubleHelper(12.0);
  DoubleHelper dWheel = new DoubleHelper(10.0);
  DoubleHelper hWheel = new DoubleHelper(12.0);

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
      new GlModelInstance(collection.getModelBuffer(_ModelBody), colorBase, modelGroundOffset, "truck"),
      new GlModelInstance(collection.getModelBuffer(_ModelStripe), colorStripe, modelGroundOffset),
      new GlModelInstance(collection.getModelBuffer(_ModelWindows), colorWindow, modelGroundOffset),
    ]);
  }

  GlModel loadModel(GlModelCollection collection) {
    var to = 4.0;
    collection.loadModel(
        _ModelBody,
        new GlAreaModel([
          //floor
          new GlRectangle.withWD(-w.h, 0.0, -d.h, w.v, d.v, true),
          //loader top
          new GlRectangle.withWD(-w.h, hLoader.v, -d.h, wLoader.v, d.v, false),
          //roof
          new GlRectangle.withWD(w.h - wCabin.v, h.v, d.h - dWindow.v - dStripeRoofRight.v, wRoof.v, dStripeRoofRight.v, false),
          new GlRectangle.withWD(w.h - wCabin.v, h.v, -d.h + dWindow.v, wRoof.v, dStripeRoofLeft.v, false),
          //front
          new GlRectangle.withHD(w.h, 0.0, -d.h, hCabin.v, d.v, true, 0, 0),
          //rear
          new GlRectangle.withHD(-w.h, 0.0, -d.h, hLoader.v, d.v, false),
          //TopCabinRear
          new GlTriangle([
            new GlPoint(w.h - wCabin.v, hCabin.v, d.h),
            new GlPoint(w.h - wCabin.v, h.v, d.h - dWindow.v),
            new GlPoint(w.h - wCabin.v, h.v, -d.h + dWindow.v),
          ]),
          new GlTriangle([
            new GlPoint(w.h - wCabin.v, hCabin.v, d.h),
            new GlPoint(w.h - wCabin.v, h.v, -d.h + dWindow.v),
            new GlPoint(w.h - wCabin.v, hCabin.v, -d.h),
          ]),
          //rear cabin
          new GlRectangle.withHD(-w.h + wLoader.v, hLoader.v, -d.h, hCabin.v - hLoader.v, d.v, false),
          //right side
          //bottom
          new GlRectangle.withWH(-w.h, 0.0, d.h, w.v, hLoader.v, true, to + d.v, hCabin.v - hLoader.v),
          new GlRectangle.withWH(-w.h + wLoader.v, hLoader.v, d.h, wCabin.v, hCabin.v - hLoader.v, true, to + d.v + wLoader.v, 0),
          //left side
          //bottom
          new GlRectangle.withWH(-w.h, 0.0, -d.h, w.v, hLoader.v, false, to + d.v, to + h.v),
          new GlRectangle.withWH(-w.h + wLoader.v, hLoader.v, -d.h, wCabin.v, hCabin.v - hLoader.v, false, to + d.v + wLoader.v, to + h.v),
        ]));

    collection.loadModel(
        _ModelStripe,
        new GlAreaModel([
          //roof
          new GlRectangle.withWD(w.h - wCabin.v, h.v, -d.h + dWindow.v + dStripeRoofLeft.v, wRoof.v, dStripeRoofMid.v, false),
        ]));

    collection.loadModel(
        _ModelWindows,
        new GlAreaModel([
          //WindowFront
          new GlTriangle([
            new GlPoint(w.h, hCabin.v, d.h),
            new GlPoint(w.h - wWindowFront.v, h.v, -d.h + dWindow.v),
            new GlPoint(w.h - wWindowFront.v, h.v, d.h - dWindow.v),
          ]),
          new GlTriangle([
            new GlPoint(w.h, hCabin.v, d.h),
            new GlPoint(w.h, hCabin.v, -d.h),
            new GlPoint(w.h - wWindowFront.v, h.v, -d.h + dWindow.v),
          ]),
          //windowLeft
          new GlTriangle([
            new GlPoint(-w.h + wLoader.v, hCabin.v, d.h),
            new GlPoint(w.h - wWindowFront.v, h.v, d.h - dWindow.v),
            new GlPoint(-w.h + wLoader.v, h.v, d.h - dWindow.v),
          ]),
          new GlTriangle([
            new GlPoint(-w.h + wLoader.v, hCabin.v, d.h),
            new GlPoint(w.h, hCabin.v, d.h),
            new GlPoint(w.h - wWindowFront.v, h.v, d.h - dWindow.v),
          ]),
          //windowRight
          new GlTriangle([
            new GlPoint(-w.h + wLoader.v, hCabin.v, -d.h),
            new GlPoint(-w.h + wLoader.v, h.v, -d.h + dWindow.v),
            new GlPoint(w.h - wWindowFront.v, h.v, -d.h + dWindow.v),
          ]),
          new GlTriangle([
            new GlPoint(-w.h + wLoader.v, hCabin.v, -d.h),
            new GlPoint(w.h - wWindowFront.v, h.v, -d.h + dWindow.v),
            new GlPoint(w.h, hCabin.v, -d.h),
          ]),
        ]));
    collection.loadModel(_ModelWheel, new GlCube.fromTopCenter(0.0, 0.0, 0.0, wWheel.v, hWheel.v, dWheel.v));
  }
}
