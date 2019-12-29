part of physicsengine;

class Mat2 {
  double m00, m01;
  double m10, m11;

  Mat2() {}

  Mat2 clone() {
    return Mat2.fromValues(m00, m01, m10, m11);
  }

  Mat2.fromRadius(double radians) {
    double c = cos(radians);
    double s = sin(radians);

    m00 = c;
    m01 = -s;
    m10 = s;
    m11 = c;
  }

  Mat2.fromValues(double a, double b, double c, double d) {
    m00 = a;
    m01 = b;
    m10 = c;
    m11 = d;
  }

  void changeM(Mat2 m) {
    m00 = m.m00;
    m01 = m.m01;
    m10 = m.m10;
    m11 = m.m11;
  }

  void changeR(double radians) {
    double c = cos(radians);
    double s = sin(radians);

    m00 = c;
    m01 = -s;
    m10 = s;
    m11 = c;
  }

  void abs() {
    m00 = m00.abs();
    m01 = m01.abs();
    m10 = m10.abs();
    m11 = m11.abs();
  }

  Vec2 getAxisX() {
    return Vec2(m00, m10);
  }

  Vec2 getAxisY() {
    return Vec2(m01, m11);
  }

  void transpose() {
    double t = m01;
    m01 = m10;
    m10 = t;
  }

  void mulV(Vec2 v) {
    var x = v.x;
    var y = v.y;
    v.x = m00 * x + m01 * y;
    v.y = m10 * x + m11 * y;
  }

  void mulM(Mat2 x) {
    m00 = m00 * x.m00 + m01 * x.m10;
    m01 = m00 * x.m01 + m01 * x.m11;
    m10 = m10 * x.m00 + m11 * x.m10;
    m11 = m10 * x.m01 + m11 * x.m11;
  }
}
