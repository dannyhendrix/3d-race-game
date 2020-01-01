part of physicsengine;

class Body {
  final Vector velocity = new Vector(0, 0);
  final Vector force = new Vector(0, 0);
  double angularVelocity;
  double torque;
  double mass, invMass, inertia, invInertia;
  double staticFriction;
  double dynamicFriction;
  double restitution;
  PolygonShape shape;
  Mat2 m = Mat2();
  Vector position;

  Body(this.shape, double x, double y) {
    position = Vector(x, y);
    shape.apply(Mat2(), position);
    velocity.reset();
    angularVelocity = 0;
    torque = 0;
    force.reset();
    staticFriction = 0.5;
    dynamicFriction = 0.3;
    restitution = 0.2;

    shape.body = this;
    shape.initialize();
  }

  void applyForce(Vector f) {
    force.addVectorToThis(f);
  }

  void applyImpulse(Vector impulse, Vector contactVector) {
    velocity.addToThis(impulse.x * invMass, impulse.y * invMass);
    angularVelocity += invInertia * contactVector.crossProductThis(impulse);
  }

  void setStatic() {
    inertia = 0.0;
    invInertia = 0.0;
    mass = 0.0;
    invMass = 0.0;
  }
}
