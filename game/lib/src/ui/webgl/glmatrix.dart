part of webgl;

class GlMatrix{
  Float32List buffer;
  double val(int row, int col) => buffer[row*4  + col];

  /**
   *     c+ x y z _
   *     r+_________|________________
   *     x| 1 0 0 0 | b00 b01 b02 b03
   *     y| 0 1 0 0 | b10 b11 b12 b13
   *     z| 0 0 1 0 | b20 b21 b22 b23
   *     _| 0 0 0 1 | b30 b31 b32 b33
   *
   *     [ b00,b01,b02,b03, b10,b11,b12,b13, b20,b21,b22,b23, b30,b31,b32,b33 ]
   */

  GlMatrix():buffer = new Float32List(16);
  GlMatrix.fromBuffer(this.buffer);
  GlMatrix.fromList(List<double> values):this.fromBuffer(new Float32List.fromList(values));

  static GlMatrix identityMatrix() {
    return new GlMatrix.fromList([
      1.0, 0.0, 0.0, 0.0,
      0.0, 1.0, 0.0, 0.0,
      0.0, 0.0, 1.0, 0.0,
      0.0, 0.0, 0.0, 1.0,
    ]);
  }
  static GlMatrix translationMatrix(tx, ty, tz) {
    return new GlMatrix.fromList([
      1.0,  0.0,  0.0,  0.0,
      0.0,  1.0,  0.0,  0.0,
      0.0,  0.0,  1.0,  0.0,
      tx,   ty,   tz,   1.0,
    ]);
  }
  static GlMatrix xRotationMatrix(angleInRadians) {
    var c = Math.cos(angleInRadians);
    var s = Math.sin(angleInRadians);

    return new GlMatrix.fromList([
      1.0, 0.0, 0.0, 0.0,
      0.0, c,   s,  0.0,
      0.0, -s,  c,  0.0,
      0.0, 0.0, 0.0, 1.0,
    ]);
  }
  static GlMatrix yRotationMatrix(angleInRadians) {
    var c = Math.cos(angleInRadians);
    var s = Math.sin(angleInRadians);

    return new GlMatrix.fromList([
      c, 0.0, -s, 0.0,
      0.0, 1.0, 0.0, 0.0,
      s, 0.0, c, 0.0,
      0.0, 0.0, 0.0, 1.0,
    ]);
  }
  static GlMatrix zRotationMatrix(angleInRadians) {
    var c = Math.cos(angleInRadians);
    var s = Math.sin(angleInRadians);

    return new GlMatrix.fromList([
      c, s, 0.0, 0.0,
      -s, c, 0.0, 0.0,
      0.0, 0.0, 1.0, 0.0,
      0.0, 0.0, 0.0, 1.0,
    ]);
  }
  static GlMatrix scalingMatrix(sx, sy, sz) {
    return new GlMatrix.fromList([
      sx, 0.0,  0.0,  0.0,
      0.0, sy,  0.0,  0.0,
      0.0,  0.0, sz,  0.0,
      0.0,  0.0,  0.0,  1.0,
    ]);
  }
  static GlMatrix perspectiveMatrix(fieldOfViewInRadians, aspect, near, far) {
    var f = Math.tan(Math.PI * 0.5 - 0.5 * fieldOfViewInRadians);
    var rangeInv = 1.0 / (near - far);

    return new GlMatrix.fromList([
      f / aspect, 0.0, 0.0, 0.0,
      0.0, f, 0.0, 0.0,
      0.0, 0.0, (near + far) * rangeInv, -1.0,
      0.0, 0.0, near * far * rangeInv * 2.0, 0.0
    ]);
  }
  static GlMatrix projectionMatrix(width, height, depth) {
    // Note: This matrix flips the Y axis so 0 is at the top.
    return new GlMatrix.fromList([
      2.0 / width, 0.0, 0.0, 0.0,
      0.0, -2.0 / height, 0.0, 0.0,
      0.0, 0.0, 2.0 / depth, 0.0,
      -1.0, 1.0, 0.0, 1.0,
    ]);
  }

  GlMatrix operator *(GlMatrix b) {
    var a00 = val(0,0);
    var a01 = val(0,1);
    var a02 = val(0,2);
    var a03 = val(0,3);
    var a10 = val(1,0);
    var a11 = val(1,1);
    var a12 = val(1,2);
    var a13 = val(1,3);
    var a20 = val(2,0);
    var a21 = val(2,1);
    var a22 = val(2,2);
    var a23 = val(2,3);
    var a30 = val(3,0);
    var a31 = val(3,1);
    var a32 = val(3,2);
    var a33 = val(3,3);

    var b00 = b.val(0, 0);
    var b01 = b.val(0 ,1);
    var b02 = b.val(0 ,2);
    var b03 = b.val(0 ,3);
    var b10 = b.val(1 ,0);
    var b11 = b.val(1 ,1);
    var b12 = b.val(1 ,2);
    var b13 = b.val(1 ,3);
    var b20 = b.val(2 ,0);
    var b21 = b.val(2 ,1);
    var b22 = b.val(2 ,2);
    var b23 = b.val(2 ,3);
    var b30 = b.val(3 ,0);
    var b31 = b.val(3 ,1);
    var b32 = b.val(3 ,2);
    var b33 = b.val(3 ,3);
    return new GlMatrix.fromList([
      b00 * a00 + b01 * a10 + b02 * a20 + b03 * a30,
      b00 * a01 + b01 * a11 + b02 * a21 + b03 * a31,
      b00 * a02 + b01 * a12 + b02 * a22 + b03 * a32,
      b00 * a03 + b01 * a13 + b02 * a23 + b03 * a33,
      b10 * a00 + b11 * a10 + b12 * a20 + b13 * a30,
      b10 * a01 + b11 * a11 + b12 * a21 + b13 * a31,
      b10 * a02 + b11 * a12 + b12 * a22 + b13 * a32,
      b10 * a03 + b11 * a13 + b12 * a23 + b13 * a33,
      b20 * a00 + b21 * a10 + b22 * a20 + b23 * a30,
      b20 * a01 + b21 * a11 + b22 * a21 + b23 * a31,
      b20 * a02 + b21 * a12 + b22 * a22 + b23 * a32,
      b20 * a03 + b21 * a13 + b22 * a23 + b23 * a33,
      b30 * a00 + b31 * a10 + b32 * a20 + b33 * a30,
      b30 * a01 + b31 * a11 + b32 * a21 + b33 * a31,
      b30 * a02 + b31 * a12 + b32 * a22 + b33 * a32,
      b30 * a03 + b31 * a13 + b32 * a23 + b33 * a33,
    ]);
  }

  GlMatrix translate(tx, ty, tz) {
    return this * translationMatrix(tx, ty, tz);
  }

  GlMatrix rotateX(angleInRadians) {
    return this * xRotationMatrix(angleInRadians);
  }

  GlMatrix rotateY(angleInRadians) {
    return this * yRotationMatrix(angleInRadians);
  }

  GlMatrix rotateZ(angleInRadians) {
    return this * zRotationMatrix(angleInRadians);
  }

  GlMatrix scale(sx, sy, sz) {
    return this * scalingMatrix(sx, sy, sz);
  }
}