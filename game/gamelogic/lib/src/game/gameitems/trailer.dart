part of game;

abstract class Trailer extends GameItemMovable {
  Vehicle vehicle;
  Vector wheelPoint;
  Vector vehicleSnapPoint;

  Trailer(Polygon polygon) {
    setPolygon(polygon);
  }
}

class NullTrailer extends Trailer {
  NullTrailer() : super(Polygon.createSquare(0.0, 0.0, 0.0, 0.0, 0.0)) {
    wheelPoint = new Vector(0.0, 0.0);
    vehicleSnapPoint = new Vector(0.0, 0.0);
  }
}

class Caravan extends Trailer {
  Caravan() : super(Polygon.createSquare(0.0, 0.0, GameConstants.caravanSize.x, GameConstants.caravanSize.y, 0.0)) {
    wheelPoint = new Vector(0.0, 0.0);
    vehicleSnapPoint = new Vector(15.0 + 25.0, 0.0);
  }
}

class TruckTrailer extends Trailer {
  TruckTrailer() : super(Polygon.createSquare(0.0, 0.0, GameConstants.truckTrailerSize.x, GameConstants.truckTrailerSize.y, 0.0)) {
    wheelPoint = new Vector(-25.0, 0.0);
    vehicleSnapPoint = new Vector(50.0 - 10.0, 0.0);
  }
}
