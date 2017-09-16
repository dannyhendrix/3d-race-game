part of webgl;

class GlSquare extends GlDrawObject{
  GlSquare(double x, double y, double z, double w, double h, RenderingContext ctx):super(x,y,z, ctx){
    buffer = _createBuffer([
      x, y, z,
      x+w, y, z,
      x, y+h, z,
      x+w, y+h, z
    ], ctx);
  }
  void draw(int vertexIndex, RenderLayer3d layer){
    RenderingContext ctx = layer.ctx;
    ctx.bindBuffer(ARRAY_BUFFER, buffer);
    ctx.vertexAttribPointer(vertexIndex, 3, FLOAT, false, 0, 0);
    ctx.drawArrays(TRIANGLE_STRIP, 0, 4);
    ctx.drawElements(TRIANGLES, 4, UNSIGNED_SHORT, 0);
  }
}

class GlCubeGameObject extends GlCube2{
  GameObject gameObject;
  double get x => gameObject.position.x;
  double get z => gameObject.position.y;
  double get ry => -gameObject.r;
  //GlCube(double x, double y, double z, double w, double h, double d, RenderingContext ctx):super(x,y,z, ctx)
  GlCubeGameObject(this.gameObject, double height, RenderingContext ctx):super(0.0,0.0,0.0,gameObject.w,height,gameObject.h, ctx){
  }
}

class GlCube2 extends GlDrawObject{
  Buffer indexBuffer;
  Buffer normalBuffer;
  GlCube2(double x, double y, double z, double w, double h, double d, RenderingContext ctx):super(x,y,z, ctx){
    double hw = w/2;
    double hh = h/2;
    double hd = d/2;
    buffer = _createBuffer([
      // Front face
      -hw, -hh, hd,
      hw, -hh, hd,
      hw, hh, hd,
      -hw, hh, hd,

      // Back face
      -hw, -hh, -hd,
      -hw, hh, -hd,
      hw, hh, -hd,
      hw, -hh, -hd,

      // Top face
      -hw, hh, -hd,
      -hw, hh, hd,
      hw, hh, hd,
      hw, hh, -hd,

      // Bottom face
      -hw, -hh, -hd,
      hw, -hh, -hd,
      hw, -hh, hd,
      -hw, -hh, hd,

      // Right face
      hw, -hh, -hd,
      hw, hh, -hd,
      hw, hh, hd,
      hw, -hh, hd,

      // Left face
      -hw, -hh, -hd,
      -hw, -hh, hd,
      -hw, hh, hd,
      -hw, hh, -hd
    ],ctx);
    indexBuffer = ctx.createBuffer();
    ctx.bindBuffer(ELEMENT_ARRAY_BUFFER, indexBuffer);
    ctx.bufferData(
        ELEMENT_ARRAY_BUFFER,
        new Uint16List.fromList([
          0, 1, 2,      0, 2, 3, // Front face
          4, 5, 6,      4, 6, 7, // Back face
          8, 9, 10,     8, 10, 11, // Top face
          12, 13, 14,   12, 14, 15, // Bottom face
          16, 17, 18,   16, 18, 19, // Right face
          20, 21, 22,   20, 22, 23 // Left face
        ]),
        STATIC_DRAW);




    List<double> vertexNormals = [
      // Front
      0.0,  0.0,  1.0,
      0.0,  0.0,  1.0,
      0.0,  0.0,  1.0,
      0.0,  0.0,  1.0,

      // Back
      0.0,  0.0, -1.0,
      0.0,  0.0, -1.0,
      0.0,  0.0, -1.0,
      0.0,  0.0, -1.0,

      // Top
      0.0,  1.0,  0.0,
      0.0,  1.0,  0.0,
      0.0,  1.0,  0.0,
      0.0,  1.0,  0.0,

      // Bottom
      0.0, -1.0,  0.0,
      0.0, -1.0,  0.0,
      0.0, -1.0,  0.0,
      0.0, -1.0,  0.0,

      // Right
      1.0,  0.0,  0.0,
      1.0,  0.0,  0.0,
      1.0,  0.0,  0.0,
      1.0,  0.0,  0.0,

      // Left
      -1.0,  0.0,  0.0,
      -1.0,  0.0,  0.0,
      -1.0,  0.0,  0.0,
      -1.0,  0.0,  0.0
    ];

    normalBuffer = ctx.createBuffer();
    ctx.bindBuffer(ARRAY_BUFFER, normalBuffer);
    ctx.bufferData(ARRAY_BUFFER, new Float32List.fromList(vertexNormals), STATIC_DRAW);
  }

  void draw(int vertexIndex, RenderLayer3d layer){
    RenderingContext ctx = layer.ctx;

    layer.mvPushMatrix();
    layer.mvMatrix.translate([x,y,z]);
    layer.mvMatrix.rotateX(rx);
    layer.mvMatrix.rotateY(ry);
    layer.mvMatrix.rotateZ(rz);
    layer.setMatrixUniforms();

    Matrix4 normalMatrix = layer.mvMatrix.inverse();
    normalMatrix = normalMatrix.transpose();
    layer.ctx.uniformMatrix4fv(layer.program.uniforms['uNormalMatrix'], false, normalMatrix.buf);

    // set vertex buffer
    ctx.bindBuffer(ARRAY_BUFFER, buffer);
    ctx.vertexAttribPointer(vertexIndex, 3, FLOAT, false, 0, 0);
    // set normal vertex buffer
    ctx.bindBuffer(ARRAY_BUFFER, normalBuffer);
    ctx.vertexAttribPointer(layer.program.attributes['aVertexNormal'],3,FLOAT,false,0,0);
    ctx.enableVertexAttribArray(layer.program.attributes['aVertexNormal']);
    // draw cube
    ctx.bindBuffer(ELEMENT_ARRAY_BUFFER, indexBuffer);
    ctx.drawElements(TRIANGLES, 36, UNSIGNED_SHORT, 0);

    layer.mvPopMatrix();
  }
}

class GlDrawObject{
  Buffer buffer;
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;
  double rx = 0.0;
  double ry = 0.0;
  double rz = 0.0;

  //4 points (x,y,z)
  GlDrawObject(this.x,this.y, this.z,RenderingContext ctx){

  }

  Buffer _createBuffer(List<double> positions, RenderingContext ctx){
    Buffer buffer  = ctx.createBuffer();
    ctx.bindBuffer(ARRAY_BUFFER, buffer);
    ctx.bufferData(ARRAY_BUFFER, new Float32List.fromList(positions), STATIC_DRAW);
    return buffer;
  }

  void draw(int vertexIndex, RenderLayer3d layer){
  }
}