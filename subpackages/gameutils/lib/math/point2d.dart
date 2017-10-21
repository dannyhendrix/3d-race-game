part of gameutils.math;

class Point2d{
  double x,y;
  Point2d(this.x,this.y);
  Point2d operator +(Point2d p) => new Point2d(x + p.x, y + p.y);
  Point2d operator -(Point2d p) => new Point2d(x - p.x, y - p.y);
  Point2d operator -() => new Point2d(-x,-y);
  Vector operator *(num factor) => new Vector(x*factor, y*factor);
  bool operator ==(Point2d p) => x == p.x && y == p.y;
  int get hashCode => x.hashCode ^ y.hashCode;
  double dotProduct(Point2d v) => x*v.x+y*v.y;
  double distanceTo(Point2d p){
    double nx = p.x-x;
    double ny = p.y-y;
    return Math.sqrt(nx*nx+ny*ny);
  }
  double angleWith(Point2d p){
    return Math.atan2(p.y - y, p.x - x);
  }
  Point2d rotate(double r, Point2d origin){
    Point2d translated = this - origin;
    Point2d rotated = new Point2d(
        translated.x * Math.cos(r) - translated.y * Math.sin(r),
        translated.x * Math.sin(r) + translated.y * Math.cos(r)
    );
    return rotated + origin;
  }
}