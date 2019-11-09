part of game;

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

abstract class SimpleTrailer extends Trailer{
  SimpleTrailer(Vehicle vehicle, Polygon polygon) : super(vehicle, polygon);

  void updateVehiclePosition(){
    var offset = vehicle.trailerSnapPoint-vehicleSnapPoint;
    var m = new Matrix2d()
        .translateThisVector(vehicle.position)
        .rotateThis(vehicle.r)
        .translateThis(offset.x, offset.y)
    //.translateThis(-offsetx, -offsety)
        ;

    applyMatrix(m);
    r = vehicle.r;
  }
  void update(){
    Matrix2d Mv = new Matrix2d.translationVector(vehicle.position).rotateThis(vehicle.r);
    Matrix2d Mt = new Matrix2d.translationVector(this.position).rotateThis(r);

    var A = Mv.apply(vehicle.trailerSnapPoint);
    var B = Mt.apply(wheelPoint);
    //var force = (new Matrix2d.rotation(rTrailer)).apply(new Point2d(15.0,0.0));
    var newr = B.angleWithThis(A);



    Matrix2d M = new Matrix2d.translationVector(A).rotateThis(newr);
    var position = M.apply(-vehicleSnapPoint);
    Teleport(position-this.position, newr-r);
  }
}

class NullTrailer extends Trailer{
  NullTrailer(Vehicle vehicle) : super(vehicle, Polygon.createSquare(0.0, 0.0, 0.0, 0.0, 0.0)){
    wheelPoint = new Vector(0.0,0.0);
    vehicleSnapPoint = new Vector(0.0,0.0);
    vehicle.trailer = this;
  }
  void updateVehiclePosition(){}
  void update(){}
}

class Caravan extends SimpleTrailer{
  Caravan(Vehicle vehicle) : super(vehicle, Polygon.createSquare(0.0, 0.0, GameConstants.caravanSize.x, GameConstants.caravanSize.y, 0.0)){
    wheelPoint = new Vector(0.0,0.0);
    vehicleSnapPoint = new Vector(15.0+25.0,0.0);
    updateVehiclePosition();
  }
}

class TruckTrailer extends SimpleTrailer{
  TruckTrailer(Vehicle vehicle) : super(vehicle, Polygon.createSquare(0.0, 0.0, GameConstants.truckTrailerSize.x, GameConstants.truckTrailerSize.y, 0.0)){
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
}