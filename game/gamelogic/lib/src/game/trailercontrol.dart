part of game;

class TrailerControl {
  void connectToVehicle(Trailer trailer, Vehicle vehicle) {
    trailer.vehicle = vehicle;
    vehicle.trailer = trailer;
    var offset = vehicle.trailerSnapPoint - trailer.vehicleSnapPoint;
    var m = new Matrix2d().translateThisVector(vehicle.position).rotateThis(vehicle.r).translateThis(offset.x, offset.y);

    trailer.applyMatrix(m);
    trailer.r = vehicle.r;
  }

  void update(Trailer trailer) {
    Matrix2d Mv = new Matrix2d.translationVector(trailer.vehicle.position).rotateThis(trailer.vehicle.r);
    Matrix2d Mt = new Matrix2d.translationVector(trailer.position).rotateThis(trailer.r);

    var A = Mv.apply(trailer.vehicle.trailerSnapPoint);
    var B = Mt.apply(trailer.wheelPoint);
    //var force = (new Matrix2d.rotation(rTrailer)).apply(new Point2d(15.0,0.0));
    var newr = B.angleWithThis(A);

    Matrix2d M = new Matrix2d.translationVector(A).rotateThis(newr);
    var position = M.apply(-trailer.vehicleSnapPoint);
    trailer.applyOffsetRotation(position - trailer.position, newr - trailer.r);
  }
}
