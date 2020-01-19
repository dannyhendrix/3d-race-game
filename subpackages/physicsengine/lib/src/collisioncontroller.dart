part of physicsengine;

class CollisionController {
  static final double dt = 1 / 60.0;
  static final int iterations = 10;

  CollisionDetection _collisionDetection;
  CollisionHandler _collisionHandler;

  CollisionController(this._collisionDetection, this._collisionHandler);

  void step(List<PhysicsObject> bodies, List<Manifold> contacts) {
    for (int i = 0; i < contacts.length; ++i) {
      _collisionDetection.detectCollision(contacts[i]);
    }

    for (int i = 0; i < bodies.length; ++i) {
      _collisionHandler.integrateForces(bodies[i], dt);
    }

    for (int i = 0; i < contacts.length; ++i) {
      _collisionHandler.initialize(contacts[i]);
    }

    for (int i = 0; i < contacts.length; ++i) {
      _collisionHandler.applyImpulseChain(contacts[i]);
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

  List<Manifold> createManifolds(List<PhysicsObject> bodies) {
    var contacts = new List<Manifold>();
    for (int i = 0; i < bodies.length; ++i) {
      var A = bodies[i];

      for (int j = i + 1; j < bodies.length; ++j) {
        var B = bodies[j];

        if (A.invMass == 0 && B.invMass == 0) {
          continue;
        }
        var manifold = new Manifold(A, B);
        contacts.add(manifold);
        var connectedFromA = A.chains.firstWhere((s) => s.other == B, orElse: () => null);
        var connectedFromB = B.chains.firstWhere((s) => s.other == A, orElse: () => null);
        if (connectedFromA != null && connectedFromB != null) {
          manifold.areConnected = true;
          manifold.chainFromA = connectedFromA;
          manifold.chainFromB = connectedFromB;
        }
      }
    }
    return contacts;
  }
}
