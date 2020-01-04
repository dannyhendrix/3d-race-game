part of physicsengine;

class PhysicsObject {
  // velocity
  Vector velocity = new Vector(0, 0);
  double angularVelocity = 0;
  //force
  Vector force = new Vector(0, 0);
  double torque = 0;
  // friction
  double staticFriction = 0.5;
  double dynamicFriction = 0.3;
  double restitution = 0.2;

  Vector center;
  final List<Vector> vertices;
  List<Vector> normals;

  double mass, invMass, inertia, invInertia;
  double friction = 0.99, frictionR = 0.99;
  double impulseImpact = 1.0;

  PhysicsObject.rectangle(double w, double h, [double density = 1.0]) : this([Vector(-w / 2, -h / 2), Vector(w / 2, -h / 2), Vector(w / 2, h / 2), Vector(-w / 2, h / 2)], density);
  PhysicsObject(this.vertices, [double density = 1.0]) {
    normals = _getNormals(vertices);
    _computeMass(density, vertices);
  }
  void move(double x, double y, double radians) {
    var cx = center.x;
    var cy = center.y;
    _applyRadiansWithOffset(center, cx, cy, x, y, radians);

    for (var v in vertices) _applyRadiansWithOffset(v, cx, cy, x, y, radians);

    for (var v in normals) _applyRadians(v, radians);
  }

  void setStatic() {
    inertia = 0.0;
    invInertia = 0.0;
    mass = 0.0;
    invMass = 0.0;
  }

  void _applyRadiansWithOffset(Vector v, double cx, double cy, double x, double y, double radians) {
    v.addToThis(-cx, -cy);
    _applyRadians(v, radians);
    v.addToThis(cx, cy);
    v.addToThis(x, y);
  }

  void _applyRadians(Vector v, double radians) {
    var c = cos(radians);
    var s = sin(radians);

    var x = v.x;
    var y = v.y;

    v.x = c * x + -s * y;
    v.y = s * x + c * y;
  }

  void _computeMass(double density, List<Vector> verts) {
    // Calculate centroid and moment of inertia
    center = new Vector(0.0, 0.0); // centroid
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
    for (var v in verts) v.subtractToThis(center);
    center.reset();

    mass = density * area;
    invMass = (mass != 0.0) ? 1.0 / mass : 0.0;
    inertia = I * density;
    invInertia = (inertia != 0.0) ? 1.0 / inertia : 0.0;
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
}
