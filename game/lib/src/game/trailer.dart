part of micromachines;

abstract class Trailer extends GameItemMovable{
  Vehicle vehicle;
  Vector wheelPoint;
  Vector vehicleSnapPoint;

  Trailer(this.vehicle, Polygon polygon) : super(polygon){
    vehicle.trailer = this;
  }
  void updateVehiclePosition();
  void update();
}
/*
abstract class SimpleTrailer extends Trailer{
  SimpleTrailer(Vehicle vehicle, Polygon polygon) : super(vehicle, polygon);

  void updateVehiclePosition(){
    var M = vehicle.getTransformation();
    position = M.apply(vehicle.trailerSnapPoint-vehicleSnapPoint);
    r = vehicle.r;
    teleport();
  }
  void update(){
    Matrix2d Mv = new Matrix2d.translationVector(vehicle.position);
    Mv = Mv.rotate(vehicle.r);
    Matrix2d Mt = new Matrix2d.translationVector(position);
    Mt = Mt.rotate(r);
    var A = Mv.apply(vehicle.trailerSnapPoint);
    var B = Mt.apply(wheelPoint);
    //var force = (new Matrix2d.rotation(rTrailer)).apply(new Point2d(15.0,0.0));
    r = B.angleWith(A);

    Matrix2d M = new Matrix2d.translationVector(A);
    M = M.rotate(r);
    position = M.apply(-vehicleSnapPoint);
  }
}
*/
class NullTrailer extends Trailer{
  NullTrailer(Vehicle vehicle) : super(vehicle, Polygon.createSquare(0.0, 0.0, 0.0, 0.0, 0.0)){
    wheelPoint = new Vector(0.0,0.0);
    vehicleSnapPoint = new Vector(0.0,0.0);
    vehicle.trailer = this;
  }
  void updateVehiclePosition(){}
  void update(){}
}
/*
class Caravan extends SimpleTrailer{
  Caravan(Vehicle vehicle) : super(vehicle, Polygon.createSquare(0.0, 0.0, 50.0, 30.0, 0.0)){
    wheelPoint = new Vector(0.0,0.0);
    vehicleSnapPoint = new Vector(15.0+25.0,0.0);
    updateVehiclePosition();
  }
}

class TruckTrailer extends SimpleTrailer{
  TruckTrailer(Vehicle vehicle) : super(vehicle, Polygon.createSquare(0.0, 0.0, 100.0, 40.0, 0.0)){
    this.vehicle = vehicle;
    wheelPoint = new Vector(-25.0,0.0);
    vehicleSnapPoint = new Vector(50.0-10.0,0.0);
    //TODO: this is a special case with collisions
    /*
    w = 100.0;
    h = 40.0;
    double hw = w/2;
    double hh = h/2;
    relativeCollisionFields = [new Polygon([
      new Point2d(-hw,-hh),
      new Point2d(hw-40.0,-hh),
      new Point2d(hw-40.0,hh),
      new Point2d(-hw,hh),
    ])];*/
    updateVehiclePosition();
  }
}*/