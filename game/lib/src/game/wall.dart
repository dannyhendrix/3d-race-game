part of micromachines;

class Wall extends GameObject{
  Wall.zeroOnLeftTop(double nx, double ny, double nw, double nh):this(nx+nw/2,ny+nh/2,nw,nh);
  Wall(double nx, double ny, double nw, double nh, [double nr = 0.0]){
    position = new Point(nx,ny);
    w = nw;
    h = nh;
    r = nr;

    collisionField = new Polygon([
      new Point(0.0,0.0),
      new Point(w,0.0),
      new Point(w,h),
      new Point(0.0,h),
    ]);
  }
}