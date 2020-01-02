part of physicsengine;

class Mat2 {
  double m00, m01;
  double m10, m11;

  Mat2() {
    m00 = 1.0;
    m01 = 0.0;
    m10 = 0.0;
    m11 = 1.0;
  }

  void changeR(double radians) {
    double c = cos(radians);
    double s = sin(radians);

    m00 = c;
    m01 = -s;
    m10 = s;
    m11 = c;
  }

  void mulV(Vector v) {
    var x = v.x;
    var y = v.y;
    v.x = m00 * x + m01 * y;
    v.y = m10 * x + m11 * y;
  }

  String toString() {
    return "$m00 | $m01 \n$m10 | $m11";
  }
}
