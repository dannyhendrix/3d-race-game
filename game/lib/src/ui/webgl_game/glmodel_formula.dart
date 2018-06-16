part of webgl_game;

class GlModel_Formula{

  static const String _ModelBody = "formula_body";
  static const String _ModelStripe = "formula_stripe";
  static const String _ModelWindows = "formula_windows";
  static const String _ModelWheel = "formula_wheel";

  static const double sx = 50.0/1.0;
  static const double sy = 50.0/1.0;
  static const double sz = 30.0/1.0;

  GlColor colorWindows = new GlColor(0.2,0.2,0.2);
  GlColor color1 = new GlColor(1.0,1.0,1.0);
  GlColor color2 = new GlColor(0.5,0.5,0.5);

  DoubleHelper h = new DoubleHelper(0.5,sy);
  DoubleHelper hLowerPart = new DoubleHelper(0.25,sy);
  DoubleHelper hUpperPart = new DoubleHelper(0.25,sy);

  DoubleHelper d = new DoubleHelper(1.0,sz);
  DoubleHelper dLeftSide = new DoubleHelper(0.3,sz);
  DoubleHelper dRightSide = new DoubleHelper(0.3,sz);
  DoubleHelper dMiddle = new DoubleHelper(0.4,sz);
/*
  DoubleHelper dStripeLeft = new DoubleHelper(0.3,sz);
  DoubleHelper dStripeMid = new DoubleHelper(0.4,sz);
  DoubleHelper dStripeRight = new DoubleHelper(0.3,sz);

  DoubleHelper dStripeRoofLeft = new DoubleHelper(0.2,sz);
  DoubleHelper dStripeRoofMid = new DoubleHelper(0.4,sz);
  DoubleHelper dStripeRoofRight = new DoubleHelper(0.2,sz);
*/
  DoubleHelper w = new DoubleHelper(1.0,sx);
  DoubleHelper wFrontWing = new DoubleHelper(0.2,sx);
  DoubleHelper wRearWing = new DoubleHelper(0.2,sx);
  DoubleHelper wFrontWheelOpening = new DoubleHelper(0.2,sx);
  DoubleHelper wRearWheelOpening = new DoubleHelper(0.2,sx);
  DoubleHelper wMiddle = new DoubleHelper(0.4,sx);
  DoubleHelper wMiddleTopFront = new DoubleHelper(0.2,sx);
  DoubleHelper wMiddleTopRear = new DoubleHelper(0.2,sx);
  DoubleHelper wOffsetRearWing = new DoubleHelper(0.1,sx);

  DoubleHelper wWheelOffsetRear = new DoubleHelper(0.1,sx);
  DoubleHelper wWheelOffsetFront = new DoubleHelper(0.3,sx);
  DoubleHelper dWheelOffsetIn = new DoubleHelper(0.1,sz);
  DoubleHelper hWheelOffsetIn = new DoubleHelper(0.1,sy);
  DoubleHelper wWheel = new DoubleHelper(0.2,sx);
  DoubleHelper dWheel = new DoubleHelper(0.4,sz);
  DoubleHelper hWheel = new DoubleHelper(0.3,sy);

  GlModelInstanceCollection getModelInstance(GlModelCollection collection, GlColor colorBase, GlColor colorStripe, GlColor colorWindow){

    GlMatrix wheelPositionFrontRight = GlMatrix.translationMatrix(w.h-wWheelOffsetFront.v,hWheelOffsetIn.v,-d.h+dWheelOffsetIn.v);
    GlMatrix wheelPositionRearRight = GlMatrix.translationMatrix(-w.h+wWheelOffsetRear.v,hWheelOffsetIn.v,-d.h+dWheelOffsetIn.v);
    GlMatrix wheelPositionFrontLeft =  GlMatrix.translationMatrix(w.h-wWheelOffsetFront.v,hWheelOffsetIn.v,d.h-dWheelOffsetIn.v).multThis(GlMatrix.rotationYMatrix(Math.pi));
    GlMatrix wheelPositionRearLeft = GlMatrix.translationMatrix(-w.h+wWheelOffsetRear.v,hWheelOffsetIn.v,d.h-dWheelOffsetIn.v).multThis(GlMatrix.rotationYMatrix(Math.pi));

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

      //front wheels
      new GlRectangle.withWD(w.h-wFrontWing.v-wFrontWheelOpening.v,0.0, -d.h+dLeftSide.v, wFrontWheelOpening.v, dMiddle.v, true),
      //middle
      new GlRectangle.withWD(-w.h+wRearWheelOpening.v,0.0, -d.h, wMiddle.v, d.v, true),
      //rear wheels
      new GlRectangle.withWD(-w.h,0.0, -d.h+dLeftSide.v, wRearWheelOpening.v, dMiddle.v, true),

      //top
      //middle
      new GlRectangle.withWD(-w.h+wRearWheelOpening.v,hLowerPart.v, -d.h, wMiddle.v, d.v, false),
      //rear
      new GlRectangle.withWD(-w.h,hLowerPart.v, -d.h+dLeftSide.v, wRearWheelOpening.v, dMiddle.v, false),

      //right side
      new GlRectangle.withWH(-w.h+wRearWheelOpening.v,0.0, d.h, wMiddle.v, hLowerPart.v, true),
      //front
      new GlTriangle([
        new GlPoint(w.h, 0.0, d.h-dRightSide.v),
        new GlPoint(w.h-wFrontWing.v-wFrontWheelOpening.v, hLowerPart.v, d.h-dRightSide.v),
        new GlPoint(w.h-wFrontWing.v-wFrontWheelOpening.v, 0.0, d.h-dRightSide.v),
      ]),
      //middle
      new GlTriangle([
        new GlPoint(-w.h+wRearWheelOpening.v+wMiddleTopRear.v, hLowerPart.v, d.h-dRightSide.v),
        new GlPoint(-w.h+wRearWheelOpening.v+wMiddleTopRear.v, h.v, d.h-dRightSide.v),
        new GlPoint(-w.h+wRearWheelOpening.v, hLowerPart.v, d.h-dRightSide.v),
      ]),
      //rear
      new GlTriangle([
        new GlPoint(-w.h+wRearWheelOpening.v, hLowerPart.v, d.h-dRightSide.v),
        new GlPoint(-w.h-wOffsetRearWing.v+wRearWing.v, h.v, d.h-dRightSide.v),
        new GlPoint(-w.h, hLowerPart.v, d.h-dRightSide.v),
      ]),
      new GlTriangle([
        new GlPoint(-w.h, hLowerPart.v, d.h-dRightSide.v),
        new GlPoint(-w.h-wOffsetRearWing.v+wRearWing.v, h.v, d.h-dRightSide.v),
        new GlPoint(-w.h-wOffsetRearWing.v, h.v, d.h-dRightSide.v),
      ]),
      new GlTriangle([
        new GlPoint(-w.h+wRearWheelOpening.v, hLowerPart.v, d.h-dRightSide.v),
        new GlPoint(-w.h, hLowerPart.v, d.h-dRightSide.v),
        new GlPoint(-w.h-wOffsetRearWing.v+wRearWing.v, h.v, d.h-dRightSide.v),
      ]),
      new GlTriangle([
        new GlPoint(-w.h, hLowerPart.v, d.h-dRightSide.v),
        new GlPoint(-w.h-wOffsetRearWing.v, h.v, d.h-dRightSide.v),
        new GlPoint(-w.h-wOffsetRearWing.v+wRearWing.v, h.v, d.h-dRightSide.v),
      ]),


      //left side
      new GlRectangle.withWH(-w.h+wRearWheelOpening.v,0.0, -d.h, wMiddle.v, hLowerPart.v, false),
      //front
      new GlTriangle([
        new GlPoint(w.h, 0.0, -d.h+dLeftSide.v),
        new GlPoint(w.h-wFrontWing.v-wFrontWheelOpening.v, 0.0, -d.h+dLeftSide.v),
        new GlPoint(w.h-wFrontWing.v-wFrontWheelOpening.v, hLowerPart.v, -d.h+dLeftSide.v),
      ]),
      //middle
      new GlTriangle([
        new GlPoint(-w.h+wRearWheelOpening.v+wMiddleTopRear.v, hLowerPart.v, -d.h+dLeftSide.v),
        new GlPoint(-w.h+wRearWheelOpening.v, hLowerPart.v, -d.h+dLeftSide.v),
        new GlPoint(-w.h+wRearWheelOpening.v+wMiddleTopRear.v, h.v, -d.h+dLeftSide.v),
      ]),
      //rear
      new GlTriangle([
        new GlPoint(-w.h+wRearWheelOpening.v, hLowerPart.v, -d.h+dLeftSide.v),
        new GlPoint(-w.h, hLowerPart.v, -d.h+dLeftSide.v),
        new GlPoint(-w.h-wOffsetRearWing.v+wRearWing.v, h.v, -d.h+dLeftSide.v),
      ]),
      new GlTriangle([
        new GlPoint(-w.h, hLowerPart.v, -d.h+dLeftSide.v),
        new GlPoint(-w.h-wOffsetRearWing.v, h.v, -d.h+dLeftSide.v),
        new GlPoint(-w.h-wOffsetRearWing.v+wRearWing.v, h.v, -d.h+dLeftSide.v),
      ]),
      new GlTriangle([
        new GlPoint(-w.h+wRearWheelOpening.v, hLowerPart.v, -d.h+dLeftSide.v),
        new GlPoint(-w.h-wOffsetRearWing.v+wRearWing.v, h.v, -d.h+dLeftSide.v),
        new GlPoint(-w.h, hLowerPart.v, -d.h+dLeftSide.v),
      ]),
      new GlTriangle([
        new GlPoint(-w.h, hLowerPart.v, -d.h+dLeftSide.v),
        new GlPoint(-w.h-wOffsetRearWing.v+wRearWing.v, h.v, -d.h+dLeftSide.v),
        new GlPoint(-w.h-wOffsetRearWing.v, h.v, -d.h+dLeftSide.v),
      ]),


      //front
      new GlTriangle([
        new GlPoint(w.h, 0.0, -d.h+dLeftSide.v),
        new GlPoint(w.h-wFrontWing.v-wFrontWheelOpening.v, hLowerPart.v, -d.h+dLeftSide.v),
        new GlPoint(w.h-wFrontWing.v-wFrontWheelOpening.v, hLowerPart.v, d.h-dRightSide.v),
        //new GlPoint(w.h-wFrontWing.v-wFrontWheelOpening.v, 0.0, -d.h+dLeftSide.v),
      ]),
      new GlTriangle([
        new GlPoint(w.h, 0.0, d.h-dRightSide.v),
        new GlPoint(w.h, 0.0, -d.h+dLeftSide.v),
        new GlPoint(w.h-wFrontWing.v-wFrontWheelOpening.v, hLowerPart.v, d.h-dRightSide.v),
      ]),

      //rear
      new GlRectangle.withHD(-w.h,0.0, -d.h+dLeftSide.v, hLowerPart.v, dMiddle.v, false),
      new GlRectangle.withHD(-w.h+wRearWheelOpening.v+wMiddleTopFront.v,hLowerPart.v, -d.h+dLeftSide.v, hLowerPart.v, dMiddle.v, true),

      //top

      new GlTriangle([
        //new GlPoint(-w.h+wRearWheelOpening.v+wMiddleTopRear.v, hLowerPart.v, d.h-dRightSide.v),
        new GlPoint(-w.h+wRearWheelOpening.v, hLowerPart.v, -d.h+dLeftSide.v),
        new GlPoint(-w.h+wRearWheelOpening.v, hLowerPart.v, d.h-dRightSide.v),
        new GlPoint(-w.h+wRearWheelOpening.v+wMiddleTopRear.v, h.v, d.h-dRightSide.v),
      ]),

      new GlTriangle([
        //new GlPoint(-w.h+wRearWheelOpening.v+wMiddleTopRear.v, hLowerPart.v, -d.h+dLeftSide.v),
        new GlPoint(-w.h+wRearWheelOpening.v, hLowerPart.v, -d.h+dLeftSide.v),
        new GlPoint(-w.h+wRearWheelOpening.v+wMiddleTopRear.v, h.v, d.h-dRightSide.v),
        new GlPoint(-w.h+wRearWheelOpening.v+wMiddleTopRear.v, h.v, -d.h+dLeftSide.v),
      ]),

      /*
      //hood
      new GlRectangle.withWD(w.h-wHood.v,hCarBottom.v, d.h-dStripeRight.v, wHood.v, dStripeRight.v, false),
      new GlRectangle.withWD(w.h-wHood.v,hCarBottom.v, -d.h, wHood.v, dStripeLeft.v, false),
      //rear top
      new GlRectangle.withWD(-w.h,hCarBottom.v, d.h-dStripeRight.v, wRear.v, dStripeRight.v, false),
      new GlRectangle.withWD(-w.h,hCarBottom.v, -d.h, wRear.v, dStripeLeft.v, false),
      //roof
      new GlRectangle.withWD(-w.h+wRear.v+wWindowRear.v,h.v, d.h-dWindow.v-dStripeRoofRight.v, wRoof.v, dStripeRoofRight.v, false),
      new GlRectangle.withWD(-w.h+wRear.v+wWindowRear.v,h.v, -d.h+dWindow.v, wRoof.v, dStripeRoofLeft.v, false),
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
*/
    ]));

    collection.loadModel(_ModelStripe, new GlAreaModel([/*
      //hood
      new GlRectangle.withWD(w.h-wHood.v,hCarBottom.v, -d.h+dStripeLeft.v, wHood.v, dStripeMid.v, false),
      //rear top
      new GlRectangle.withWD(-w.h,hCarBottom.v, -d.h+dStripeLeft.v, wRear.v, dStripeMid.v, false),
      //roof
      new GlRectangle.withWD(-w.h+wRear.v+wWindowRear.v,h.v, -d.h+dWindow.v+dStripeRoofLeft.v, wRoof.v, dStripeRoofMid.v, false),
*/
      // rear wing
      new GlRectangle.withWD(-w.h-wOffsetRearWing.v,h.v, -d.h, wRearWing.v, d.v, true),
      new GlRectangle.withWD(-w.h-wOffsetRearWing.v,h.v, -d.h, wRearWing.v, d.v, false),
      // front wing
      new GlRectangle.withWD(w.h-wFrontWing.v,1.0, -d.h, wFrontWing.v, d.v, true),
      new GlRectangle.withWD(w.h-wFrontWing.v,1.0, -d.h, wFrontWing.v, d.v, false),
    ]));

    collection.loadModel(_ModelWindows, new GlAreaModel([
      /*
      //WindowFront
      new GlTriangle([
        new GlPoint(w.h-wHood.v, hCarBottom.v, d.h),
        new GlPoint(w.h-wHood.v-wWindowFront.v, h.v, -d.h+dWindow.v),
        new GlPoint(w.h-wHood.v-wWindowFront.v, h.v, d.h-dWindow.v),
      ]),
      new GlTriangle([
        new GlPoint(w.h-wHood.v,hCarBottom.v,d.h),
        new GlPoint(w.h-wHood.v,hCarBottom.v,-d.h),
        new GlPoint(w.h-wHood.v-wWindowFront.v, h.v, -d.h+dWindow.v),
      ]),
      //WindowRear
      new GlTriangle([
        new GlPoint(-w.h+wRear.v, hCarBottom.v, d.h),
        new GlPoint(-w.h+wRear.v+wWindowRear.v, h.v, d.h-dWindow.v),
        new GlPoint(-w.h+wRear.v+wWindowRear.v, h.v, -d.h+dWindow.v),
      ]),
      new GlTriangle([
        new GlPoint(-w.h+wRear.v,hCarBottom.v,d.h),
        new GlPoint(-w.h+wRear.v+wWindowRear.v, h.v, -d.h+dWindow.v),
        new GlPoint(-w.h+wRear.v,hCarBottom.v,-d.h),
      ]),
      //windowLeft
      new GlTriangle([
        new GlPoint(-w.h+wRear.v,hCarBottom.v,d.h),
        new GlPoint(w.h-wHood.v-wWindowFront.v,h.v,d.h-dWindow.v),
        new GlPoint(-w.h+wRear.v+wWindowRear.v,h.v,d.h-dWindow.v),
      ]),
      new GlTriangle([
        new GlPoint(-w.h+wRear.v,hCarBottom.v,d.h),
        new GlPoint(w.h-wHood.v,hCarBottom.v,d.h),
        new GlPoint(w.h-wHood.v-wWindowFront.v,h.v,d.h-dWindow.v),
      ]),
      //windowRight
      new GlTriangle([
        new GlPoint(-w.h+wRear.v,hCarBottom.v,-d.h),
        new GlPoint(-w.h+wRear.v+wWindowRear.v,h.v,-d.h+dWindow.v),
        new GlPoint(w.h-wHood.v-wWindowFront.v,h.v,-d.h+dWindow.v),
      ]),
      new GlTriangle([
        new GlPoint(-w.h+wRear.v,hCarBottom.v,-d.h),
        new GlPoint(w.h-wHood.v-wWindowFront.v,h.v,-d.h+dWindow.v),
        new GlPoint(w.h-wHood.v,hCarBottom.v,-d.h),
      ]),
      */
    ]));
    collection.loadModel(_ModelWheel, new GlCube.fromTopCenter(0.0,0.0,0.0,wWheel.v,hWheel.v,dWheel.v));
  }
}