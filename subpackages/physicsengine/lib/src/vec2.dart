part of physicsengine;

class Vec2 {
  double x, y;

  Vec2(this.x, this.y);
  Vec2 clone() {
    return new Vec2(x, y);
  }

  void change(double x, double y) {
    this.x = x;
    this.y = y;
  }

  void changeV(Vec2 v) {
    change(v.x, v.y);
  }

  void neg() {
    x = -x;
    y = -y;
  }

  void mul(double s) {
    x = s * x;
    y = s * y;
  }

  void div(double s) {
    x = x / s;
    y = y / s;
  }

  void add(double s) {
    x = x + s;
    y = y + s;
  }

  void mulV(Vec2 s) {
    x = s.x * x;
    y = s.y * y;
  }

  void divV(Vec2 s) {
    x = x / s.x;
    y = y / s.y;
  }

  void addV(Vec2 s) {
    x = x + s.x;
    y = y + s.y;
  }

  void addVs(Vec2 v, double s) {
    x = x + v.x * s;
    y = y + v.y * s;
  }

  void subV(Vec2 v) {
    x = x - v.x;
    y = y - v.y;
  }

  double lengthSq() {
    return x * x + y * y;
  }

  double length() {
    return sqrt(x * x + y * y);
  }

  void rotate(double radians) {
    double c = cos(radians);
    double s = sin(radians);

    double xp = x * c - y * s;
    double yp = x * s + y * c;

    x = xp;
    y = yp;
  }

  void normalize() {
    double lenSq = lengthSq();

    if (lenSq > ImpulseMath.EPSILON_SQ) {
      double invLen = 1.0 / sqrt(lenSq);
      x *= invLen;
      y *= invLen;
    }
  }

  void minV(Vec2 a, Vec2 b) {
    x = min(a.x, b.x);
    y = min(a.y, b.y);
  }

  void maxV(Vec2 a, Vec2 b) {
    x = max(a.x, b.x);
    y = max(a.y, b.y);
  }

  double dot(Vec2 b) {
    return x * b.x + y * b.y;
  }

  double distanceSq(Vec2 b) {
    double dx = x - b.x;
    double dy = y - b.y;

    return dx * dx + dy * dy;
  }

  double distance(Vec2 b) {
    double dx = x - b.x;
    double dy = y - b.y;

    return sqrt(dx * dx + dy * dy);
  }

  void crossVa(Vec2 v, double a) {
    x = v.y * a;
    y = v.x * -a;
  }

  void crossAv(double a, Vec2 v) {
    x = v.y * -a;
    y = v.x * a;
  }

  double crossV(Vec2 b) {
    return x * b.y - y * b.x;
  }

  Vector toVector() => Vector(x, y);
}
