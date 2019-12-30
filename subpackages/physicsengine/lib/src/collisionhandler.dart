part of physicsengine;

class CollisionHandler {
  void handleCollision(Manifold m, Body a, Body b) {
    PolygonShape A = a.shape;
    PolygonShape B = b.shape;
    m.contactCount = 0;

    // Check for a separating axis with A's face planes
    List<int> faceA = [0];
    double penetrationA = findAxisLeastPenetration(faceA, A, B);
    if (penetrationA >= 0.0) {
      return;
    }
    // Check for a separating axis with B's face planes
    List<int> faceB = [0];
    double penetrationB = findAxisLeastPenetration(faceB, B, A);
    if (penetrationB >= 0.0) {
      return;
    }

    int referenceIndex;
    bool flip; // Always point from a to b

    PolygonShape RefPoly; // Reference
    PolygonShape IncPoly; // Incident

    // Determine which shape contains reference face
    if (ImpulseMath.gt(penetrationA, penetrationB)) {
      RefPoly = A;
      IncPoly = B;
      referenceIndex = faceA[0];
      flip = false;
    } else {
      RefPoly = B;
      IncPoly = A;
      referenceIndex = faceB[0];
      flip = true;
    }

    // World space incident face
    var incidentFace = [Vec2(0, 0), Vec2(0, 0)];

    findIncidentFace(incidentFace, RefPoly, IncPoly, referenceIndex);

    // y
    // ^ .n ^
    // +---c ------posPlane--
    // x < | i |\
    // +---+ c-----negPlane--
    // \ v
    // r
    //
    // r : reference face
    // i : incident poly
    // c : clipped point
    // n : incident normal

    // Setup reference face vertices
    Vec2 v1 = RefPoly.vertices[referenceIndex].clone();
    referenceIndex = referenceIndex + 1 == RefPoly.vertexCount ? 0 : referenceIndex + 1;
    Vec2 v2 = RefPoly.vertices[referenceIndex].clone();

    // Transform vertices to world space
    RefPoly.body.m.mulV(v1);
    RefPoly.body.m.mulV(v2);

    // Calculate reference face side normal in world space
    Vec2 sidePlaneNormal = v2.clone()..subV(v1);
    sidePlaneNormal.normalize();

    // Orthogonalize
    Vec2 refFaceNormal = new Vec2(sidePlaneNormal.y, -sidePlaneNormal.x);

    double refC = refFaceNormal.dot(v1);
    double negSide = -sidePlaneNormal.dot(v1);
    double posSide = sidePlaneNormal.dot(v2);

    // Clip incident face to reference face side planes
    // Due to doubleing point error, possible to not have required points
    if (clip(sidePlaneNormal.clone()..neg(), negSide, incidentFace) < 2) return;

    // Due to doubleing point error, possible to not have required points
    if (clip(sidePlaneNormal, posSide, incidentFace) < 2) return;

    // Flip
    m.normal.resetToVector(refFaceNormal.toVector());
    if (flip) m.normal.negateThis();

    // Keep points behind reference face
    int cp = 0; // clipped points behind reference face
    double separation = refFaceNormal.dot(incidentFace[0]) - refC;
    if (separation <= 0.0) {
      m.contacts[cp].resetToVector(incidentFace[0].toVector());
      m.penetration = -separation;
      ++cp;
    } else {
      m.penetration = 0;
    }

    separation = refFaceNormal.dot(incidentFace[1]) - refC;

    if (separation <= 0.0) {
      m.contacts[cp].resetToVector(incidentFace[1].toVector());

      m.penetration += -separation;
      ++cp;

      // Average penetration
      m.penetration /= cp;
    }

    m.contactCount = cp;
  }

  double findAxisLeastPenetration(List<int> faceIndex, PolygonShape A, PolygonShape B) {
    double bestDistance = double.negativeInfinity;
    int bestIndex = 0;

    for (int i = 0; i < A.vertexCount; ++i) {
      // Retrieve a face normal from A
      Vec2 nw = A.normals[i].clone();
      A.body.m.mulVnoMove(nw);

      // Transform face normal into B's model space
      Mat2 buT = B.body.m.clone()..transpose();
      Vec2 n = nw.clone();
      buT.mulVnoMove(n);

      // Retrieve support point from B along -n
      Vec2 s = B.getSupport(n.clone()..neg());

      // Retrieve vertex on face from A, transform into
      // B's model space
      Vec2 v = A.vertices[i].clone();
      A.body.m.mulV(v);
      v
        //..addV(A.body.m.position())
        ..subV(B.body.m.position());
      buT.mulVnoMove(v);

      // Compute penetration distance (in B's model space)
      double d = n.dot(s.clone()..subV(v));

      // Store greatest distance
      if (d > bestDistance) {
        bestDistance = d;
        bestIndex = i;
      }
    }

    faceIndex[0] = bestIndex;
    return bestDistance;
  }

  void findIncidentFace(List<Vec2> v, PolygonShape RefPoly, PolygonShape IncPoly, int referenceIndex) {
    Vec2 referenceNormal = RefPoly.normals[referenceIndex].clone();

    // Calculate normal in incident's frame of reference
    RefPoly.body.m.mulVnoMove(referenceNormal);

    IncPoly.body.m.clone()
      ..transpose()
      ..mulVnoMove(referenceNormal);

    // Find most anti-normal face on incident polygon
    int incidentFace = 0;
    double minDot = double.maxFinite;
    for (int i = 0; i < IncPoly.vertexCount; ++i) {
      double dot = referenceNormal.dot(IncPoly.normals[i]);

      if (dot < minDot) {
        minDot = dot;
        incidentFace = i;
      }
    }

    // Assign face vertices for incidentFace
    v[0] = IncPoly.vertices[incidentFace].clone();
    IncPoly.body.m.mulV(v[0]);
    incidentFace = incidentFace + 1 >= IncPoly.vertexCount ? 0 : incidentFace + 1;
    v[1] = IncPoly.vertices[incidentFace].clone();
    IncPoly.body.m.mulV(v[1]);
  }

  int clip(Vec2 n, double c, List<Vec2> face) {
    int sp = 0;
    List<Vec2> out = [face[0].clone(), face[1].clone()];

    // Retrieve distances from each endpoint to the line
    double d1 = n.dot(face[0]) - c;
    double d2 = n.dot(face[1]) - c;

    // If negative (behind plane) clip
    if (d1 <= 0.0) out[sp++].changeV(face[0]);
    if (d2 <= 0.0) out[sp++].changeV(face[1]);

    // If the points are on different sides of the plane
    if (d1 * d2 < 0.0) // less than to ignore -0.0
    {
      // Push intersection point
      double alpha = d1 / (d1 - d2);

      out[sp++]
        ..changeV(face[1])
        ..subV(face[0])
        ..mul(alpha)
        ..addV(face[0]);
    }

    // Assign our new converted values
    face[0] = out[0];
    face[1] = out[1];

    return sp;
  }
}
