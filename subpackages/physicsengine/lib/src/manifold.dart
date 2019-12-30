part of physicsengine;

class Manifold {
  Body A;
  Body B;
  double penetration;
  final Vec2 normal = new Vec2(0, 0);
  final List<Vec2> contacts = [new Vec2(0, 0), new Vec2(0, 0)];
  int contactCount;
  double e;
  double df;
  double sf;
  CollisionHandler _collisionHandler = new CollisionHandler();

  Manifold(Body a, Body b) {
    A = a;
    B = b;
  }

  void solve() {
    _collisionHandler.handleCollision(this, A, B);
  }

  void initialize() {
    // Calculate average restitution
    e = min(A.restitution, B.restitution);

    // Calculate static and dynamic friction
    sf = sqrt(A.staticFriction * A.staticFriction + B.staticFriction * B.staticFriction);
    df = sqrt(A.dynamicFriction * A.dynamicFriction + B.dynamicFriction * B.dynamicFriction);

    for (int i = 0; i < contactCount; ++i) {
      // Calculate radii from COM to contact
      Vec2 ra = contacts[i].clone()..subV(A.m.position());
      Vec2 rb = contacts[i].clone()..subV(B.m.position());

      Vector rv = B.velocity.clone()
        ..addVectorToThis(rb.clone().toVector().crossProductToThis(B.angularVelocity))
        ..subtractToThis(A.velocity)
        ..subtractToThis(ra.clone().toVector()..crossProductToThis(A.angularVelocity));

      // Determine if we should perform a resting collision or not
      // The idea is if the only thing moving this object is gravity,
      // then the collision should be performed without any restitution
      if (rv.magnitudeSquared() < ImpulseMath.RESTING) {
        e = 0.0;
      }
    }
  }

  void applyImpulse() {
    // Early out and positional correct if both objects have infinite mass
    if (ImpulseMath.equal(A.invMass + B.invMass, 0)) {
      infiniteMassCorrection();
      return;
    }

    for (int i = 0; i < contactCount; ++i) {
      // Calculate radii from COM to contact
      Vec2 ra = contacts[i].clone()..subV(A.m.position());
      Vec2 rb = contacts[i].clone()..subV(B.m.position());

      // Relative velocity
      Vector rv = B.velocity.clone()
        ..addVectorToThis((rb.clone()..crossAv(B.angularVelocity, rb)).toVector())
        ..subtractToThis(A.velocity)
        ..subtractToThis((ra.clone()..crossAv(A.angularVelocity, ra)).toVector());

      // Relative velocity along the normal
      double contactVel = rv.dotProductThis(normal.toVector());

      // Do not resolve if velocities are separating
      if (contactVel > 0) {
        return;
      }

      double raCrossN = ra.crossV(normal);
      double rbCrossN = rb.crossV(normal);
      double invMassSum = A.invMass + B.invMass + (raCrossN * raCrossN) * A.invInertia + (rbCrossN * rbCrossN) * B.invInertia;

      // Calculate impulse scalar
      double j = -(1.0 + e) * contactVel;
      j /= invMassSum;
      j /= contactCount;

      // Apply impulse
      Vec2 impulse = normal.clone()..mul(j);
      A.applyImpulse(impulse.clone().toVector()..negateThis(), ra.toVector());
      B.applyImpulse(impulse.toVector(), rb.toVector());

      // Friction impulse
      rv = B.velocity.clone()
        ..addVectorToThis((rb.clone()..crossAv(B.angularVelocity, rb)).toVector())
        ..subtractToThis(A.velocity)
        ..subtractToThis((ra.clone()..crossAv(A.angularVelocity, ra)).toVector());

      Vector t = rv.clone();
      var s = -rv.dotProductThis(normal.toVector());
      t.addToThis(normal.x * s, normal.y * s);
      t.normalizeThis();

      // j tangent magnitude
      double jt = -rv.dotProductThis(t);
      jt /= invMassSum;
      jt /= contactCount;

      // Don't apply tiny friction impulses
      if (ImpulseMath.equal(jt, 0.0)) {
        return;
      }

      // Coulumb's law
      Vector tangentImpulse;
      if (jt.abs() < j * sf) {
        tangentImpulse = t.clone()..multiplyToThis(jt);
      } else {
        tangentImpulse = t.clone()..multiplyToThis(j)..multiplyToThis(-df);
      }

      // Apply friction impulse
      A.applyImpulse(tangentImpulse.clone()..negateThis(), ra.toVector());
      B.applyImpulse(tangentImpulse, rb.toVector());
    }
  }

  void positionalCorrection() {
    double correction = max(penetration - ImpulseMath.PENETRATION_ALLOWANCE, 0.0) / (A.invMass + B.invMass) * ImpulseMath.PENETRATION_CORRETION;

    var correctionA = -A.invMass * correction;
    var correctionB = B.invMass * correction;
    A.m.translateThis(normal.x * correctionA, normal.y * correctionA);
    B.m.translateThis(normal.x * correctionB, normal.y * correctionB);
  }

  void infiniteMassCorrection() {
    A.velocity.reset();
    B.velocity.reset();
  }
}
