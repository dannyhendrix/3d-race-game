part of gameutils.math;

class Point{
  double x,y;
  Point(this.x,this.y);
  Point operator +(Point p) => new Point(x + p.x, y + p.y);
  Point operator -(Point p) => new Point(x - p.x, y - p.y);
  Point operator -() => new Point(-x,-y);
  Vector operator *(num factor) => new Vector(x*factor, y*factor);
  bool operator ==(Point p) => x == p.x && y == p.y;
  int get hashCode => x.hashCode ^ y.hashCode;
  double dotProduct(Point v) => x*v.x+y*v.y;
  double distanceTo(Point p){
    double nx = p.x-x;
    double ny = p.y-y;
    return Math.sqrt(nx*nx+ny*ny);
  }
  double angleWith(Point p){
    return Math.atan2(p.y - y, p.x - x);
  }
  Point rotate(double r, Point origin){
    Point translated = this - origin;
    Point rotated = new Point(
        translated.x * Math.cos(r) - translated.y * Math.sin(r),
        translated.x * Math.sin(r) + translated.y * Math.cos(r)
    );
    return rotated + origin;
  }
}