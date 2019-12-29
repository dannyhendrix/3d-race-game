part of physicsengine;

class CollisionCirclePolygon implements CollisionHandler {
  static final CollisionCirclePolygon instance = new CollisionCirclePolygon();

  @override
  void handleCollision(Manifold m, Body a, Body b) {
    Circle A = a.shape;
    PolygonShape B = b.shape;

    m.contactCount = 0;

    Vec2 center = a.position.clone()..subV(b.position);
    B.u.clone()
      ..transpose()
      ..mulV(center);

    // Find edge with minimum penetration
    // Exact concept as using support points in Polygon vs Polygon
    double separation = double.negativeInfinity;
    int faceNormal = 0;
    for (int i = 0; i < B.vertexCount; ++i) {
      double s = B.normals[i].dot(center.clone()..subV(B.vertices[i]));

      if (s > A.radius) {
        return;
      }

      if (s > separation) {
        separation = s;
        faceNormal = i;
      }
    }

    // Grab face's vertices
    Vec2 v1 = B.vertices[faceNormal];
    int i2 = faceNormal + 1 < B.vertexCount ? faceNormal + 1 : 0;
    Vec2 v2 = B.vertices[i2];

    // Check to see if center is within polygon
    if (separation < ImpulseMath.EPSILON) {
      m.contactCount = 1;
      m.normal.changeV(B.normals[faceNormal]);
      B.u.mulV(m.normal);
      m.normal.neg();
      m.contacts[0]
        ..changeV(m.normal)
        ..mul(A.radius)
        ..addV(a.position);
      m.penetration = A.radius;
      return;
    }

    // Determine which voronoi region of the edge center of circle lies within
    double dot1 = (center.clone()..subV(v1)).dot(v2.clone()..subV(v1));
    double dot2 = (center.clone()..subV(v2)).dot(v1.clone()..subV(v2));
    m.penetration = A.radius - separation;

    // Closest to v1
    if (dot1 <= 0.0) {
      if (center.distanceSq(v1) > A.radius * A.radius) {
        return;
      }

      m.contactCount = 1;
      m.normal
        ..changeV(v1)
        ..subV(center);
      B.u.mulV(m.normal);
      m.normal.normalize();
      m.contacts[0].changeV(v1);
      B.u.mulV(m.contacts[0]);
      m.contacts[0].addV(b.position);
    }

    // Closest to v2
    else if (dot2 <= 0.0) {
      if (center.distanceSq(v2) > A.radius * A.radius) {
        return;
      }

      m.contactCount = 1;
      m.normal
        ..changeV(v2)
        ..subV(center);
      B.u.mulV(m.normal);
      m.normal.normalize();
      m.contacts[0].changeV(v2);
      B.u.mulV(m.contacts[0]);
      m.contacts[0].addV(b.position);
    }

    // Closest to face
    else {
      Vec2 n = B.normals[faceNormal];

      if ((center.clone()..subV(v1)).dot(n) > A.radius) return;

      m.contactCount = 1;
      m.normal.changeV(n);
      B.u.mulV(m.normal);
      m.normal.neg();
      m.contacts[0]
        ..changeV(a.position)
        ..addVs(m.normal, A.radius);
    }
  }
}
