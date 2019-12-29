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
      Vec2 ra = contacts[i].clone()..subV(A.position);
      Vec2 rb = contacts[i].clone()..subV(B.position);

      Vec2 rv = B.velocity.clone()
        ..addV(rb.clone()..crossAv(B.angularVelocity, rb))
        ..subV(A.velocity)
        ..subV(ra.clone()..crossAv(A.angularVelocity, ra));

      // Determine if we should perform a resting collision or not
      // The idea is if the only thing moving this object is gravity,
      // then the collision should be performed without any restitution
      if (rv.lengthSq() < ImpulseMath.RESTING) {
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
      Vec2 ra = contacts[i].clone()..subV(A.position);
      Vec2 rb = contacts[i].clone()..subV(B.position);

      // Relative velocity
      Vec2 rv = B.velocity.clone()
        ..addV(rb.clone()..crossAv(B.angularVelocity, rb))
        ..subV(A.velocity)
        ..subV(ra.clone()..crossAv(A.angularVelocity, ra));

      // Relative velocity along the normal
      double contactVel = rv.dot(normal);

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
      A.applyImpulse(impulse.clone()..neg(), ra);
      B.applyImpulse(impulse, rb);

      // Friction impulse
      rv = B.velocity.clone()
        ..addV(rb.clone()..crossAv(B.angularVelocity, rb))
        ..subV(A.velocity)
        ..subV(ra.clone()..crossAv(A.angularVelocity, ra));

      Vec2 t = rv.clone();
      t.addVs(normal, -rv.dot(normal));
      t.normalize();

      // j tangent magnitude
      double jt = -rv.dot(t);
      jt /= invMassSum;
      jt /= contactCount;

      // Don't apply tiny friction impulses
      if (ImpulseMath.equal(jt, 0.0)) {
        return;
      }

      // Coulumb's law
      Vec2 tangentImpulse;
      if (jt.abs() < j * sf) {
        tangentImpulse = t.clone()..mul(jt);
      } else {
        tangentImpulse = t.clone()..mul(j)..mul(-df);
      }

      // Apply friction impulse
      A.applyImpulse(tangentImpulse.clone()..neg(), ra);
      B.applyImpulse(tangentImpulse, rb);
    }
  }

  void positionalCorrection() {
    double correction = max(penetration - ImpulseMath.PENETRATION_ALLOWANCE, 0.0) / (A.invMass + B.invMass) * ImpulseMath.PENETRATION_CORRETION;

    A.position.addVs(normal, -A.invMass * correction);
    B.position.addVs(normal, B.invMass * correction);
  }

  void infiniteMassCorrection() {
    A.velocity.change(0, 0);
    B.velocity.change(0, 0);
  }
}
