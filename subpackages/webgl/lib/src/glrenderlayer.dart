part of webgl;

enum GlProgramType {Texture, ColorsOnly}
class GlProgramManager{
  GlProgramType _current = GlProgramType.Texture;
  Map<GlProgramType, GlProgram> _programs = {};
  void init(RenderingContext ctx, bool enableTextures){
    var colorsProgram = new GlProgramSolidColors(ctx);
    _programs[GlProgramType.ColorsOnly] = colorsProgram;
    if(enableTextures){
      var textureProgram = new GlProgramTextures(ctx);
      _programs[GlProgramType.Texture] = textureProgram;
    }else{
      _programs[GlProgramType.Texture] = colorsProgram;
    }
    ctx.useProgram(_programs[_current].program);
  }
  GlProgram selectProgram(RenderingContext ctx, GlProgramType program){
    if(_current != program){
      _current = program;
      ctx.useProgram(_programs[program].program);
    }
    return _programs[_current];
  }
}

class GlRenderLayer{
  CanvasElement canvas;
  RenderingContext ctx;
  bool _enableCullFace = false;
  GlProgramManager _programManager;
  Map<String, Texture> _textures = {};
  double x = 0.0, y =0.0, z =0.0;
  double rx = 0.0, ry =0.0, rz =0.0;

  GlRenderLayer.fromCanvas(this.canvas, [this._enableCullFace = false, bool enableTextures = true]){
    _init(enableTextures);
  }
  GlRenderLayer.withSize(int w, int h, [this._enableCullFace = false, bool enableTextures = true]){
    canvas = new CanvasElement();
    canvas.width = w;
    canvas.height = h;
    _init(enableTextures);
  }

  void setTexture(String id, dynamic image, [bool clamp = false]){
    var texture = ctx.createTexture();
    ctx.bindTexture(WebGL.TEXTURE_2D, texture);
    if(clamp)
    {
      ctx.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_S, WebGL.CLAMP_TO_EDGE);
      ctx.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_T, WebGL.CLAMP_TO_EDGE);
      //ctx.texParameteri(WebGL.TEXTURE_2D, WebGL.T, WebGL.CLAMP_TO_EDGE);
    }
    else
    {
      ctx.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MIN_FILTER, WebGL.NEAREST);
      ctx.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MAG_FILTER, WebGL.NEAREST);
      ctx.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_S, WebGL.REPEAT);
      ctx.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_T, WebGL.REPEAT);
    }
    ctx.texImage2D(WebGL.TEXTURE_2D, 0, WebGL.RGBA, WebGL.RGBA,WebGL.UNSIGNED_BYTE, image);
    ctx.generateMipmap(WebGL.TEXTURE_2D);
    _textures[id] = texture;
  }

  void _init(bool enableTextures){
    ctx = canvas.getContext3d();
    if (ctx == null)
      throw new Exception("Could not create 3d context!");
    ctx.clearColor(0.0, 0.0, 0.0, 1.0);
    // by default backfacing triangles will be culled
    if(!_enableCullFace) ctx.enable(WebGL.CULL_FACE);
    ctx.enable(WebGL.DEPTH_TEST);
    _programManager = new GlProgramManager();
    _programManager.init(ctx, enableTextures);
  }

  void setClearColor(GlColor color){
    ctx.clearColor(color.r,color.g,color.b, color.a);
  }

  void drawModel(GlModelInstance model){
    var program = _programManager.selectProgram(ctx, model.texture == null ? GlProgramType.ColorsOnly : GlProgramType.Texture);
    program.setColor(ctx,model.color);
    program.setPosition(ctx,model.modelBuffer.vertexBuffer);
    program.setNormals(ctx,model.modelBuffer.normalsBuffer);
    program.setTextureCoordinates(ctx,model.modelBuffer.textureBuffer);
    program.setTextureScale(ctx, new Float32List.fromList([1.0,1.0]));
    if( model.texture != null){
      ctx.bindTexture(WebGL.TEXTURE_2D, _textures[model.texture]);
    }
    ctx.drawArrays(WebGL.TRIANGLES, 0, model.modelBuffer.numberOfTriangles*3);
  }

  void setWorld(GlMatrix world, GlMatrix worldViewProjection, GlVector lightSource, double lightImpact){
    //lightSource.clone().normalizeThis();
    for(var programType in GlProgramType.values){
      var program = _programManager.selectProgram(ctx, programType);
      program.setReverseLigtDirection(ctx, new Float32List.fromList([lightSource.x, lightSource.y, lightSource.z]));
      program.setWorld(ctx, world.buffer);
      program.setWorldViewProjection(ctx, worldViewProjection.buffer);
      program.setLightImpact(ctx, lightImpact);
    }
  }
  void clearForNextFrame(){
    ctx.clear(WebGL.COLOR_BUFFER_BIT | WebGL.DEPTH_BUFFER_BIT);
    //1.0,0.8,0.6
  }
}