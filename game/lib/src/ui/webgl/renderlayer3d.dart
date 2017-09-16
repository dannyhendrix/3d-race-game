part of webgl;

class RenderLayer3d{
  GlProgramOld program;
  CanvasElement canvas;
  RenderingContext ctx;
  int w,h;

  Matrix4 pMatrix;  // Perspective matrix
  Matrix4 mvMatrix; // Model-View matrix.

  List<Matrix4> mvStack = new List<Matrix4>();
  mvPushMatrix() => mvStack.add(new Matrix4.fromMatrix(mvMatrix));
  mvPopMatrix() => mvMatrix = mvStack.removeLast();

  RenderLayer3d(this.w, this.h){
    canvas = new CanvasElement();
    canvas.height = w;
    canvas.width = h;
    ctx = canvas.getContext3d();
    if (ctx == null)
      throw new Exception("Could not create 3d context!");

    mvMatrix = new Matrix4()..identity();

    program = new GlProgramOld(
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
        ['uNormalMatrix','uMVMatrix', 'uPMatrix'], this);
    ctx.useProgram(program.program);
  }

  setMatrixUniforms() {
    ctx.uniformMatrix4fv(program.uniforms['uPMatrix'], false, pMatrix.buf);
    ctx.uniformMatrix4fv(program.uniforms['uMVMatrix'], false, mvMatrix.buf);
  }
}