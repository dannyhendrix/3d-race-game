part of physicsengine;

class CollisionHandler {
  static final double EPSILON = 0.0001;
  static final double PENETRATION_ALLOWANCE = 0.05;
  static final double PENETRATION_CORRETION = 0.4;

  void initialize(Manifold manifold) {
    // Calculate average restitution
    manifold.e = min(manifold.A.restitution, manifold.B.restitution);

    // Calculate static and dynamic friction
    manifold.staticForce = sqrt(manifold.A.staticFriction * manifold.A.staticFriction + manifold.B.staticFriction * manifold.B.staticFriction);
    manifold.dynamicForce = sqrt(manifold.A.dynamicFriction * manifold.A.dynamicFriction + manifold.B.dynamicFriction * manifold.B.dynamicFriction);
  }

  void applyImpulse(Manifold manifold) {
    // Early out and positional correct if both objects have infinite mass
    if (_equal(manifold.A.invMass + manifold.B.invMass, 0)) {
      _infiniteMassCorrection(manifold);
      return;
    }

    for (int i = 0; i < manifold.contactCount; ++i) {
      // Calculate radii from COM to contact
      Vector ra = manifold.contacts[i].clone()..subtractToThis(manifold.A.center);
      Vector rb = manifold.contacts[i].clone()..subtractToThis(manifold.B.center);

      // Relative velocity
      Vector rv = manifold.B.velocity.clone()
        ..addVectorToThis((rb.clone()..crossProductToThis(-manifold.B.angularVelocity)))
        ..subtractToThis(manifold.A.velocity)
        ..subtractToThis((ra.clone()..crossProductToThis(-manifold.A.angularVelocity)));

      // Relative velocity along the normal
      double contactVel = rv.dotProductThis(manifold.normal);

      // Do not resolve if velocities are separating
      if (contactVel > 0) return;

      double raCrossN = ra.crossProductThis(manifold.normal);
      double rbCrossN = rb.crossProductThis(manifold.normal);
      double invMassSum = manifold.A.invMass + manifold.B.invMass + (raCrossN * raCrossN) * manifold.A.invInertia + (rbCrossN * rbCrossN) * manifold.B.invInertia;

      // Calculate impulse scalar
      double j = -(1.0 + manifold.e) * contactVel;
      j /= invMassSum;
      j /= manifold.contactCount;

      // Apply impulse
      var impulse = manifold.normal.clone()..multiplyToThis(j);
      _applyImpulse(manifold.A, impulse.clone()..negateThis(), ra);
      _applyImpulse(manifold.B, impulse, rb);

      // Friction impulse
      rv = manifold.B.velocity.clone()
        ..addVectorToThis((rb.clone()..crossProductToThis(-manifold.B.angularVelocity)))
        ..subtractToThis(manifold.A.velocity)
        ..subtractToThis((ra.clone()..crossProductToThis(-manifold.A.angularVelocity)));

      Vector t = rv.clone();
      var s = -rv.dotProductThis(manifold.normal);
      t.addToThis(manifold.normal.x * s, manifold.normal.y * s);
      t.normalizeThis();

      // j tangent magnitude
      double jt = -rv.dotProductThis(t);
      jt /= invMassSum;
      jt /= manifold.contactCount;

      // Don't apply tiny friction impulses
      if (_equal(jt, 0.0)) return;

      // Coulumb's law
      Vector tangentImpulse;
      if (jt.abs() < j * manifold.staticForce) {
        tangentImpulse = t.clone()..multiplyToThis(jt);
      } else {
        tangentImpulse = t.clone()..multiplyToThis(j)..multiplyToThis(-manifold.dynamicForce);
      }

      // Apply friction impulse
      _applyImpulse(manifold.A, tangentImpulse.clone()..negateThis(), ra);
      _applyImpulse(manifold.B, tangentImpulse, rb);
    }
  }

  void positionalCorrection(Manifold manifold) {
    var correction = max(manifold.penetration - PENETRATION_ALLOWANCE, 0.0) / (manifold.A.invMass + manifold.B.invMass) * PENETRATION_CORRETION;

    var correctionA = -manifold.A.invMass * correction;
    var correctionB = manifold.B.invMass * correction;

    manifold.A.move(manifold.normal.x * correctionA, manifold.normal.y * correctionA, 0.0);
    manifold.B.move(manifold.normal.x * correctionB, manifold.normal.y * correctionB, 0.0);
  }

  void integrateVelocity(PhysicsObject b, double dt) {
    if (b.invMass == 0.0) return;

    b.move(b.velocity.x * dt, b.velocity.y * dt, b.angularVelocity * dt);

    integrateForces(b, dt);
  }

  void integrateForces(PhysicsObject b, double dt) {
    if (b.invMass == 0.0) return;
    var friction = 900.0;
    double dts = dt * 0.5;
    var s = b.invMass * dts;
    b.velocity.addToThis(b.force.x * s, b.force.y * s);
    b.velocity.addToThis(-b.velocity.x * s * friction, -b.velocity.y * s * friction);
    //b.velocity.addToThis(ImpulseMath.GRAVITY.x * dts, ImpulseMath.GRAVITY.y * dts);
    b.angularVelocity += b.torque * b.invInertia * dts;
    b.angularVelocity += -b.angularVelocity * b.invInertia * dts * 900000.0;
  }

  void _applyImpulse(PhysicsObject polygon, Vector impulse, Vector contactVector) {
    polygon.velocity.addToThis(impulse.x * polygon.invMass, impulse.y * polygon.invMass);
    polygon.angularVelocity += polygon.invInertia * contactVector.crossProductThis(impulse);
  }

  void _infiniteMassCorrection(Manifold manifold) {
    manifold.A.velocity.reset();
    manifold.B.velocity.reset();
  }

  bool _equal(double a, double b) {
    return (a - b).abs() <= EPSILON;
  }
}
