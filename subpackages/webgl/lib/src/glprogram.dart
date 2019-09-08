part of webgl;

abstract class GlProgram{
  Program program;
  void setPosition(RenderingContext ctx, Buffer buffer){  }
  void setNormals(RenderingContext ctx, Buffer buffer){  }
  void setTextureCoordinates(RenderingContext ctx, Buffer buffer){  }
  void setColor(RenderingContext ctx, GlColor color){}
  void setReverseLigtDirection(RenderingContext ctx, Float32List lightSource){}
  void setWorld(RenderingContext ctx, Float32List buffer){ }
  void setWorldViewProjection(RenderingContext ctx, Float32List buffer){ }
  void setLightImpact(RenderingContext ctx, double lightImpact){ }
}
class GlProgramTextures extends GlProgram{

  static String _fragmentShader = '''
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

           gl_FragColor = texture2D(u_texture, v_texcoord);

           // Lets multiply just the color portion (not the alpha)
           // by the light

           gl_FragColor.rgb *= lightFactor;
        }
        ''';
  static String _vertexShader =  '''
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

  int _attr_Position;
  int _attr_Normal;
  UniformLocation _uni_world;
  UniformLocation _uni_worldViewProjection;
  UniformLocation _uni_Color;
  UniformLocation _uni_lightImpact;
  UniformLocation _uni_reverseLightDirection;
  int _attr_TexCoord;

  GlProgramTextures(RenderingContext ctx){
    Shader fragShader = ctx.createShader(WebGL.FRAGMENT_SHADER);
    ctx.shaderSource(fragShader, _fragmentShader);
    ctx.compileShader(fragShader);

    Shader vertShader = ctx.createShader(WebGL.VERTEX_SHADER);
    ctx.shaderSource(vertShader, _vertexShader);
    ctx.compileShader(vertShader);

    program = ctx.createProgram();
    ctx.attachShader(program, vertShader);
    ctx.attachShader(program, fragShader);
    ctx.linkProgram(program);

    if (!ctx.getProgramParameter(program, WebGL.LINK_STATUS)) throw new Exception("Could not initialise shaders");

    _attr_Position =  ctx.getAttribLocation(program, "a_position");
    _attr_Normal =  ctx.getAttribLocation(program, "a_normal");
    _attr_TexCoord =  ctx.getAttribLocation(program, "a_texcoord");
    _uni_world = ctx.getUniformLocation(program, "u_world");
    _uni_worldViewProjection = ctx.getUniformLocation(program, "u_worldViewProjection");
    _uni_Color = ctx.getUniformLocation(program, "u_color");
    _uni_reverseLightDirection = ctx.getUniformLocation(program, "u_reverseLightDirection");
    _uni_lightImpact = ctx.getUniformLocation(program, "f_lightImpact");
  }

  void setPosition(RenderingContext ctx, Buffer buffer){
    ctx.enableVertexAttribArray(_attr_Position);
    ctx.bindBuffer(WebGL.ARRAY_BUFFER, buffer);
    ctx.vertexAttribPointer(_attr_Position, 3, WebGL.FLOAT, false, 0, 0);
  }
  void setNormals(RenderingContext ctx, Buffer buffer){
    ctx.enableVertexAttribArray(_attr_Normal);
    ctx.bindBuffer(WebGL.ARRAY_BUFFER, buffer);
    ctx.vertexAttribPointer(_attr_Normal, 3, WebGL.FLOAT, false, 0, 0);
  }
  void setTextureCoordinates(RenderingContext ctx, Buffer buffer){
    ctx.enableVertexAttribArray(_attr_TexCoord);
    ctx.bindBuffer(WebGL.ARRAY_BUFFER, buffer);
    ctx.vertexAttribPointer(_attr_TexCoord, 2, WebGL.FLOAT, false, 0, 0);
  }
  void setColor(RenderingContext ctx, GlColor color){
    ctx.uniform4fv(_uni_Color, new Float32List.fromList([color.r,color.g,color.b,color.a]));
  }
  void setReverseLigtDirection(RenderingContext ctx, Float32List lightSource){
    ctx.uniform3fv(_uni_reverseLightDirection, lightSource);
  }
  void setWorld(RenderingContext ctx, Float32List buffer){
    ctx.uniformMatrix4fv(_uni_world, false, buffer);
  }
  void setWorldViewProjection(RenderingContext ctx, Float32List buffer){
    ctx.uniformMatrix4fv(_uni_worldViewProjection, false, buffer);
  }
  void setLightImpact(RenderingContext ctx, double lightImpact){
    ctx.uniform1f(_uni_lightImpact, lightImpact);
  }
}

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

  int _attr_Position;
  int _attr_Normal;
  UniformLocation _uni_world;
  UniformLocation _uni_worldViewProjection;
  UniformLocation _uni_Color;
  UniformLocation _uni_lightImpact;
  UniformLocation _uni_reverseLightDirection;
  int _attr_TexCoord;

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

    _attr_Position =  ctx.getAttribLocation(program, "a_position");
    _attr_Normal =  ctx.getAttribLocation(program, "a_normal");
    _uni_world = ctx.getUniformLocation(program, "u_world");
    _uni_worldViewProjection = ctx.getUniformLocation(program, "u_worldViewProjection");
    _uni_Color = ctx.getUniformLocation(program, "u_color");
    _uni_reverseLightDirection = ctx.getUniformLocation(program, "u_reverseLightDirection");
    _uni_lightImpact = ctx.getUniformLocation(program, "f_lightImpact");
  }

  void setPosition(RenderingContext ctx, Buffer buffer){
    ctx.enableVertexAttribArray(_attr_Position);
    ctx.bindBuffer(WebGL.ARRAY_BUFFER, buffer);
    ctx.vertexAttribPointer(_attr_Position, 3, WebGL.FLOAT, false, 0, 0);
  }
  void setNormals(RenderingContext ctx, Buffer buffer){
    ctx.enableVertexAttribArray(_attr_Normal);
    ctx.bindBuffer(WebGL.ARRAY_BUFFER, buffer);
    ctx.vertexAttribPointer(_attr_Normal, 3, WebGL.FLOAT, false, 0, 0);
  }
  void setTextureCoordinates(RenderingContext ctx, Buffer buffer){
  }
  void setColor(RenderingContext ctx, GlColor color){
    ctx.uniform4fv(_uni_Color, new Float32List.fromList([color.r,color.g,color.b,color.a]));
  }
  void setReverseLigtDirection(RenderingContext ctx, Float32List lightSource){
    ctx.uniform3fv(_uni_reverseLightDirection, lightSource);
  }
  void setWorld(RenderingContext ctx, Float32List buffer){
    ctx.uniformMatrix4fv(_uni_world, false, buffer);
  }
  void setWorldViewProjection(RenderingContext ctx, Float32List buffer){
    ctx.uniformMatrix4fv(_uni_worldViewProjection, false, buffer);
  }
  void setLightImpact(RenderingContext ctx, double lightImpact){
    ctx.uniform1f(_uni_lightImpact, lightImpact);
  }
}