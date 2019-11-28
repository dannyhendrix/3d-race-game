part of webgl_game;

class DoubleHelper {
  double v;
  double h;
  DoubleHelper(double v)
      : v = v,
        h = v / 2;
  DoubleHelper.scaled(double v, double s) : this(v * s);
}

class GlModel_Vehicle {
  static const String _ModelBody = "vehicle_body";
  static const String _ModelStripe = "vehicle_stripe";
  static const String _ModelWindows = "vehicle_windows";
  static const String _ModelWheel = "vehicle_wheel";

  static const double sx = 50.0;
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
  DoubleHelper wRoof = new DoubleHelper.scaled(sx, 0.3);
  DoubleHelper wRear = new DoubleHelper.scaled(sx, 0.2);
  DoubleHelper wWindowFront = new DoubleHelper.scaled(sx, 0.1);
  DoubleHelper wWindowRear = new DoubleHelper.scaled(sx, 0.1);

  DoubleHelper wWheelOffsetRear = new DoubleHelper.scaled(sx, 0.2);
  DoubleHelper wWheelOffsetFront = new DoubleHelper.scaled(sx, 0.2);
  DoubleHelper dWheelOffsetIn = new DoubleHelper.scaled(sz, 0.05);
  DoubleHelper hWheelOffsetIn = new DoubleHelper.scaled(sy, 0.05);

  DoubleHelper wWheel = new DoubleHelper(12.0);
  DoubleHelper dWheel = new DoubleHelper(10.0);
  DoubleHelper hWheel = new DoubleHelper(12.0);

  GlModelInstanceCollection getModelInstance(GlModelCollection collection, GlColor colorBase, GlColor colorStripe, GlColor colorWindow, [String texture = "car"]) {
    GlMatrix wheelPositionFrontRight = GlMatrix.translationMatrix(w.h - wWheelOffsetFront.v, hWheel.h + hWheelOffsetIn.v, -d.h + dWheelOffsetIn.v);
    GlMatrix wheelPositionRearRight = GlMatrix.translationMatrix(-w.h + wWheelOffsetRear.v, hWheel.h + hWheelOffsetIn.v, -d.h + dWheelOffsetIn.v);
    GlMatrix wheelPositionFrontLeft = GlMatrix.translationMatrix(w.h - wWheelOffsetFront.v, hWheel.h + hWheelOffsetIn.v, d.h - dWheelOffsetIn.v).multThis(GlMatrix.rotationYMatrix(pi));
    GlMatrix wheelPositionRearLeft = GlMatrix.translationMatrix(-w.h + wWheelOffsetRear.v, hWheel.h + hWheelOffsetIn.v, d.h - dWheelOffsetIn.v).multThis(GlMatrix.rotationYMatrix(pi));
    GlMatrix modelGroundOffset = GlMatrix.translationMatrix(0.0, hWheel.h, 0.0);

    var colorWheel = new GlColor(0.2, 0.2, 0.2);
    return new GlModelInstanceCollection([
      new GlModelInstance(collection.getModelBuffer(_ModelWheel), colorWheel, wheelPositionFrontRight, texture),
      new GlModelInstance(collection.getModelBuffer(_ModelWheel), colorWheel, wheelPositionFrontLeft, texture),
      new GlModelInstance(collection.getModelBuffer(_ModelWheel), colorWheel, wheelPositionRearRight, texture),
      new GlModelInstance(collection.getModelBuffer(_ModelWheel), colorWheel, wheelPositionRearLeft, texture),
      new GlModelInstance(collection.getModelBuffer(_ModelBody), colorBase, modelGroundOffset, texture),
      new GlModelInstance(collection.getModelBuffer(_ModelStripe), colorStripe, modelGroundOffset, texture),
      new GlModelInstance(collection.getModelBuffer(_ModelWindows), colorWindow, modelGroundOffset, texture),
    ]);
  }

  GlModel loadModel(GlModelCollection collection) {
    collection.loadModel(
        _ModelBody,
        new GlAreaModel([
          //floor
          new GlRectangle.withWD(-w.h, 0.0, -d.h, w.v, d.v, true, 0, 51),
          //hood
          new GlRectangle.withWD(w.h - wHood.v, hCarBottom.v, -d.h, wHood.v, dStripeLeft.v, false, 85, 51),
          new GlRectangle.withWD(w.h - wHood.v, hCarBottom.v, d.h - dStripeRight.v, wHood.v, dStripeRight.v, false, 85, 51 + dStripeLeft.v + dStripeMid.v),
          //rear top
          new GlRectangle.withWD(-w.h, hCarBottom.v, -d.h, wRear.v, dStripeLeft.v, false, 50, 51),
          new GlRectangle.withWD(-w.h, hCarBottom.v, d.h - dStripeRight.v, wRear.v, dStripeRight.v, false, 50, 51 + dStripeLeft.v + dStripeMid.v),
          //roof
          new GlRectangle.withWD(-w.h + wRear.v + wWindowRear.v, h.v, -d.h + dWindow.v, wRoof.v, dStripeRoofRight.v, false, 65, 54),
          new GlRectangle.withWD(-w.h + wRear.v + wWindowRear.v, h.v, d.h - dWindow.v - dStripeRoofRight.v, wRoof.v, dStripeRoofLeft.v, false, 65, 54 + dStripeRoofLeft.v + dStripeRoofMid.v),
          //front
          new GlRectangle.withHD(w.h, 0.0, -d.h, hCarBottom.v, d.v, true, 0, 107),
          //rear
          new GlRectangle.withHD(-w.h, 0.0, -d.h, hCarBottom.v, d.v, false, 0, 0),
          //right side
          //bottom
          new GlRectangle.withWH(-w.h, 0.0, d.h, w.v, hCarBottom.v, true, 50, 107),
          //left side
          //bottom
          new GlRectangle.withWH(-w.h, 0.0, -d.h, w.v, hCarBottom.v, false, 50, 0),
        ]));

    collection.loadModel(
        _ModelStripe,
        new GlAreaModel([
          //hood
          new GlRectangle.withWD(w.h - wHood.v, hCarBottom.v, -d.h + dStripeLeft.v, wHood.v, dStripeMid.v, false, 85, 51 + dStripeLeft.v),
          //rear top
          new GlRectangle.withWD(-w.h, hCarBottom.v, -d.h + dStripeLeft.v, wRear.v, dStripeMid.v, false, 50, 51 + dStripeLeft.v),
          //roof
          new GlRectangle.withWD(-w.h + wRear.v + wWindowRear.v, h.v, -d.h + dWindow.v + dStripeRoofLeft.v, wRoof.v, dStripeRoofMid.v, false, 65, 54 + dStripeRoofLeft.v),
        ]));

    collection.loadModel(
        _ModelWindows,
        new GlAreaModel([
          //WindowFront
          new GlTriangle([
            new GlPoint(w.h - wHood.v, hCarBottom.v, d.h, 0, 106),
            new GlPoint(w.h - wHood.v - wWindowFront.v, h.v, -d.h + dWindow.v, 27, 81),
            new GlPoint(w.h - wHood.v - wWindowFront.v, h.v, d.h - dWindow.v, 2, 81),
          ]),
          new GlTriangle([
            new GlPoint(w.h - wHood.v, hCarBottom.v, d.h, 0, 106),
            new GlPoint(w.h - wHood.v, hCarBottom.v, -d.h, 29, 106),
            new GlPoint(w.h - wHood.v - wWindowFront.v, h.v, -d.h + dWindow.v, 27, 81),
          ]),
          //WindowRear
          new GlTriangle([
            new GlPoint(-w.h + wRear.v, hCarBottom.v, d.h, 0, 25),
            new GlPoint(-w.h + wRear.v + wWindowRear.v, h.v, d.h - dWindow.v, 2, 50),
            new GlPoint(-w.h + wRear.v + wWindowRear.v, h.v, -d.h + dWindow.v, 27, 50),
          ]),
          new GlTriangle([
            new GlPoint(-w.h + wRear.v, hCarBottom.v, d.h, 0, 25),
            new GlPoint(-w.h + wRear.v + wWindowRear.v, h.v, -d.h + dWindow.v, 27, 50),
            new GlPoint(-w.h + wRear.v, hCarBottom.v, -d.h, 29, 25),
          ]),
          //windowLeft
          new GlTriangle([
            new GlPoint(-w.h + wRear.v, hCarBottom.v, d.h, 60, 106),
            new GlPoint(w.h - wHood.v - wWindowFront.v, h.v, d.h - dWindow.v, 80, 81),
            new GlPoint(-w.h + wRear.v + wWindowRear.v, h.v, d.h - dWindow.v, 64, 81),
          ]),
          new GlTriangle([
            new GlPoint(-w.h + wRear.v, hCarBottom.v, d.h, 60, 106),
            new GlPoint(w.h - wHood.v, hCarBottom.v, d.h, 84, 106),
            new GlPoint(w.h - wHood.v - wWindowFront.v, h.v, d.h - dWindow.v, 80, 81),
          ]),
          //windowRight
          new GlTriangle([
            new GlPoint(-w.h + wRear.v, hCarBottom.v, -d.h, 60, 25),
            new GlPoint(-w.h + wRear.v + wWindowRear.v, h.v, -d.h + dWindow.v, 64, 50),
            new GlPoint(w.h - wHood.v - wWindowFront.v, h.v, -d.h + dWindow.v, 80, 50),
          ]),
          new GlTriangle([
            new GlPoint(-w.h + wRear.v, hCarBottom.v, -d.h, 60, 25),
            new GlPoint(w.h - wHood.v - wWindowFront.v, h.v, -d.h + dWindow.v, 80, 50),
            new GlPoint(w.h - wHood.v, hCarBottom.v, -d.h, 84, 25),
          ]),
        ]));
    collection.loadModel(_ModelWheel, new GlCube.fromTopCenter(0.0, 0.0, 0.0, wWheel.v, hWheel.v, dWheel.v, 0, 150));
  }
}
