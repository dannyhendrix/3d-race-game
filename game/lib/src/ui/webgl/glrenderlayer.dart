part of webgl;

class GlRenderLayer{
  CanvasElement canvas;
  RenderingContext ctx;
  bool _enableCullFace = false;
  GlProgram program;
  double x = 0.0, y =0.0, z =0.0;
  double rx = 0.0, ry =0.0, rz =0.0;

  GlRenderLayer.fromCanvas(this.canvas, [this._enableCullFace = false]){
    _init();
  }
  GlRenderLayer.withSize(int w, int h, [this._enableCullFace = false]){
    canvas = new CanvasElement();
    canvas.width = w;
    canvas.height = h;
    _init();
  }

  void _init(){
    ctx = canvas.getContext3d();
    if (ctx == null)
      throw new Exception("Could not create 3d context!");
    program = new GlProgram(ctx);
    ctx.clearColor(0.0, 0.0, 0.0, 1.0);
    // by default backfacing triangles will be culled
    if(!_enableCullFace) ctx.enable(CULL_FACE);
    ctx.enable(DEPTH_TEST);
  }

  void setClearColor(GlColor color){
    ctx.clearColor(color.r,color.g,color.b, color.a);
  }

  void drawModel(GlModelInstance model){
    _assignBufferToColor(model.color);
    _assignBufferToVertex(model.modelBuffer.vertexBuffer);
    _assignBufferToNormals(model.modelBuffer.normalsBuffer);
    ctx.drawArrays(TRIANGLES, 0, model.modelBuffer.numberOfTriangles*3);
  }

  void _assignBufferToVertex(Buffer buffer){
    ctx.enableVertexAttribArray(program.attr_Position);
    ctx.bindBuffer(ARRAY_BUFFER, buffer);
    ctx.vertexAttribPointer(program.attr_Position, 3, FLOAT, false, 0, 0);
  }
  void _assignBufferToNormals(Buffer buffer){
    ctx.enableVertexAttribArray(program.attr_Normal);
    ctx.bindBuffer(ARRAY_BUFFER, buffer);
    ctx.vertexAttribPointer(program.attr_Normal, 3, FLOAT, false, 0, 0);
  }
  void _assignBufferToColor(GlColor color){
    ctx.uniform4fv(program.uni_Color, new Float32List.fromList([color.r,color.g,color.b,color.a]));
  }

  void setWorld(GlMatrix world, GlMatrix worldViewProjection, GlVector lightSource, double lightImpact){
    lightSource = lightSource.normalize();
    ctx.uniform3fv(program.uni_reverseLightDirection, new Float32List.fromList([lightSource.x,lightSource.y,lightSource.z]));
    ctx.uniformMatrix4fv(program.uni_world, false, world.buffer);
    ctx.uniformMatrix4fv(program.uni_worldViewProjection, false, worldViewProjection.buffer);
    ctx.uniform1f(program.uni_lightImpact, lightImpact);
  }
  void clearForNextFrame(){
    ctx.useProgram(program.program);
    ctx.clear(COLOR_BUFFER_BIT | DEPTH_BUFFER_BIT);
  }
}