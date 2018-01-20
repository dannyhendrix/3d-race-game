part of micromachines;

class Tree extends GameObject{
  Tree(double nx, double ny, [double nr = 0.0]){
    position = new Point2d(nx,ny);
    w = 20.0;
    h = 20.0;
    r = nr;

    double hw = w/2;
    double hh= h/2;
    relativeCollisionFields = [new Polygon([
      new Point2d(-hw,-hh),
      new Point2d(hw,-hh),
      new Point2d(hw,hh),
      new Point2d(-hw,hh),
    ])];
    setAbsoluteCollisionFieldsCache();
  }
}