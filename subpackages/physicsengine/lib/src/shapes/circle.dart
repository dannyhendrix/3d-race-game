part of physicsengine;

class Circle extends Shape {
  Circle(double r) {
    radius = r;
  }

  @override
  void initialize() {
    computeMass(1.0);
  }

  @override
  void computeMass(double density) {
    body.mass = ImpulseMath.PI * radius * radius * density;
    body.invMass = (body.mass != 0.0) ? 1.0 / body.mass : 0.0;
    body.inertia = body.mass * radius * radius;
    body.invInertia = (body.inertia != 0.0) ? 1.0 / body.inertia : 0.0;
  }

  @override
  void setOrient(double radians) {}

  @override
  Type getType() {
    return Type.Circle;
  }
}
