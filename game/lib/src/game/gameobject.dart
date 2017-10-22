part of micromachines;
class GameObjectCollisionPolygon{
  int collisionFieldIndex;
  int collisionFieldIndexOther;
  CollisionResult collisionResult;
  GameObjectCollisionPolygon(this.collisionFieldIndex, this.collisionFieldIndexOther, [this.collisionResult = null]);
}
class GameObjectCollision{
  List<GameObjectCollisionPolygon> polygonCollisions;
  bool collision;
  GameObject A;
  GameObject B;
  GameObjectCollision(this.A, this.B, this.collision, this.polygonCollisions);
}
class GameObjectPolygonCollision{
  List<int> polygonCollisions;
  bool collision;
  GameObject A;
  Polygon B;
  GameObjectPolygonCollision(this.A, this.B, this.collision, this.polygonCollisions);
}

class GameObject{
  Point2d position;
  double r;
  double w,h;
  List<Polygon> collisionField = [];

  GameObjectCollision collides(GameObject other, [bool checkAllPolygons = false]){
    Matrix2d M = getTransformation();
    Matrix2d oM = other.getTransformation();
    List<GameObjectCollisionPolygon> polygonCollisions = [];
    bool found = false;
    bool stop = false;
    for(int ai =0; !stop && ai<collisionField.length; ai++){
      Polygon A = collisionField[ai].applyMatrix(M);
      for(int bi =0; !stop && bi<other.collisionField.length; bi++){
        Polygon B = other.collisionField[bi].applyMatrix(oM);
        if(A.collision(B)){
          polygonCollisions.add(new GameObjectCollisionPolygon(ai,bi));
          found = true;
          if(!checkAllPolygons) stop = true;
        }
      }
    }
    return new GameObjectCollision(this, other, found,polygonCollisions);
  }
  GameObjectCollision collidesVector(Vector V, GameObject other, [bool checkAllPolygons = false]){
    Matrix2d M = getTransformation();
    Matrix2d oM = other.getTransformation();
    List<GameObjectCollisionPolygon> polygonCollisions = [];
    bool found = false;
    bool stop = false;
    for(int ai =0; !stop && ai<collisionField.length; ai++){
      Polygon A = collisionField[ai].applyMatrix(M);
      for(int bi =0; !stop && bi<other.collisionField.length; bi++){
        Polygon B = other.collisionField[bi].applyMatrix(oM);
        CollisionResult c = A.collisionWithVector(B,V);
        if(c.intersect || c.willIntersect){
          polygonCollisions.add(new GameObjectCollisionPolygon(ai,bi,c));
          found = true;
          if(!checkAllPolygons) stop = true;
        }
      }
    }
    return new GameObjectCollision(this, other, found,polygonCollisions);
  }
  GameObjectPolygonCollision collidesPolygon(Polygon B, [bool checkAllPolygons = false]){
    Matrix2d M = getTransformation();
    List<int> polygonCollisions = [];
    bool found = false;
    bool stop = false;
    for(int ai =0; !stop && ai<collisionField.length; ai++){
      Polygon A = collisionField[ai].applyMatrix(M);
      if(A.collision(B)){
        polygonCollisions.add(ai);
        found = true;
        if(!checkAllPolygons) stop = true;
      }
    }
    return new GameObjectPolygonCollision(this, B, found,polygonCollisions);
  }
  bool onCollision(GameObjectCollision collision){
    return false;
  }

  Matrix2d getTransformation(){
    Matrix2d M = new Matrix2d.translationPoint(position);
    return M.rotate(r);
  }
}