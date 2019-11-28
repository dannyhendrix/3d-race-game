part of game;

class Wall extends GameItemStatic{
  double w = 0.0;
  double h = 0.0;
  Wall.zeroOnLeftTop(double nx, double ny, double nw, double nh) : this(nx+nw/2,ny+nh/2,nw,nh);
  Wall(double nx, double ny, double nw, double nh, [double nr = 0.0]) : super(Polygon.createSquare(nx, ny, nw, nh, nr)){
    w = nw;
    h = nh;
    r = nr;
  }
}