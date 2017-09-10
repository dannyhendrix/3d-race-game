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
  GlCube cube1, cube2;

  Render(RenderLayer3d layer){
    RenderingContext ctx = layer.ctx;
    mvMatrix = new Matrix4()..identity();

    program = new GlProgram(
        '''
          varying highp vec3 vLighting;

          void main(void) {
            highp vec4 texelColor = vec4(1.0,1.0,1.0,1.0);

            gl_FragColor = vec4(texelColor.rgb * vLighting, texelColor.a);
          }
        ''',
        '''
          attribute vec3 aVertexPosition;
          attribute vec3 aVertexNormal;

          uniform mat4 uNormalMatrix;
          uniform mat4 uMVMatrix;
          uniform mat4 uPMatrix;

          varying highp vec3 vLighting;

          void main(void) {
            gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);

            // Apply lighting effect

            highp vec3 ambientLight = vec3(0.3, 0.3, 0.3);
            highp vec3 directionalLightColor = vec3(1, 1, 1);
            highp vec3 directionalVector = normalize(vec3(0.85, 0.8, 0.75));

            highp vec4 transformedNormal = uNormalMatrix * vec4(aVertexNormal, 1.0);

            highp float directional = max(dot(transformedNormal.xyz, directionalVector), 0.0);
            vLighting = ambientLight + (directionalLightColor * directional);
          }
        ''',
        ['aVertexPosition','aVertexNormal'],
        ['uNormalMatrix','uMVMatrix', 'uPMatrix'], layer);
    ctx.useProgram(program.program);

    square0 = new GlSquare(0.0,0.0,0.0,1.0,1.0, ctx);
    square1 = new GlSquare(3.0,0.0,0.0,1.0,1.0, ctx);
    cube1 = new GlCube(4.0,0.0,0.0, 1.0,2.0,3.0, ctx);
    cube2 = new GlCube(-2.0,0.0,0.0, 1.0,2.0,3.0, ctx);
    cube2.ry = 1.3;


    // Specify the color to clear with (black with 100% alpha) and then enable depth testing.
    ctx.clearColor(0.0, 0.0, 0.0, 1.0);


    var normalBuffer = ctx.createBuffer();
    ctx.bindBuffer(ARRAY_BUFFER, normalBuffer);

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

    ctx.bufferData(ARRAY_BUFFER, new Float32List.fromList(vertexNormals), STATIC_DRAW);
    ctx.vertexAttribPointer(
        program.attributes['aVertexNormal'],
        3,
        FLOAT,
        false,
        0,
        0);
    ctx.enableVertexAttribArray(program.attributes['aVertexNormal']);

    //Matrix4 normalMatrix = new Matrix4.fromMatrix(mvMatrix);
    Matrix4 normalMatrix = mvMatrix.inverse();
    normalMatrix = normalMatrix.inverse();
    normalMatrix = normalMatrix.transpose();
    layer.ctx.uniformMatrix4fv(program.uniforms['uNormalMatrix'], false, normalMatrix.buf);
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
    mvMatrix.translate([0.0, 0.0, -38.0]);
    mvMatrix.rotateX(x);
    mvMatrix.rotateY(y);
    mvMatrix.rotateZ(z);
    setMatrixUniforms(layer);

    // First stash the current model view matrix before we start moving around.
    mvPushMatrix();
    mvMatrix.translate([cube1.x, cube1.y, 0.0]);
    mvMatrix.rotateX(cube1.rx);
    setMatrixUniforms(layer);

    Matrix4 normalMatrix = mvMatrix.inverse();
    normalMatrix = normalMatrix.transpose();
    layer.ctx.uniformMatrix4fv(program.uniforms['uNormalMatrix'], false, normalMatrix.buf);

    //square0.draw(program.attributes['aVertexPosition'], ctx);
    cube1.draw(program.attributes['aVertexPosition'], ctx);

    //restore transformation
    mvPopMatrix();


    mvPushMatrix();
    mvMatrix.translate([cube2.x, cube2.y, cube2.z]);
    mvMatrix.rotateX(cube2.rx);
    mvMatrix.rotateY(cube2.ry);
    mvMatrix.rotateZ(cube2.rz);
    setMatrixUniforms(layer);

    normalMatrix = mvMatrix.inverse();
    normalMatrix = normalMatrix.transpose();
    layer.ctx.uniformMatrix4fv(program.uniforms['uNormalMatrix'], false, normalMatrix.buf);

    cube2.draw(program.attributes['aVertexPosition'], ctx);
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