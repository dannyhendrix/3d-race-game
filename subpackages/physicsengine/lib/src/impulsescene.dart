part of physicsengine;

class ImpulseScene {
  static final double dt = 1 / 60.0;
  static final int iterations = 10;

  CollisionDetection _collisionDetection = new CollisionDetection();
  CollisionHandler _collisionHandler = new CollisionHandler();

  void step(List<PolygonShape> bodies) {
    var contacts = new List<Manifold>();
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
      _collisionHandler.integrateForces(bodies[i], dt);
    }

    for (int i = 0; i < contacts.length; ++i) {
      _collisionHandler.initialize(contacts[i]);
    }

    for (int j = 0; j < iterations; ++j) {
      for (int i = 0; i < contacts.length; ++i) {
        _collisionHandler.applyImpulse(contacts[i]);
      }
    }

    for (int i = 0; i < bodies.length; ++i) {
      _collisionHandler.integrateVelocity(bodies[i], dt);
    }

    for (int i = 0; i < contacts.length; ++i) {
      _collisionHandler.positionalCorrection(contacts[i]);
    }

    for (int i = 0; i < bodies.length; ++i) {
      var b = bodies[i];
      b.force.reset();
      b.torque = 0;
    }
  }
}
