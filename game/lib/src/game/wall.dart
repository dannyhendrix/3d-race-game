part of micromachines;

class Wall extends GameObject{
  Wall.zeroOnLeftTop(ouble nx, double ny, int nw, int nh):this(nx+nw/2,ny+nh/2,nw,nh);
  Wall(double nx, double ny, int nw, int nh, [double nr = 0.0]){
    x = nx;
    y = ny;
    w = nw;
    h = nh;
    r = nr;

    collisionField = new Polygon([
      new Point(0,0),
      new Point(w,0),
      new Point(w,h),
      new Point(0,h),
    ]);
  }
}