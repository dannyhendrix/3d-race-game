part of gameutils.math;

class Matrix2d {
  List<double> _data;

  // constructors
  Matrix2d._fromList(this._data);
  Matrix2d.translation(double x, double y) : this._fromList(_translation(x, y));
  Matrix2d.translationVector(Vector v) : this._fromList(_translation(v.x, v.y));
  Matrix2d.scaling(double sx, double sy) : this._fromList(_scaling(sx, sy));
  Matrix2d.rotation(double angleInRadians) : this._fromList(_rotation(angleInRadians));
  Matrix2d() : _data = _identity();

  // clone
  Matrix2d clone() => new Matrix2d._fromList([
        _data[0],
        _data[1],
        _data[2],
        _data[3],
        _data[4],
        _data[5],
      ]);

  // reset
  Matrix2d reset() {
    _data[0] = 1.0;
    _data[1] = 0;
    _data[2] = 0;
    _data[3] = 1.0;
    _data[4] = 0;
    _data[5] = 0;
    return this;
  }

  // string
  String toString() => "|${_data[0]},${_data[1]}|\n|${_data[2]},${_data[3]}|\n|${_data[4]},${_data[5]}|\n";

  // multiply
  Matrix2d operator *(Matrix2d b) => clone()._multiplyThis(b._data);

  Matrix2d multiplyThis(Matrix2d b) => _multiplyThis(b._data);

  // translate
  Matrix2d translateThisVector(Vector p) => translateThis(p.x, p.y);

  Matrix2d translateThis(double tx, double ty) => _multiplyThis(_translation(tx, ty));

  Matrix2d translateVector(Vector p) => clone().translateThis(p.x, p.y);

  Matrix2d translate(double tx, double ty) => clone().translateThis(tx, ty);

  // rotate
  Matrix2d rotateThis(double angleInRadians) => _multiplyThis(_rotation(angleInRadians));

  Matrix2d rotate(double angleInRadians) => clone().rotateThis(angleInRadians);

  // scale
  Matrix2d scaleThis(double sx, double sy) => _multiplyThis(_scaling(sx, sy));

  Matrix2d scale(double sx, double sy) => clone().scale(sx, sy);

  // apply
  Vector apply(Vector p) =>
      new Vector(_data[0] * p.x + _data[2] * p.y + _data[4], _data[1] * p.x + _data[3] * p.y + _data[5]);

  Vector applyToVector(Vector p) {
    var x = _data[0] * p.x + _data[2] * p.y + _data[4];
    var y = _data[1] * p.x + _data[3] * p.y + _data[5];
    p.x = x;
    p.y = y;
    return p;
  }

  static List<double> _identity() => [1.0, 0.0, 0.0, 1.0, 0.0, 0.0];

  static List<double> _translation(double tx, double ty) => [1.0, 0.0, 0.0, 1.0, tx, ty];

  static List<double> _rotation(double angleInRadians) {
    var c = Math.cos(angleInRadians);
    var s = Math.sin(angleInRadians);
    return [c, s, -s, c, 0.0, 0.0];
  }

  static List<double> _scaling(double sx, double sy) => [sx, 0.0, 0.0, sy, 0.0, 0.0];

  Matrix2d _multiplyThis(List<double> b) {
    double a00 = _data[0];
    double a01 = _data[1];
    double a10 = _data[2];
    double a11 = _data[3];
    double a20 = _data[4];
    double a21 = _data[5];

    double b00 = b[0];
    double b01 = b[1];
    double b10 = b[2];
    double b11 = b[3];
    double b20 = b[4];
    double b21 = b[5];

    _data[0] = b00 * a00 + b01 * a10;
    _data[1] = b00 * a01 + b01 * a11;
    _data[2] = b10 * a00 + b11 * a10;
    _data[3] = b10 * a01 + b11 * a11;
    _data[4] = b20 * a00 + b21 * a10 + a20;
    _data[5] = b20 * a01 + b21 * a11 + a21;

    return this;
  }
}
