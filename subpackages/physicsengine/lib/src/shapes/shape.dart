part of physicsengine;

enum Type { Circle, Poly, Count }

abstract class Shape {
  Body body;
  double radius;
  Mat2 u = Mat2();

  Shape() {}

  void initialize();

  void computeMass(double density);

  void setOrient(double radians);

  Type getType();
}
