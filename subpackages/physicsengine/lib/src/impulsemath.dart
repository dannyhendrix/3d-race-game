part of physicsengine;

class ImpulseMath {
  static final double PI = pi;
  static final double EPSILON = 0.0001;
  static final double EPSILON_SQ = EPSILON * EPSILON;
  static final double BIAS_RELATIVE = 0.95;
  static final double BIAS_ABSOLUTE = 0.01;
  static final double DT = 1.0 / 60.0;
  static final Vec2 GRAVITY = new Vec2(0.0, 50.0);
  static final double RESTING = (GRAVITY.clone()..mul(DT)).lengthSq() + EPSILON;
  static final double PENETRATION_ALLOWANCE = 0.05;
  static final double PENETRATION_CORRETION = 0.4;

  static bool equal(double a, double b) {
    return (a - b).abs() <= EPSILON;
  }

  static double clamp(double min, double max, double a) {
    return (a < min ? min : (a > max ? max : a));
  }

  static int round(double a) {
    return (a + 0.5).toInt();
  }

  static double randomDouble(double min, double max) {
    return ((max - min) * Random().nextDouble() + min);
  }

  static int random(int min, int max) {
    return ((max - min + 1) * Random().nextDouble() + min).toInt();
  }

  static bool gt(double a, double b) {
    return a >= b * BIAS_RELATIVE + a * BIAS_ABSOLUTE;
  }
}