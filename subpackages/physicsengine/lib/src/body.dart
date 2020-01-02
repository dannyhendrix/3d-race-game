part of physicsengine;

class Body {
  final Vector velocity = new Vector(0, 0);
  final Vector force = new Vector(0, 0);
  double angularVelocity;
  double torque;
  double staticFriction;
  double dynamicFriction;
  double restitution;
  PolygonShape shape;

  Body(this.shape, double x, double y) {
    velocity.reset();
    angularVelocity = 0;
    torque = 0;
    force.reset();
    staticFriction = 0.5;
    dynamicFriction = 0.3;
    restitution = 0.2;

    shape.move(x, y, 0.0);
  }

  void applyForce(Vector f) {
    force.addVectorToThis(f);
  }

  void applyImpulse(Vector impulse, Vector contactVector) {
    velocity.addToThis(impulse.x * shape.invMass, impulse.y * shape.invMass);
    angularVelocity += shape.invInertia * contactVector.crossProductThis(impulse);
  }

  void setStatic() {
    shape.inertia = 0.0;
    shape.invInertia = 0.0;
    shape.mass = 0.0;
    shape.invMass = 0.0;
  }
}
