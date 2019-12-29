part of physicsengine;

class Body {
  final Vec2 position = new Vec2(0, 0);
  final Vec2 velocity = new Vec2(0, 0);
  final Vec2 force = new Vec2(0, 0);
  double angularVelocity;
  double torque;
  double orient;
  double mass, invMass, inertia, invInertia;
  double staticFriction;
  double dynamicFriction;
  double restitution;
  Shape shape;

  Body(this.shape, double x, double y) {
    this.shape = shape;

    position.change(x, y);
    velocity.change(0, 0);
    angularVelocity = 0;
    torque = 0;
    orient = ImpulseMath.randomDouble(-ImpulseMath.PI, ImpulseMath.PI);
    force.change(0, 0);
    staticFriction = 0.5;
    dynamicFriction = 0.3;
    restitution = 0.2;

    shape.body = this;
    shape.initialize();
  }

  void applyForce(Vec2 f) {
    force.addV(f);
  }

  void applyImpulse(Vec2 impulse, Vec2 contactVector) {
    velocity.addVs(impulse, invMass);
    angularVelocity += invInertia * contactVector.crossV(impulse);
  }

  void setStatic() {
    inertia = 0.0;
    invInertia = 0.0;
    mass = 0.0;
    invMass = 0.0;
  }

  void setOrient(double radians) {
    orient = radians;
    shape.setOrient(radians);
  }
}
