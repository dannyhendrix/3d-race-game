part of webgl;

class GlProgram{

  static String fragmentShader = '''
          precision mediump float;

        // Passed in from the vertex shader.
        varying vec3 v_normal;
        varying vec2 v_texcoord;

        uniform float f_lightImpact;
        uniform vec4 u_color;
        uniform vec3 u_reverseLightDirection;
        // The texture.
        uniform sampler2D u_texture;

        void main() {
           // because v_normal is a varying it's interpolated
           // we it will not be a uint vector. Normalizing it
           // will make it a unit vector again
           vec3 normal = normalize(v_normal);

           float light = dot(normal, u_reverseLightDirection);
           if(light > 1.0) light = 1.0;
           float lightFactor = (1.0-f_lightImpact)+(light*f_lightImpact);

           //gl_FragColor = u_color;
           gl_FragColor = texture2D(u_texture, v_texcoord);

           // Lets multiply just the color portion (not the alpha)
           // by the light

           gl_FragColor.rgb *= lightFactor;
        }
        ''';
  static String vertexShader =  '''
        attribute vec4 a_position;
        attribute vec3 a_normal;
        attribute vec2 a_texcoord;

        uniform mat4 u_worldViewProjection;
        uniform mat4 u_world;
        varying vec3 v_normal;
        varying vec2 v_texcoord;

        void main() {
           // Multiply the position by the matrix.
          gl_Position = u_worldViewProjection * a_position;

          // orient the normals and pass to the fragment shader
          v_normal = mat3(u_worldViewProjection) * a_normal;
          //v_normal = a_normal;
          
          // Pass the texcoord to the fragment shader.
          v_texcoord = a_texcoord;
        }
      ''';

  int attr_Position;
  int attr_Normal;
  UniformLocation uni_world;
  UniformLocation uni_worldViewProjection;
  UniformLocation uni_Color;
  UniformLocation uni_lightImpact;
  UniformLocation uni_reverseLightDirection;
  Program program;
  int attr_TexCoord;

  GlProgram(RenderingContext ctx){
    Shader fragShader = ctx.createShader(WebGL.FRAGMENT_SHADER);
    ctx.shaderSource(fragShader, fragmentShader);
    ctx.compileShader(fragShader);

    Shader vertShader = ctx.createShader(WebGL.VERTEX_SHADER);
    ctx.shaderSource(vertShader, vertexShader);
    ctx.compileShader(vertShader);

    program = ctx.createProgram();
    ctx.attachShader(program, vertShader);
    ctx.attachShader(program, fragShader);
    ctx.linkProgram(program);

    if (!ctx.getProgramParameter(program, WebGL.LINK_STATUS)) throw new Exception("Could not initialise shaders");

    attr_Position =  ctx.getAttribLocation(program, "a_position");
    attr_Normal =  ctx.getAttribLocation(program, "a_normal");
    attr_TexCoord =  ctx.getAttribLocation(program, "a_texcoord");
    uni_world = ctx.getUniformLocation(program, "u_world");
    uni_worldViewProjection = ctx.getUniformLocation(program, "u_worldViewProjection");
    uni_Color = ctx.getUniformLocation(program, "u_color");
    uni_reverseLightDirection = ctx.getUniformLocation(program, "u_reverseLightDirection");
    uni_lightImpact = ctx.getUniformLocation(program, "f_lightImpact");
  }
}
/*
class GlProgramSolidColors extends GlProgram{
  static String fragmentShader = '''
          precision mediump float;

        // Passed in from the vertex shader.
        varying vec3 v_normal;

        uniform float f_lightImpact;
        uniform vec4 u_color;
        uniform vec3 u_reverseLightDirection;

        void main() {
           // because v_normal is a varying it's interpolated
           // we it will not be a uint vector. Normalizing it
           // will make it a unit vector again
           vec3 normal = normalize(v_normal);

           float light = dot(normal, u_reverseLightDirection);
           if(light > 1.0) light = 1.0;
           float lightFactor = (1.0-f_lightImpact)+(light*f_lightImpact);

           gl_FragColor = u_color;

           // Lets multiply just the color portion (not the alpha)
           // by the light

           gl_FragColor.rgb *= lightFactor;
        }
        ''';
  static String vertexShader =  '''
        attribute vec4 a_position;
        attribute vec3 a_normal;
        attribute vec2 a_texcoord;

        uniform mat4 u_worldViewProjection;
        uniform mat4 u_world;
        varying vec3 v_normal;

        void main() {
           // Multiply the position by the matrix.
          gl_Position = u_worldViewProjection * a_position;

          // orient the normals and pass to the fragment shader
          v_normal = mat3(u_worldViewProjection) * a_normal;
          //v_normal = a_normal;
        }
      ''';

  GlProgramSolidColors(RenderingContext ctx){
    Shader fragShader = ctx.createShader(WebGL.FRAGMENT_SHADER);
    ctx.shaderSource(fragShader, fragmentShader);
    ctx.compileShader(fragShader);

    Shader vertShader = ctx.createShader(WebGL.VERTEX_SHADER);
    ctx.shaderSource(vertShader, vertexShader);
    ctx.compileShader(vertShader);

    program = ctx.createProgram();
    ctx.attachShader(program, vertShader);
    ctx.attachShader(program, fragShader);
    ctx.linkProgram(program);

    attr_Position =  ctx.getAttribLocation(program, "a_position");
    attr_Normal =  ctx.getAttribLocation(program, "a_normal");
    uni_world = ctx.getUniformLocation(program, "u_world");
    uni_worldViewProjection = ctx.getUniformLocation(program, "u_worldViewProjection");
    uni_Color = ctx.getUniformLocation(program, "u_color");
    uni_reverseLightDirection = ctx.getUniformLocation(program, "u_reverseLightDirection");
    uni_lightImpact = ctx.getUniformLocation(program, "f_lightImpact");
  }
}

class GlProgramTextures extends GlProgram{


}*/