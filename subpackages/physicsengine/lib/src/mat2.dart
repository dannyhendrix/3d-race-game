part of physicsengine;

class Mat2 {
  double m00, m01;
  double m10, m11;

  Mat2() {
    m00 = 1;
    m01 = 0;
    m10 = 0;
    m11 = 1;
  }

  Mat2 clone() {
    return Mat2.fromValues(m00, m01, m10, m11);
  }

  Mat2.fromValues(double a, double b, double c, double d) {
    m00 = a;
    m01 = b;
    m10 = c;
    m11 = d;
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

  void mulV(Vector v) {
    var x = v.x;
    var y = v.y;
    v.x = m00 * x + m01 * y;
    v.y = m10 * x + m11 * y;
  }

  void mulVnoMove(Vector v) {
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

  void rotateThis(double r) {
    var m = Mat2();
    m.changeR(r);
    mulM(m);
  }

  String toString() {
    return "$m00 | $m01 \n$m10 | $m11";
  }
}
