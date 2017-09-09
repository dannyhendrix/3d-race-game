part of webgl;

class GlSquare extends GlDrawObject{
  GlSquare(double x, double y, double z, double w, double h, RenderingContext ctx):super(x,y, ctx){
    buffer = _createBuffer([
      x, y, z,
      x+w, y, z,
      x, y+h, z,
      x+w, y+h, z
    ], ctx);
  }
  void draw(int vertexIndex, RenderingContext ctx){
    ctx.bindBuffer(ARRAY_BUFFER, buffer);
    ctx.vertexAttribPointer(vertexIndex, 3, FLOAT, false, 0, 0);
    ctx.drawArrays(TRIANGLE_STRIP, 0, 4);
    ctx.drawElements(TRIANGLES, 4, UNSIGNED_SHORT, 0);
  }
}

/*
[
    // Front face
    -1.0, -1.0, 1.0,
    1.0, -1.0, 1.0,
    1.0, 1.0, 1.0,
    -1.0, 1.0, 1.0,

    // Back face
    -1.0, -1.0, -1.0,
    -1.0, 1.0, -1.0,
    1.0, 1.0, -1.0,
    1.0, -1.0, -1.0,

    // Top face
    -1.0, 1.0, -1.0,
    -1.0, 1.0, 1.0,
    1.0, 1.0, 1.0,
    1.0, 1.0, -1.0,

    // Bottom face
    -1.0, -1.0, -1.0,
    1.0, -1.0, -1.0,
    1.0, -1.0, 1.0,
    -1.0, -1.0, 1.0,

    // Right face
    1.0, -1.0, -1.0,
    1.0, 1.0, -1.0,
    1.0, 1.0, 1.0,
    1.0, -1.0, 1.0,

    // Left face
    -1.0, -1.0, -1.0,
    -1.0, -1.0, 1.0,
    -1.0, 1.0, 1.0,
    -1.0, 1.0, -1.0
  ]
 */

class GlCube extends GlDrawObject{
  Buffer indexBuffer;
  GlCube(double x, double y, double z, double w, double h, double d, RenderingContext ctx):super(x,y, ctx){
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
  }

  void draw(int vertexIndex, RenderingContext ctx){
    ctx.bindBuffer(ARRAY_BUFFER, buffer);
    ctx.vertexAttribPointer(vertexIndex, 3, FLOAT, false, 0, 0);
    ctx.bindBuffer(ARRAY_BUFFER, indexBuffer);
    ctx.drawElements(TRIANGLES, 36, UNSIGNED_SHORT, 0);
  }
}

class GlDrawObject{
  Buffer buffer;
  double x,y;

  //4 points (x,y,z)
  GlDrawObject(this.x,this.y,RenderingContext ctx){

  }

  Buffer _createBuffer(List<double> positions, RenderingContext ctx){
    Buffer buffer  = ctx.createBuffer();
    ctx.bindBuffer(ARRAY_BUFFER, buffer);
    ctx.bufferData(ARRAY_BUFFER, new Float32List.fromList(positions), STATIC_DRAW);
    return buffer;
  }

  void draw(int vertexIndex, RenderingContext ctx){
  }
}