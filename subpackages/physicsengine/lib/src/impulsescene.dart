part of physicsengine;

class ImpulseScene {
  double dt;
  int iterations;
  List<PolygonShape> bodies = new List<PolygonShape>();
  List<Manifold> contacts = new List<Manifold>();
  CollisionDetection _collisionDetection = new CollisionDetection();

  ImpulseScene(this.dt, this.iterations);

  void step() {
    contacts.clear();
    for (int i = 0; i < bodies.length; ++i) {
      var A = bodies[i];

      for (int j = i + 1; j < bodies.length; ++j) {
        var B = bodies[j];

        if (A.invMass == 0 && B.invMass == 0) {
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
      var b = bodies[i];
      b.force.reset();
      b.torque = 0;
    }
  }

  void add(PolygonShape shape) {
    bodies.add(shape);
  }

  void clear() {
    contacts.clear();
    bodies.clear();
  }

  void integrateForces(PolygonShape b, double dt) {
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

  void integrateVelocity(PolygonShape b, double dt) {
    if (b.invMass == 0.0) return;

    b.move(b.velocity.x * dt, b.velocity.y * dt, b.angularVelocity * dt);

    integrateForces(b, dt);
  }
}
