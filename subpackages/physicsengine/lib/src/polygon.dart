part of physicsengine;

class PolygonShape {
  static final int MAX_POLY_VERTEX_COUNT = 4;

  Body body;

  int vertexCount;
  List<Vector> vertices; // = Vec2.arrayOf(MAX_POLY_VERTEX_COUNT);
  List<Vector> normals; // = Vec2.arrayOf(MAX_POLY_VERTEX_COUNT);

  PolygonShape(List<Vector> verts) {
    _setVectors(verts);
  }

  PolygonShape.rectangle(double hw, double hh) {
    setBox(hw, hh);
  }

  void initialize() {
    computeMass(1.0);
  }

  void computeMass(double density) {
    // Calculate centroid and moment of inertia
    var c = new Vector(0.0, 0.0); // centroid
    double area = 0.0;
    double I = 0.0;
    final double k_inv3 = 1.0 / 3.0;

    for (int i = 0; i < vertexCount; ++i) {
      // Triangle vertices, third vertex implied as (0, 0)
      var p1 = vertices[i];
      var p2 = vertices[(i + 1) % vertexCount];

      double D = p1.crossProductThis(p2);
      double triangleArea = 0.5 * D;

      area += triangleArea;

      // Use area to weight the centroid average, not just vertex position
      double weight = triangleArea * k_inv3;
      c.addToThis(p1.x * weight, p1.y * weight);
      c.addToThis(p2.x * weight, p2.y * weight);

      double intx2 = p1.x * p1.x + p2.x * p1.x + p2.x * p2.x;
      double inty2 = p1.y * p1.y + p2.y * p1.y + p2.y * p2.y;
      I += (0.25 * k_inv3 * D) * (intx2 + inty2);
    }

    c.multiplyToThis(1.0 / area);

    // Translate vertices to centroid (make the centroid (0, 0)
    // for the polygon in model space)
    // Not really necessary, but I like doing this anyway
    for (int i = 0; i < vertexCount; ++i) {
      vertices[i].subtractToThis(c);
    }

    body.mass = density * area;
    body.invMass = (body.mass != 0.0) ? 1.0 / body.mass : 0.0;
    body.inertia = I * density;
    body.invInertia = (body.inertia != 0.0) ? 1.0 / body.inertia : 0.0;
  }

  void setBox(double hw, double hh) {
    vertexCount = 4;
    vertices = [Vector(-hw, -hh), Vector(hw, -hh), Vector(hw, hh), Vector(-hw, hh)];
    normals = [Vector(0.0, -1.0), Vector(1.0, 0.0), Vector(0.0, 1.0), Vector(-1.0, 0.0)];
  }

  void _setVectors(List<Vector> verts) {
    // Find the right most point on the hull
    int rightMost = 0;
    double highestXCoord = verts[0].x;
    for (int i = 1; i < verts.length; ++i) {
      double x = verts[i].x;

      if (x > highestXCoord) {
        highestXCoord = x;
        rightMost = i;
      }
      // If matching x then take farthest negative y
      else if (x == highestXCoord) {
        if (verts[i].y < verts[rightMost].y) {
          rightMost = i;
        }
      }
    }

    List<int> hull = new List<int>(MAX_POLY_VERTEX_COUNT);
    int outCount = 0;
    int indexHull = rightMost;

    for (;;) {
      hull[outCount] = indexHull;

      // Search for next index that wraps around the hull
      // by computing cross products to find the most counter-clockwise
      // vertex in the set, given the previos hull index
      int nextHullIndex = 0;
      for (int i = 1; i < verts.length; ++i) {
        // Skip if same coordinate as we need three unique
        // points in the set to perform a cross product
        if (nextHullIndex == indexHull) {
          nextHullIndex = i;
          continue;
        }

        // Cross every set of three unique vertices
        // Record each counter clockwise third vertex and add
        // to the output hull
        // See : http://www.oocities.org/pcgpe/math2d.html
        var e1 = verts[nextHullIndex].clone()..subtractToThis(verts[hull[outCount]]);
        var e2 = verts[i].clone()..subtractToThis(verts[hull[outCount]]);
        double c = e1.crossProductThis(e2);
        if (c < 0.0) {
          nextHullIndex = i;
        }

        // Cross product is zero then e vectors are on same line
        // therefore want to record vertex farthest along that line
        if (c == 0.0 && e2.magnitudeSquared() > e1.magnitudeSquared()) {
          nextHullIndex = i;
        }
      }

      ++outCount;
      indexHull = nextHullIndex;

      // Conclude algorithm upon wrap-around
      if (nextHullIndex == rightMost) {
        vertexCount = outCount;
        break;
      }
    }

    // Copy vertices into shape's vertices
    for (int i = 0; i < vertexCount; ++i) {
      vertices[i].resetToVector(verts[hull[i]]);
    }

    // Compute face normals
    for (int i = 0; i < vertexCount; ++i) {
      var face = vertices[(i + 1) % vertexCount].clone()..subtractToThis(vertices[i]);

      // Calculate normal with 2D cross product between vector and scalar
      normals[i].resetToPosition(face.y, -face.x);
      normals[i].normalizeThis();
    }
  }

  Vector getSupport(Vector dir) {
    double bestProjection = double.negativeInfinity;
    Vector bestVertex = null;

    for (int i = 0; i < vertexCount; ++i) {
      Vector v = vertices[i];
      double projection = v.dotProductThis(dir);

      if (projection > bestProjection) {
        bestVertex = v;
        bestProjection = projection;
      }
    }

    return bestVertex;
  }
}
