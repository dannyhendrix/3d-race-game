/**
@author Danny Hendrix
**/
part of gameutils.math;

/**
Simple vector class
**/
class Vector extends Point{

  Vector(double x, double y):super(x,y);
  Vector.empty():this(0.0,0.0);
  Vector.fromAngleDegrees(double angle, double power):this.fromAngleRadians(_toRadians(angle),power);
  Vector.fromAngleRadians(double angle, double power):this(Math.cos(angle) * power, Math.sin(angle) * power);
  
  double _toRadians(num degree) =>  Math.PI / 180 * degree;
  double get magnitude => Math.sqrt(x*x+y*y);
  Vector get normalized {
    double m = magnitude;
    return new Vector(x / m, y / m);
  }
  double get angle => Math.atan2(y,x);
}
