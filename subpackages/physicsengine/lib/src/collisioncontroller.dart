part of physicsengine;

class CollisionController {
  static final double dt = 1 / 60.0;
  static final int iterations = 10;

  CollisionDetection _collisionDetection;
  CollisionHandler _collisionHandler;

  CollisionController(this._collisionDetection, this._collisionHandler);

  List<Manifold> step(List<PhysicsObject> bodies, List<Chain> chains) {
    var contacts = new List<Manifold>();
    for (int i = 0; i < bodies.length; ++i) {
      var A = bodies[i];

      for (int j = i + 1; j < bodies.length; ++j) {
        if (i == 0 && j == 1) continue;
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
    for (var chain in chains) _collisionHandler.applyImpulseChain(chain);

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

    return contacts;
  }
}
