part of micromachines;

class Trailer extends MoveableGameObject{
  Vehicle vehicle;
  Point2d wheelPoint;
  Point2d vehicleSnapPoint;
  Trailer(this.vehicle){
    w = 50.0;
    h = 30.0;
    double hw = w/2;
    double hh = h/2;
    wheelPoint = new Point2d(0.0,0.0);
    vehicleSnapPoint = new Point2d(hw+25.0,0.0);
    r = vehicle.r;
    var M = vehicle.getTransformation();
    position = M.apply(vehicle.trailerSnapPoint-vehicleSnapPoint);
    collisionField = new Polygon([
      new Point2d(-hw,-hh),
      new Point2d(hw,-hh),
      new Point2d(hw,hh),
      new Point2d(-hw,hh),
    ]);
  }
  void update(){
    Matrix2d Mv = new Matrix2d.translationPoint(vehicle.position);
    Mv = Mv.rotate(vehicle.r);
    Matrix2d Mt = new Matrix2d.translationPoint(position);
    Mt = Mt.rotate(r);
    var A = Mv.apply(vehicle.trailerSnapPoint);
    var B = Mt.apply(wheelPoint);
    //var force = (new Matrix2d.rotation(rTrailer)).apply(new Point2d(15.0,0.0));
    r = B.angleWith(A);

    Matrix2d M = new Matrix2d.translationPoint(A);
    M = M.rotate(r);
    position = M.apply(-vehicleSnapPoint);
  }
}