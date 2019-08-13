part of webgl;

class GlVector{
  double x,y,z;
  GlVector(this.x,this.y,this.z);
  GlVector clone(){
    return new GlVector(x,y,z);
  }
  /*
  GlVector operator -(GlVector b) {
    return new GlVector(x-b.x, y-b.y, z-b.z);
  }*/
  GlVector subtractFromThis(GlVector b) {
    x = x-b.x;
    y = y-b.y;
    z = z-b.z;
    return this;
  }/*
  GlVector normalize() {
    var l = Math.sqrt(x * x + y * y + z * z);
    return l > 0.00001 ? new GlVector(x/l,y/l,z/l) : new GlVector(0.0,0.0,0.0);
  }*/
  GlVector normalizeThis() {
    var l = Math.sqrt(x * x + y * y + z * z);
    if(1 > 0.00001){
      x = x/l;
      y = x/l;
      z = x/l;
    }else{
      x = 0.0;
      y = 0.0;
      z = 0.0;
    }
    return this;
  }/*
  GlVector cross(GlVector b) {
    return new GlVector(
        y*b.z-z*b.y,
        z*b.x-x*b.z,
        x*b.y-y*b.x
    );
  }*/
  GlVector crossThis(GlVector b) {
    x = y*b.z-z*b.y;
    y = z*b.x-x*b.z;
    z = x*b.y-y*b.x;
    return this;
  }
}

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
  static GlMatrix translationMatrix(double tx, double ty, double tz) {
    return new GlMatrix.fromList([
      1.0,  0.0,  0.0,  0.0,
      0.0,  1.0,  0.0,  0.0,
      0.0,  0.0,  1.0,  0.0,
      tx,   ty,   tz,   1.0,
    ]);
  }
  static GlMatrix rotationXMatrix(double angleInRadians) {
    double c = Math.cos(angleInRadians);
    double s = Math.sin(angleInRadians);

    return new GlMatrix.fromList([
      1.0, 0.0, 0.0, 0.0,
      0.0, c,   s,  0.0,
      0.0, -s,  c,  0.0,
      0.0, 0.0, 0.0, 1.0,
    ]);
  }
  static GlMatrix rotationYMatrix(double angleInRadians) {
    double c = Math.cos(angleInRadians);
    double s = Math.sin(angleInRadians);

    return new GlMatrix.fromList([
      c, 0.0, -s, 0.0,
      0.0, 1.0, 0.0, 0.0,
      s, 0.0, c, 0.0,
      0.0, 0.0, 0.0, 1.0,
    ]);
  }
  static GlMatrix rotationZMatrix(double angleInRadians) {
    double c = Math.cos(angleInRadians);
    double s = Math.sin(angleInRadians);

    return new GlMatrix.fromList([
      c, s, 0.0, 0.0,
      -s, c, 0.0, 0.0,
      0.0, 0.0, 1.0, 0.0,
      0.0, 0.0, 0.0, 1.0,
    ]);
  }
  static GlMatrix scalingMatrix(double sx, double sy, double sz) {
    return new GlMatrix.fromList([
      sx, 0.0,  0.0,  0.0,
      0.0, sy,  0.0,  0.0,
      0.0,  0.0, sz,  0.0,
      0.0,  0.0,  0.0,  1.0,
    ]);
  }
  static GlMatrix perspectiveMatrix(double fieldOfViewInRadians,double aspect,double near,double far) {
    double f = Math.tan(Math.pi * 0.5 - 0.5 * fieldOfViewInRadians);
    double rangeInv = 1.0 / (near - far);

    return new GlMatrix.fromList([
      f / aspect, 0.0,  0.0,                          0.0,
      0.0,        f,    0.0,                          0.0,
      0.0,        0.0,  (near + far) * rangeInv,      -1.0,
      0.0,        0.0,  near * far * rangeInv * 2.0,  0.0
    ]);
  }
  static GlMatrix lookAtMatrix(GlVector cameraPosition, GlVector target, GlVector up) {
    // camera is in -Z therefor subtract taget from camera
    // zAxis is the angle between the two points. Normalized because we only care about the angle.
    //GlVector zAxis = (cameraPosition-target).normalize();
    GlVector zAxis = cameraPosition.clone().subtractFromThis(target).normalizeThis();//(cameraPosition-target).normalize();
    // xAxis is the perpendicular vector between the angle and a vector pointing upwards
    GlVector xAxis = up.clone().crossThis(zAxis);
    // yAxis is the perpendicular vector between the angle and the xAngle
    GlVector yAxis = zAxis.clone().crossThis(xAxis);

    return new GlMatrix.fromList([
      xAxis.x, xAxis.y, xAxis.z, 0.0,
      yAxis.x, yAxis.y, yAxis.z, 0.0,
      zAxis.x, zAxis.y, zAxis.z, 0.0,
      cameraPosition.x, cameraPosition.y, cameraPosition.z, 1.0,
    ]);
  }
  static GlMatrix projectionMatrix(double width,double height,double depth) {
    // Note: This matrix flips the Y axis so 0 is at the top.
    return new GlMatrix.fromList([
      2.0 / width, 0.0, 0.0, 0.0,
      0.0, -2.0 / height, 0.0, 0.0,
      0.0, 0.0, 2.0 / depth, 0.0,
      -1.0, 1.0, 0.0, 1.0,
    ]);
  }

  GlMatrix clone(){
    Float32List newBuffer = new Float32List(16);
    for(int i = 0; i< 16; i++){
      newBuffer[i] = buffer[i];
    }
    return new GlMatrix.fromBuffer(newBuffer);
  }

  //GlMatrix operator *(GlMatrix b) {
  GlMatrix multThis(GlMatrix b) {
    double a00 = val(0,0);
    double a01 = val(0,1);
    double a02 = val(0,2);
    double a03 = val(0,3);
    double a10 = val(1,0);
    double a11 = val(1,1);
    double a12 = val(1,2);
    double a13 = val(1,3);
    double a20 = val(2,0);
    double a21 = val(2,1);
    double a22 = val(2,2);
    double a23 = val(2,3);
    double a30 = val(3,0);
    double a31 = val(3,1);
    double a32 = val(3,2);
    double a33 = val(3,3);

    double b00 = b.val(0, 0);
    double b01 = b.val(0 ,1);
    double b02 = b.val(0 ,2);
    double b03 = b.val(0 ,3);
    double b10 = b.val(1 ,0);
    double b11 = b.val(1 ,1);
    double b12 = b.val(1 ,2);
    double b13 = b.val(1 ,3);
    double b20 = b.val(2 ,0);
    double b21 = b.val(2 ,1);
    double b22 = b.val(2 ,2);
    double b23 = b.val(2 ,3);
    double b30 = b.val(3 ,0);
    double b31 = b.val(3 ,1);
    double b32 = b.val(3 ,2);
    double b33 = b.val(3 ,3);/*
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
    */
    buffer[0] = b00 * a00 + b01 * a10 + b02 * a20 + b03 * a30;
    buffer[1] = b00 * a01 + b01 * a11 + b02 * a21 + b03 * a31;
    buffer[2] = b00 * a02 + b01 * a12 + b02 * a22 + b03 * a32;
    buffer[3] = b00 * a03 + b01 * a13 + b02 * a23 + b03 * a33;
    buffer[4] = b10 * a00 + b11 * a10 + b12 * a20 + b13 * a30;
    buffer[5] = b10 * a01 + b11 * a11 + b12 * a21 + b13 * a31;
    buffer[6] = b10 * a02 + b11 * a12 + b12 * a22 + b13 * a32;
    buffer[7] = b10 * a03 + b11 * a13 + b12 * a23 + b13 * a33;
    buffer[8] = b20 * a00 + b21 * a10 + b22 * a20 + b23 * a30;
    buffer[9] = b20 * a01 + b21 * a11 + b22 * a21 + b23 * a31;
    buffer[10] = b20 * a02 + b21 * a12 + b22 * a22 + b23 * a32;
    buffer[11] = b20 * a03 + b21 * a13 + b22 * a23 + b23 * a33;
    buffer[12] = b30 * a00 + b31 * a10 + b32 * a20 + b33 * a30;
    buffer[13] = b30 * a01 + b31 * a11 + b32 * a21 + b33 * a31;
    buffer[14] = b30 * a02 + b31 * a12 + b32 * a22 + b33 * a32;
    buffer[15] = b30 * a03 + b31 * a13 + b32 * a23 + b33 * a33;
    return this;
  }

  GlMatrix inverseThis() {
    double m00 = val(0, 0);
    double m01 = val(0, 1);
    double m02 = val(0, 2);
    double m03 = val(0, 3);
    double m10 = val(1, 0);
    double m11 = val(1, 1);
    double m12 = val(1, 2);
    double m13 = val(1, 3);
    double m20 = val(2, 0);
    double m21 = val(2, 1);
    double m22 = val(2, 2);
    double m23 = val(2, 3);
    double m30 = val(3, 0);
    double m31 = val(3, 1);
    double m32 = val(3, 2);
    double m33 = val(3, 3);
    double tmp_0  = m22 * m33;
    double tmp_1  = m32 * m23;
    double tmp_2  = m12 * m33;
    double tmp_3  = m32 * m13;
    double tmp_4  = m12 * m23;
    double tmp_5  = m22 * m13;
    double tmp_6  = m02 * m33;
    double tmp_7  = m32 * m03;
    double tmp_8  = m02 * m23;
    double tmp_9  = m22 * m03;
    double tmp_10 = m02 * m13;
    double tmp_11 = m12 * m03;
    double tmp_12 = m20 * m31;
    double tmp_13 = m30 * m21;
    double tmp_14 = m10 * m31;
    double tmp_15 = m30 * m11;
    double tmp_16 = m10 * m21;
    double tmp_17 = m20 * m11;
    double tmp_18 = m00 * m31;
    double tmp_19 = m30 * m01;
    double tmp_20 = m00 * m21;
    double tmp_21 = m20 * m01;
    double tmp_22 = m00 * m11;
    double tmp_23 = m10 * m01;

    double t0 = (tmp_0 * m11 + tmp_3 * m21 + tmp_4 * m31) -
        (tmp_1 * m11 + tmp_2 * m21 + tmp_5 * m31);
    double t1 = (tmp_1 * m01 + tmp_6 * m21 + tmp_9 * m31) -
        (tmp_0 * m01 + tmp_7 * m21 + tmp_8 * m31);
    double t2 = (tmp_2 * m01 + tmp_7 * m11 + tmp_10 * m31) -
        (tmp_3 * m01 + tmp_6 * m11 + tmp_11 * m31);
    double t3 = (tmp_5 * m01 + tmp_8 * m11 + tmp_11 * m21) -
        (tmp_4 * m01 + tmp_9 * m11 + tmp_10 * m21);

    double d = 1.0 / (m00 * t0 + m10 * t1 + m20 * t2 + m30 * t3);
/*
    return new GlMatrix.fromList([
      d * t0,
      d * t1,
      d * t2,
      d * t3,
      d * ((tmp_1 * m10 + tmp_2 * m20 + tmp_5 * m30) -
          (tmp_0 * m10 + tmp_3 * m20 + tmp_4 * m30)),
      d * ((tmp_0 * m00 + tmp_7 * m20 + tmp_8 * m30) -
          (tmp_1 * m00 + tmp_6 * m20 + tmp_9 * m30)),
      d * ((tmp_3 * m00 + tmp_6 * m10 + tmp_11 * m30) -
          (tmp_2 * m00 + tmp_7 * m10 + tmp_10 * m30)),
      d * ((tmp_4 * m00 + tmp_9 * m10 + tmp_10 * m20) -
          (tmp_5 * m00 + tmp_8 * m10 + tmp_11 * m20)),
      d * ((tmp_12 * m13 + tmp_15 * m23 + tmp_16 * m33) -
          (tmp_13 * m13 + tmp_14 * m23 + tmp_17 * m33)),
      d * ((tmp_13 * m03 + tmp_18 * m23 + tmp_21 * m33) -
          (tmp_12 * m03 + tmp_19 * m23 + tmp_20 * m33)),
      d * ((tmp_14 * m03 + tmp_19 * m13 + tmp_22 * m33) -
          (tmp_15 * m03 + tmp_18 * m13 + tmp_23 * m33)),
      d * ((tmp_17 * m03 + tmp_20 * m13 + tmp_23 * m23) -
          (tmp_16 * m03 + tmp_21 * m13 + tmp_22 * m23)),
      d * ((tmp_14 * m22 + tmp_17 * m32 + tmp_13 * m12) -
          (tmp_16 * m32 + tmp_12 * m12 + tmp_15 * m22)),
      d * ((tmp_20 * m32 + tmp_12 * m02 + tmp_19 * m22) -
          (tmp_18 * m22 + tmp_21 * m32 + tmp_13 * m02)),
      d * ((tmp_18 * m12 + tmp_23 * m32 + tmp_15 * m02) -
          (tmp_22 * m32 + tmp_14 * m02 + tmp_19 * m12)),
      d * ((tmp_22 * m22 + tmp_16 * m02 + tmp_21 * m12) -
          (tmp_20 * m12 + tmp_23 * m22 + tmp_17 * m02))
    ]);
    */


    buffer[0] = d * t0;
    buffer[1] = d * t1;
    buffer[2] = d * t2;
    buffer[3] = d * t3;
    buffer[4] = d * ((tmp_1 * m10 + tmp_2 * m20 + tmp_5 * m30) - (tmp_0 * m10 + tmp_3 * m20 + tmp_4 * m30));
    buffer[5] = d * ((tmp_0 * m00 + tmp_7 * m20 + tmp_8 * m30) - (tmp_1 * m00 + tmp_6 * m20 + tmp_9 * m30));
    buffer[6] = d * ((tmp_3 * m00 + tmp_6 * m10 + tmp_11 * m30) - (tmp_2 * m00 + tmp_7 * m10 + tmp_10 * m30));
    buffer[7] = d * ((tmp_4 * m00 + tmp_9 * m10 + tmp_10 * m20) - (tmp_5 * m00 + tmp_8 * m10 + tmp_11 * m20));
    buffer[8] = d * ((tmp_12 * m13 + tmp_15 * m23 + tmp_16 * m33) - (tmp_13 * m13 + tmp_14 * m23 + tmp_17 * m33));
    buffer[9] = d * ((tmp_13 * m03 + tmp_18 * m23 + tmp_21 * m33) - (tmp_12 * m03 + tmp_19 * m23 + tmp_20 * m33));
    buffer[10] = d * ((tmp_14 * m03 + tmp_19 * m13 + tmp_22 * m33) - (tmp_15 * m03 + tmp_18 * m13 + tmp_23 * m33));
    buffer[11] = d * ((tmp_17 * m03 + tmp_20 * m13 + tmp_23 * m23) - (tmp_16 * m03 + tmp_21 * m13 + tmp_22 * m23));
    buffer[12] = d * ((tmp_14 * m22 + tmp_17 * m32 + tmp_13 * m12) - (tmp_16 * m32 + tmp_12 * m12 + tmp_15 * m22));
    buffer[13] = d * ((tmp_20 * m32 + tmp_12 * m02 + tmp_19 * m22) - (tmp_18 * m22 + tmp_21 * m32 + tmp_13 * m02));
    buffer[14] = d * ((tmp_18 * m12 + tmp_23 * m32 + tmp_15 * m02) - (tmp_22 * m32 + tmp_14 * m02 + tmp_19 * m12));
    buffer[15] = d * ((tmp_22 * m22 + tmp_16 * m02 + tmp_21 * m12) - (tmp_20 * m12 + tmp_23 * m22 + tmp_17 * m02));
    return this;
  }

  GlMatrix translateThis(double tx, double ty, double tz) {
    multThis(translationMatrix(tx, ty, tz));
    //return this * translationMatrix(tx, ty, tz);
    return this;
  }

  GlMatrix rotateXThis(double angleInRadians) {
    //return this * rotationXMatrix(angleInRadians);
    multThis(rotationXMatrix(angleInRadians));
    return this;
  }

  GlMatrix rotateYThis(double angleInRadians) {
    //return this * rotationYMatrix(angleInRadians);
    multThis(rotationYMatrix(angleInRadians));
    return this;
  }

  GlMatrix rotateZThis(double angleInRadians) {
    //return this * rotationZMatrix(angleInRadians);
    multThis(rotationZMatrix(angleInRadians));
    return this;
  }

  GlMatrix scaleThis(double sx, double sy, double sz) {
    //return this * scalingMatrix(sx, sy, sz);
    multThis(scalingMatrix(sx, sy, sz));
    return this;
  }
  GlVector applyToVector(GlVector p) {
    var x = buffer[0] * p.x + buffer[4] * p.y + buffer[8] * p.z + buffer[12];
    var y = buffer[1] * p.x + buffer[5] * p.y + buffer[9] * p.z + buffer[13];
    var z = buffer[2] * p.x + buffer[6] * p.y + buffer[10] * p.z + buffer[14];
    p.x = x;
    p.y = y;
    p.z = z;
    return p;
  }
}