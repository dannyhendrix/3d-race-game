part of micromachines;

class Wall extends GameObject{
  Wall.zeroOnLeftTop(double nx, double ny, double nw, double nh):this(nx+nw/2,ny+nh/2,nw,nh);
  Wall(double nx, double ny, double nw, double nh, [double nr = 0.0]){
    position = new Point(nx,ny);
    w = nw;
    h = nh;
    r = nr;

    double hw = w/2;
    double hh= h/2;
    collisionField = new Polygon([
      new Point(-hw,-hh),
      new Point(hw,-hh),
      new Point(hw,hh),
      new Point(-hw,hh),
    ]);
  }
}