part of micromachines;

class CheckPoint extends GameObject{
  Game game;
  CheckPoint(this.game, double nx, double ny, [double nr = 0.0]){
    position = new Point(nx,ny);
    w = 20.0;
    h = 20.0;
    r = nr;
    collisionField = new Polygon([
      new Point(0.0,0.0),
      new Point(w,0.0),
      new Point(w,h),
      new Point(0.0,h),
    ]);
  }
  bool onCollision(GameObject other){
    //TODO: what should this do?
    // Everytime you hit it you mark it as checked?
    return true;
  }
}