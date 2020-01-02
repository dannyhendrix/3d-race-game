part of physicsengine;

class Manifold {
  final PolygonShape A;
  final PolygonShape B;

  // detection
  double penetration;
  final Vector normal = new Vector(0, 0);
  final List<Vector> contacts = [new Vector(0, 0), new Vector(0, 0)];
  int contactCount;

  // handling
  double e;
  double dynamicForce;
  double staticForce;

  Manifold(this.A, this.B);
}
