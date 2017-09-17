part of webgl;

class GlProgram{
  static String fragmentShader = '''
          precision mediump float;

        // Passed in from the vertex shader.
        varying vec3 v_normal;

        uniform vec4 u_color;
        uniform vec3 u_reverseLightDirection;

        void main() {
           // because v_normal is a varying it's interpolated
           // we it will not be a uint vector. Normalizing it
           // will make it a unit vector again
           vec3 normal = normalize(v_normal);

           float light = dot(normal, u_reverseLightDirection);

           gl_FragColor = u_color;

           // Lets multiply just the color portion (not the alpha)
           // by the light
           gl_FragColor.rgb *= light;


           //gl_FragColor = vec4(v_color_r,v_color_g,v_color_b,v_color_a);

        }
        ''';
  static String vertexShader =  '''
        attribute vec4 a_position;
        attribute vec3 a_normal;

        uniform mat4 u_worldViewProjection;
        uniform mat4 u_world;
        varying vec3 v_normal;

        void main() {
           // Multiply the position by the matrix.
          gl_Position = u_worldViewProjection * a_position;

          // orient the normals and pass to the fragment shader
          v_normal = mat3(u_world) * a_normal;
        }
      ''';
  int attr_Position;
  int attr_Normal;
  UniformLocation uni_world;
  UniformLocation uni_worldViewProjection;
  UniformLocation uni_Color;
  UniformLocation uni_reverseLightDirection;
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
    attr_Normal =  ctx.getAttribLocation(program, "a_normal");
    uni_world = ctx.getUniformLocation(program, "u_world");
    uni_worldViewProjection = ctx.getUniformLocation(program, "u_worldViewProjection");
    uni_Color = ctx.getUniformLocation(program, "u_color");
    uni_reverseLightDirection = ctx.getUniformLocation(program, "u_reverseLightDirection");
  }

}