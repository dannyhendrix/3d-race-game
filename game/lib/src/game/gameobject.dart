part of micromachines;
class GameObject{
  double x,y,r;
  int w,h;
  Polygon collisionField = new Polygon([]);

  bool collides(GameObject other){
    return createPolygonOnActualLocation().collision(other.createPolygonOnActualLocation(), new Vector.empty()).intersect;
  }

  Polygon createPolygonOnActualLocation(){
    return collisionField.translate(new Point(x,y), new Point(w/2,h/2)).rotate(r,new Point(x,y));
  }
}