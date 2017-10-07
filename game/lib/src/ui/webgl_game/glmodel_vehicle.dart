part of webgl_game;

class DoubleHelper{
  double v;
  double h;
  DoubleHelper(double v, double s) : v = v*s, h = v*s/2;
}

class GlModel_Vehicle{

  static const String _ModelBody = "vehicle_body";
  static const String _ModelStripe = "vehicle_stripe";
  static const String _ModelWindows = "vehicle_windows";

  GlModelInstanceCollection getModelInstance(GlModelCollection collection, GlColor colorBase, GlColor colorStripe, GlColor colorWindow){
    return new GlModelInstanceCollection([
      new GlModelInstance(collection.getModelBuffer(_ModelBody), colorBase),
      new GlModelInstance(collection.getModelBuffer(_ModelStripe), colorStripe),
      new GlModelInstance(collection.getModelBuffer(_ModelWindows), colorWindow),
    ]);
  }
  GlModel loadModel(GlModelCollection collection, double sx, double sy, double sz){
    GlColor colorWindows = new GlColor(0.2,0.2,0.2);
    GlColor color1 = new GlColor(1.0,1.0,1.0);
    GlColor color2 = new GlColor(0.5,0.5,0.5);

    DoubleHelper h = new DoubleHelper(1.0,sy);
    DoubleHelper hCarBottom = new DoubleHelper(0.5,sy);
    DoubleHelper hWindow = new DoubleHelper(0.5,sy);

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
    DoubleHelper wHood = new DoubleHelper(0.3,sx);
    DoubleHelper wRoof = new DoubleHelper(0.3,sx);
    DoubleHelper wRear = new DoubleHelper(0.2,sx);
    DoubleHelper wWindowFront = new DoubleHelper(0.1,sx);
    DoubleHelper wWindowRear = new DoubleHelper(0.1,sx);

    collection.loadModel(_ModelBody, new GlAreaModel([
      //floor
      new GlRectangle.withWD(-w.h,0.0, -d.h, w.v, d.v, true),
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

    ]));

    collection.loadModel(_ModelStripe, new GlAreaModel([
      //hood
      new GlRectangle.withWD(w.h-wHood.v,hCarBottom.v, -d.h+dStripeLeft.v, wHood.v, dStripeMid.v, false),
      //rear top
      new GlRectangle.withWD(-w.h,hCarBottom.v, -d.h+dStripeLeft.v, wRear.v, dStripeMid.v, false),
      //roof
      new GlRectangle.withWD(-w.h+wRear.v+wWindowRear.v,h.v, -d.h+dWindow.v+dStripeRoofLeft.v, wRoof.v, dStripeRoofMid.v, false),

    ]));

    collection.loadModel(_ModelWindows, new GlAreaModel([
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
    ]));
  }
}