part of physicsengine;

class ImpulseScene {
  double dt;
  int iterations;
  List<Body> bodies = new List<Body>();
  List<Manifold> contacts = new List<Manifold>();

  ImpulseScene(double dt, int iterations) {
    this.dt = dt;
    this.iterations = iterations;
  }

  void step() {
    contacts.clear();
    for (int i = 0; i < bodies.length; ++i) {
      Body A = bodies[i];

      for (int j = i + 1; j < bodies.length; ++j) {
        Body B = bodies[j];

        if (A.invMass == 0 && B.invMass == 0) {
          continue;
        }

        Manifold m = new Manifold(A, B);
        m.solve();

        if (m.contactCount > 0) {
          contacts.add(m);
        }
      }
    }

    for (int i = 0; i < bodies.length; ++i) {
      integrateForces(bodies[i], dt);
    }

    for (int i = 0; i < contacts.length; ++i) {
      contacts[i].initialize();
    }

    for (int j = 0; j < iterations; ++j) {
      for (int i = 0; i < contacts.length; ++i) {
        contacts[i].applyImpulse();
      }
    }

    for (int i = 0; i < bodies.length; ++i) {
      integrateVelocity(bodies[i], dt);
    }

    for (int i = 0; i < contacts.length; ++i) {
      contacts[i].positionalCorrection();
    }

    for (int i = 0; i < bodies.length; ++i) {
      Body b = bodies[i];
      b.force.change(0, 0);
      b.torque = 0;
    }
  }

  Body add(PolygonShape shape, double x, double y) {
    Body b = new Body(shape, x, y);
    bodies.add(b);
    return b;
  }

  void clear() {
    contacts.clear();
    bodies.clear();
  }

  void integrateForces(Body b, double dt) {
    if (b.invMass == 0.0) return;

    double dts = dt * 0.5;

    b.velocity.addVs(b.force, b.invMass * dts);
    b.velocity.addVs(ImpulseMath.GRAVITY, dts);
    b.angularVelocity += b.torque * b.invInertia * dts;
  }

  void integrateVelocity(Body b, double dt) {
    if (b.invMass == 0.0) {
      return;
    }

    b.position.addVs(b.velocity, dt);
    b.orient += b.angularVelocity * dt;
    b.setOrient(b.orient);

    integrateForces(b, dt);
  }
}
