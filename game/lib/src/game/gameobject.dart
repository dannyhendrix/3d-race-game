part of micromachines;
class GameObject{
  Point2d position;
  double r;
  double w,h;
  Polygon collisionField = new Polygon([]);

  bool collides(GameObject other){
    Matrix2d M = getTransformation();
    Polygon A = collisionField.applyMatrix(M);
    Matrix2d oM = other.getTransformation();
    Polygon B = other.collisionField.applyMatrix(oM);
    return A.collision(B);
  }
  bool onCollision(GameObject other){
    return false;
  }

  Matrix2d getTransformation(){
    Matrix2d M = new Matrix2d.translationPoint(position);
    return M.rotate(r);
  }
}