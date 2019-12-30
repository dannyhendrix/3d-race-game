part of physicsengine;

class Mat2 {
  double m00, m01, m02;
  double m10, m11, m12;

  Mat2() {
    m00 = 0;
    m01 = 0;
    m10 = 0;
    m11 = 0;
    m02 = 0;
    m12 = 0;
  }

  Mat2 clone() {
    return Mat2.fromValues(m00, m01, m10, m11, m02, m12);
  }

  Mat2.fromValues(double a, double b, double c, double d, double e, double f) {
    m00 = a;
    m01 = b;
    m10 = c;
    m11 = d;
    m02 = e;
    m12 = f;
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

  Vec2 position() => Vec2(m02, m12);
  void translate(double x, double y) {
    m02 += x;
    m12 += y;
  }

  String toString() {
    return "$m00 | $m01 | $m02\n$m10 | $m11 | $m12";
  }
}
