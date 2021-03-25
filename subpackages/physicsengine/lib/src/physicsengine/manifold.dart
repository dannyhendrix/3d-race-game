part of physicsengine;

class Chain {
  PhysicsObject a, b;
  int chainLocationIndexA, chainLocationIndexB;
  PhysicsObjectChain chainFromA, chainFromB;
  //Vector contactFromA = Vector(0, 0);
  Chain(this.a, this.b, this.chainLocationIndexA, this.chainLocationIndexB);
}

class Manifold {
  final PhysicsObject A;
  final PhysicsObject B;

  // chain
  bool areConnected = false;
  //int chainIndexA, chainIndexB;
  PhysicsObjectChain chainFromA, chainFromB;

  // detection
  bool collided = false;
  double penetration;
  final Vector normal = new Vector(0, 0);
  final List<Vector> contacts = [new Vector(0, 0), new Vector(0, 0)];
  int contactCount = 0;

  // handling
  double e;
  double dynamicForce;
  double staticForce;

  Manifold(this.A, this.B);
}
