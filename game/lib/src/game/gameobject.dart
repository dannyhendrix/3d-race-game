part of micromachines;
class GameObject{
  Point position;
  double r;
  double w,h;
  Polygon collisionField = new Polygon([]);

  bool collides(GameObject other){
    return createPolygonOnActualLocation().collision(other.createPolygonOnActualLocation(), new Vector.empty()).intersect;
  }

  Polygon createPolygonOnActualLocation(){
    return collisionField.translate(position, new Point(w/2,h/2)).rotate(r,position);
  }
}