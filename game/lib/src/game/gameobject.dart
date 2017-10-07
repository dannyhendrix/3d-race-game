part of micromachines;
class GameObject{
  Point position;
  double r;
  double w,h;
  Polygon collisionField = new Polygon([]);

  bool collides(GameObject other){
    return createPolygonOnActualLocation(collisionField).collisionWithVector(other.createPolygonOnActualLocation(other.collisionField), new Vector.empty()).intersect;
  }
  bool onCollision(GameObject other){
    return false;
  }

  //TODO: make function that returns transformation matrix instead, then apply that matrix on the polygons
  Polygon createPolygonOnActualLocation(Polygon original){
    return original.translate(position, new Point(0.0,0.0)).rotate(r,position);
  }
}