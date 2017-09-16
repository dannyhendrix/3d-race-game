part of webgl;

class GlProgram{
  static String fragmentShader = '''
          precision mediump float;

        // Passed in from the vertex shader.
        varying float v_color_r;
        varying float v_color_g;
        varying float v_color_b;
        varying float v_color_a;

        void main() {
           gl_FragColor = vec4(v_color_r,v_color_g,v_color_b,v_color_a);
           //gl_FragColor = vec4(1.0,1.0,1.0,1.0);
        }
        ''';
  static String vertexShader =  '''
        attribute vec4 a_position;
        attribute float a_color_r;
        attribute float a_color_g;
        attribute float a_color_b;
        attribute float a_color_a;

        uniform mat4 u_matrix;

        varying float v_color_r;
        varying float v_color_g;
        varying float v_color_b;
        varying float v_color_a;

        void main() {
          // Multiply the position by the matrix.
          gl_Position = u_matrix * a_position;

          // Pass the color to the fragment shader.
          v_color_r = a_color_r;
          v_color_g = a_color_g;
          v_color_b = a_color_b;
          v_color_a = a_color_a;
        }
      ''';
  int attr_Position;
  int attr_ColorR;
  int attr_ColorG;
  int attr_ColorB;
  int attr_ColorA;
  UniformLocation uni_Matrix;
  Program program;

  GlProgram(RenderingContext ctx){
    Shader fragShader = ctx.createShader(FRAGMENT_SHADER);
    ctx.shaderSource(fragShader, fragmentShader);
    ctx.compileShader(fragShader);

    Shader vertShader = ctx.createShader(VERTEX_SHADER);
    ctx.shaderSource(vertShader, vertexShader);
    ctx.compileShader(vertShader);

    program = ctx.createProgram();
    ctx.attachShader(program, vertShader);
    ctx.attachShader(program, fragShader);
    ctx.linkProgram(program);

    if (!ctx.getProgramParameter(program, LINK_STATUS)) throw new Exception("Could not initialise shaders");

    attr_Position =  ctx.getAttribLocation(program, "a_position");
    attr_ColorR = ctx.getAttribLocation(program, "a_color_r");
    attr_ColorG = ctx.getAttribLocation(program, "a_color_g");
    attr_ColorB = ctx.getAttribLocation(program, "a_color_b");
    attr_ColorA = ctx.getAttribLocation(program, "a_color_a");
    uni_Matrix = ctx.getUniformLocation(program, "u_matrix");
  }

}