part of physicsengine;

class CollisionCircleCircle implements CollisionHandler {
  static final CollisionCircleCircle instance = new CollisionCircleCircle();

  @override
  void handleCollision(Manifold m, Body a, Body b) {
    Circle A = a.shape;
    Circle B = b.shape;

    Vec2 normal = b.position.clone()..subV(a.position);

    double dist_sqr = normal.lengthSq();
    double radius = A.radius + B.radius;

    if (dist_sqr >= radius * radius) {
      m.contactCount = 0;
      return;
    }

    double distance = sqrt(dist_sqr);

    m.contactCount = 1;

    if (distance == 0.0) {
      m.penetration = A.radius;
      m.normal.change(1.0, 0.0);
      m.contacts[0].changeV(a.position);
    } else {
      m.penetration = radius - distance;
      m.normal
        ..changeV(normal)
        ..div(distance);
      m.contacts[0]
        ..changeV(m.normal)
        ..mul(A.radius)
        ..addV(a.position);
    }
  }
}
