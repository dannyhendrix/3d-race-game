part of physicsengine;

class ImpulseScene {
  double dt;
  int iterations;
  List<Body> bodies = new List<Body>();
  List<Manifold> contacts = new List<Manifold>();
  CollisionDetection _collisionDetection = new CollisionDetection();

  ImpulseScene(this.dt, this.iterations);

  void step() {
    contacts.clear();
    for (int i = 0; i < bodies.length; ++i) {
      Body A = bodies[i];

      for (int j = i + 1; j < bodies.length; ++j) {
        Body B = bodies[j];

        if (A.shape.invMass == 0 && B.shape.invMass == 0) {
          continue;
        }

        Manifold m = new Manifold(A, B);
        _collisionDetection.detectCollision(m, A, B);

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
      b.force.reset();
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
    if (b.shape.invMass == 0.0) return;

    double dts = dt * 0.5;
    var s = b.shape.invMass * dts;
    b.velocity.addToThis(b.force.x * s, b.force.y * s);
    b.velocity.addToThis(ImpulseMath.GRAVITY.x * dts, ImpulseMath.GRAVITY.y * dts);
    b.angularVelocity += b.torque * b.shape.invInertia * dts;
  }

  void integrateVelocity(Body b, double dt) {
    if (b.shape.invMass == 0.0) return;

    var m2 = new Mat2();
    m2.rotateThis(b.angularVelocity * dt);
    //m2.translateThis(b.velocity.x * dt, b.velocity.y * dt);
    b.shape.apply(m2, new Vector(b.velocity.x * dt, b.velocity.y * dt));

    integrateForces(b, dt);
  }
}
