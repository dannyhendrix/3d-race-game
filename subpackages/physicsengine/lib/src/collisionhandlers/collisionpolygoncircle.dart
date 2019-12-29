part of physicsengine;

class CollisionPolygonCircle implements CollisionHandler {
  static final CollisionPolygonCircle instance = new CollisionPolygonCircle();

  @override
  void handleCollision(Manifold m, Body a, Body b) {
    CollisionCirclePolygon.instance.handleCollision(m, b, a);

    if (m.contactCount > 0) {
      m.normal.neg();
    }
  }
}
