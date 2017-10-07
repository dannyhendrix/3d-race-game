part of gameutils.math;

class Matrix2d{
  List<double> data;
  double val(int row, int col) => data[row*3  + col];
  Matrix2d() : data = new List<double>(9);
  Matrix2d.fromList(this.data);

  Matrix2d.identity() {
    data = [
      1.0, 0.0, 0.0,
      0.0, 1.0, 0.0,
      0.0, 0.0, 1.0,
    ];
  }
  Matrix2d.translationPoint(Point p) : this.translation(p.x,p.y);
  Matrix2d.translation(double tx, double ty) {
    data = [
      1.0,  0.0,  0.0,
      0.0,  1.0,  0.0,
      tx,   ty,   1.0,
    ];
  }
  Matrix2d.rotation(double angleInRadians) {
    double c = Math.cos(angleInRadians);
    double s = Math.sin(angleInRadians);
    data = [
      c, s,  0.0,
      -s, c,  0.0,
      0.0, 0.0, 1.0,
    ];
  }
  Matrix2d.scaling(double sx, double sy) {
    data = [
      sx, 0.0,   0.0,
      0.0, sy,   0.0,
      0.0,  0.0, 1.0,
    ];
  }

  Matrix2d operator *(Matrix2d b) {
    double a00 = val(0,0);
    double a01 = val(0,1);
    double a02 = val(0,2);
    double a10 = val(1,0);
    double a11 = val(1,1);
    double a12 = val(1,2);
    double a20 = val(2,0);
    double a21 = val(2,1);
    double a22 = val(2,2);

    double b00 = b.val(0, 0);
    double b01 = b.val(0 ,1);
    double b02 = b.val(0 ,2);
    double b10 = b.val(1 ,0);
    double b11 = b.val(1 ,1);
    double b12 = b.val(1 ,2);
    double b20 = b.val(2 ,0);
    double b21 = b.val(2 ,1);
    double b22 = b.val(2 ,2);
    return new Matrix2d.fromList([
      b00 * a00 + b01 * a10 + b02 * a20,
      b00 * a01 + b01 * a11 + b02 * a21,
      b00 * a02 + b01 * a12 + b02 * a22,
      b10 * a00 + b11 * a10 + b12 * a20,
      b10 * a01 + b11 * a11 + b12 * a21,
      b10 * a02 + b11 * a12 + b12 * a22,
      b20 * a00 + b21 * a10 + b22 * a20,
      b20 * a01 + b21 * a11 + b22 * a21,
      b20 * a02 + b21 * a12 + b22 * a22,
    ]);
  }

  Point apply(Point p){
    return new Point(
        data[0]*p.x + data[3]*p.y + data[6],
        data[1]*p.x + data[4]*p.y + data[7]
    );
  }

  Matrix2d translatePoint(Point p) {
    return this * new Matrix2d.translation(p.x, p.y);
  }
  Matrix2d translate(double tx, double ty) {
    return this * new Matrix2d.translation(tx, ty);
  }

  Matrix2d rotate(double angleInRadians) {
    return this * new Matrix2d.rotation(angleInRadians);
  }

  Matrix2d scale(double sx, double sy) {
    return this * new Matrix2d.scaling(sx, sy);
  }
}