part of physicsengine;

class PolygonShape {
  Body body;

  Vector center = Vector(0, 0);
  List<Vector> verticesMoved;
  List<Vector> vertices;
  List<Vector> normalsMoved;

  PolygonShape(List<Vector> verts) {
    normalsMoved = _getNormals(verts);
    verticesMoved = verts;
    vertices = _copyVectors(verts);
  }
  void apply(Mat2 m, Vector position) {
    center.addVectorToThis(position);
    for (var v in verticesMoved) {
      v.subtractToThis(center);
      m.mulV(v);
      v.addVectorToThis(center);
      v.addVectorToThis(position);
    }
    for (var v in normalsMoved) m.mulVnoMove(v);
  }

  PolygonShape.rectangle(double hw, double hh) : this([Vector(-hw, -hh), Vector(hw, -hh), Vector(hw, hh), Vector(-hw, hh)]);

  void initialize() {
    _computeMass(1.0, vertices);
  }

  void _computeMass(double density, List<Vector> verts) {
    // Calculate centroid and moment of inertia
    var center = new Vector(0.0, 0.0); // centroid
    double area = 0.0;
    double I = 0.0;
    final double k_inv3 = 1.0 / 3.0;

    for (int i = 0; i < verts.length; ++i) {
      // Triangle vertices, third vertex implied as (0, 0)
      var p1 = verts[i];
      var p2 = verts[(i + 1) % verts.length];

      double D = p1.crossProductThis(p2);
      double triangleArea = 0.5 * D;

      area += triangleArea;

      // Use area to weight the centroid average, not just vertex position
      double weight = triangleArea * k_inv3;
      center.addToThis(p1.x * weight, p1.y * weight);
      center.addToThis(p2.x * weight, p2.y * weight);

      double intx2 = p1.x * p1.x + p2.x * p1.x + p2.x * p2.x;
      double inty2 = p1.y * p1.y + p2.y * p1.y + p2.y * p2.y;
      I += (0.25 * k_inv3 * D) * (intx2 + inty2);
    }

    center.multiplyToThis(1.0 / area);

    // Translate vertices to centroid (make the centroid (0, 0)
    // for the polygon in model space)
    // Not really necessary, but I like doing this anyway
    for (var v in verts) {
      v.subtractToThis(center);
    }

    body.mass = density * area;
    body.invMass = (body.mass != 0.0) ? 1.0 / body.mass : 0.0;
    body.inertia = I * density;
    body.invInertia = (body.inertia != 0.0) ? 1.0 / body.inertia : 0.0;
  }

  List<Vector> _getNormals(List<Vector> verts) {
    var normals = new List<Vector>();
    // Compute face normals
    for (int i = 0; i < verts.length; ++i) {
      var face = verts[(i + 1) % verts.length].clone()..subtractToThis(verts[i]);
      normals.add(Vector(face.y, -face.x)..normalizeThis());
    }
    return normals;
  }

  List<Vector> _copyVectors(List<Vector> verts) {
    var clone = new List<Vector>();
    for (var v in verts) clone.add(v.clone());
    return clone;
  }

  Vector getSupport(Vector dir) {
    double bestProjection = double.negativeInfinity;
    Vector bestVertex = null;

    for (var v in verticesMoved) {
      double projection = v.dotProductThis(dir);

      if (projection > bestProjection) {
        bestVertex = v;
        bestProjection = projection;
      }
    }

    return bestVertex;
  }
}
