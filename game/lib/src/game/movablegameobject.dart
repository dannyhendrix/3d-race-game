part of micromachines;
class MoveableGameObject extends GameObject{
  Vector vector = new Vector.empty();
  void update(){}
  void resetCache(){
    setAbsoluteCollisionFieldsCache();
  }
}