part of webgl;

class Render{
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;
  /// Perspective matrix
  Matrix4 pMatrix;

  /// Model-View matrix.
  Matrix4 mvMatrix;

  List<Matrix4> mvStack = new List<Matrix4>();

  /**
   * Add a copy of the current Model-View matrix to the the stack for future
   * restoration.
   */
  mvPushMatrix() => mvStack.add(new Matrix4.fromMatrix(mvMatrix));

  /**
   * Pop the last matrix off the stack and set the Model View matrix.
   */
  mvPopMatrix() => mvMatrix = mvStack.removeLast();

  Buffer colorRedBuffer;
  GlProgram program;
  GlSquare square0 ,square1;
  GlCube cube1;

  Render(RenderLayer3d layer){
    RenderingContext ctx = layer.ctx;
    mvMatrix = new Matrix4()..identity();

    program = new GlProgram(
        '''
          precision mediump float;

          void main(void) {
            gl_FragColor = vec4(1.0,1.0,1.0,1.0);
          }
        ''',
        '''
          attribute vec3 aVertexPosition;
          attribute vec4 aVertexColor;

          uniform mat4 uMVMatrix;
          uniform mat4 uPMatrix;

          void main(void) {
              gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
          }
        ''',
        ['aVertexPosition'],
        ['uMVMatrix', 'uPMatrix'], layer);
    ctx.useProgram(program.program);

    square0 = new GlSquare(0.0,0.0,0.0,1.0,1.0, ctx);
    square1 = new GlSquare(3.0,0.0,0.0,1.0,1.0, ctx);
    cube1 = new GlCube(4.0,0.0,0.0, 1.0,2.0,3.0, ctx);


    // Specify the color to clear with (black with 100% alpha) and then enable depth testing.
    ctx.clearColor(0.0, 0.0, 0.0, 1.0);
  }

  Buffer _createSquareBuffer(double x, double y, double z, double w, double h, RenderingContext ctx){
    Buffer buffer  = ctx.createBuffer();
    ctx.bindBuffer(ARRAY_BUFFER, buffer);
    //4 points (x,y,z)
    ctx.bufferData(ARRAY_BUFFER,
        new Float32List.fromList(
            [x, y, z,
            x+w, y, z,
            x, y+h, z,
            x+w, y+h, z]),
        STATIC_DRAW);
    return buffer;
  }

  void drawScene(RenderLayer3d layer){
    double aspect = layer.w / layer.h;
    RenderingContext ctx = layer.ctx;
    // Basic viewport setup and clearing of the screen
    ctx.viewport(0, 0, layer.w, layer.h);
    ctx.clear(COLOR_BUFFER_BIT | DEPTH_BUFFER_BIT);
    ctx.enable(DEPTH_TEST);
    ctx.disable(BLEND);

    // Setup the perspective - you might be wondering why we do this every
    // time, and that will become clear in much later lessons. Just know, you
    // are not crazy for thinking of caching this.
    pMatrix = Matrix4.perspective(45.0, aspect, 0.1, 100.0);
    mvPushMatrix();
    mvMatrix.translate([0.0, 0.0, -18.0]);
    mvMatrix.rotateX(x);
    mvMatrix.rotateY(y);
    mvMatrix.rotateZ(z);
    setMatrixUniforms(layer);

    // First stash the current model view matrix before we start moving around.
    mvPushMatrix();
    mvMatrix.translate([cube1.x, cube1.y, 0.0]);
    //transform location

    setMatrixUniforms(layer);

    //square0.draw(program.attributes['aVertexPosition'], ctx);
    cube1.draw(program.attributes['aVertexPosition'], ctx);

    //restore transformation
    mvPopMatrix();
    mvPopMatrix();
  }
  /**
   * Write the matrix uniforms (model view matrix and perspective matrix) so
   * WebGL knows what to do with them.
   */
  setMatrixUniforms(RenderLayer3d layer) {
    layer.ctx.uniformMatrix4fv(program.uniforms['uPMatrix'], false, pMatrix.buf);
    layer.ctx.uniformMatrix4fv(program.uniforms['uMVMatrix'], false, mvMatrix.buf);
  }
}