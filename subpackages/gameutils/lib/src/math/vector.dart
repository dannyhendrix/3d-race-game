part of gameutils.math;

/**
Simple vector class
**/
class Vector {
  double x;
  double y;
  // constructors
  Vector.fromAngleRadians(double angle, double power) : this(cos(angle) * power, sin(angle) * power);
  Vector.empty() : this(0.0, 0.0);

  Vector(this.x, this.y);

  // clone
  Vector clone() => new Vector(x, y);
  // string
  String toString() => "(${x},${y})";

  // reset
  Vector reset() => resetToPosition(0.0, 0.0);
  Vector resetToVector(Vector other) => resetToPosition(other.x, other.y);
  Vector resetToPosition(double sx, double sy) {
    x = sx;
    y = sy;
    return this;
  }

  // operations
  Vector operator -() => clone().negateThis();
  Vector operator +(Vector b) => clone().addToThis(b.x, b.y);
  Vector operator -(Vector b) => clone().addToThis(-b.x, -b.y);
  Vector operator *(double factor) => clone().multiplyToThis(factor);
  Vector negateThis() {
    x = -x;
    y = -y;
    return this;
  }

  Vector subtractToThis(Vector v) => addToThis(-v.x, -v.y);
  Vector addVectorToThis(Vector v) => addToThis(v.x, v.y);
  Vector addToThis(double sx, double sy) {
    x += sx;
    y += sy;
    return this;
  }

  Vector multiplyToThis(double factor) {
    x *= factor;
    y *= factor;
    return this;
  }

  // distance
  double distanceToThis(Vector p) => distanceTo(this, p);
  double unsquaredDistanceToThis(Vector p) => unsquaredDistanceTo(this, p);
  static double distanceTo(Vector a, Vector b) => sqrt(unsquaredDistanceTo(a, b));
  static double unsquaredDistanceTo(Vector a, Vector b) {
    var nX = b.x - a.x;
    var nY = b.y - a.y;
    return nX * nX + nY * nY;
  }

  // angle
  double angleThis() => angle(this);
  static double angle(Vector a) => atan2(a.y, a.x);
  double angleWithThis(Vector p) => angleWith(this, p);
  static double angleWith(Vector a, Vector b) => atan2(b.y - a.y, b.x - a.x);

  // dot/cross product
  double dotProductThis(Vector p) => dotProduct(this, p);
  static double dotProduct(Vector a, Vector b) => a.x * b.x + a.y * b.y;
  double crossProductThis(Vector p) => crossProduct(this, p);
  Vector crossProductScalarThis(double p) => crossProductScalar(this, p);
  static double crossProduct(Vector a, Vector b) => a.x * b.y - a.y * b.x;
  static Vector crossProductScalar(Vector a, double b) => a.clone().crossProductToThis(b);
  Vector crossProductToThis(double b) {
    var tempX = x;
    var tempY = y;
    x = b * tempY;
    y = -b * tempX;
    return this;
  }

  // normalize
  double magnitude() => sqrt(x * x + y * y);
  Vector normalized() => clone().normalizeThis();
  Vector normalizeThis() {
    var m = magnitude();
    x = x / m;
    y = y / m;
    return this;
  }

  static Vector intersection(Vector A, Vector B, Vector C, Vector D) {
    // Line AB represented as a1x + b1y = c1
    double a1 = B.y - A.y;
    double b1 = A.x - B.x;
    double c1 = a1 * (A.x) + b1 * (A.y);

    // Line CD represented as a2x + b2y = c2
    double a2 = D.y - C.y;
    double b2 = C.x - D.x;
    double c2 = a2 * (C.x) + b2 * (C.y);

    double determinant = a1 * b2 - a2 * b1;

    if (determinant == 0) {
      // The lines are parallel. This is simplified
      // by returning a pair of FLT_MAX
      return new Vector(double.maxFinite, double.maxFinite);
    } else {
      double x = (b2 * c1 - b1 * c2) / determinant;
      double y = (a1 * c2 - a2 * c1) / determinant;
      return new Vector(x, y);
    }
  }

  // matrix
  Vector applyMatrixToThis(Matrix2d matrix) => matrix.applyToVector(this);
  Vector applyMatrix(Matrix2d matrix) => matrix.applyToVector(clone());
}
