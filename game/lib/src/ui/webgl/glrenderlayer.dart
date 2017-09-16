part of webgl;

class GlRenderLayer{
  CanvasElement canvas;
  RenderingContext ctx;
  GlProgram program;
  double x = 0.0, y =0.0, z =0.0;
  double rx = 0.0, ry =0.0, rz =0.0;

  GlRenderLayer.fromCanvas(this.canvas){
    _init();
  }
  GlRenderLayer.withSize(int w, int h){
    canvas = new CanvasElement();
    canvas.height = w;
    canvas.width = h;
    _init();
  }

  void _init(){
    ctx = canvas.getContext3d();
    if (ctx == null)
      throw new Exception("Could not create 3d context!");
    program = new GlProgram(ctx);
    ctx.clearColor(0.0, 0.0, 0.0, 1.0);
    // by default backfacing triangles will be culled
    ctx.enable(CULL_FACE);
    ctx.enable(DEPTH_TEST);
  }

  void drawModel(GlModelBuffer model){
    _assignBufferToColor(model.colorBuffer);
    _assignBufferToVertex(model.vertexBuffer);
    ctx.drawArrays(TRIANGLES, 0, model.numberOfTriangles*3);
  }

  void _assignBufferToVertex(Buffer buffer){
    ctx.enableVertexAttribArray(program.attr_Position);
    ctx.bindBuffer(ARRAY_BUFFER, buffer);
    ctx.vertexAttribPointer(program.attr_Position, 3, FLOAT, false, 0, 0);
  }
  void _assignBufferToColor(Buffer buffer){
    //ctx.enableVertexAttribArray(program.attr_ColorR);
    //ctx.bindBuffer(ARRAY_BUFFER, buffer);
    //ctx.vertexAttribPointer(program.attr_ColorR, 1, FLOAT, false, 0, 0);
    //ctx.enableVertexAttribArray(program.attr_ColorR);
    ctx.vertexAttrib1f(program.attr_ColorR, 1.0);
    //ctx.enableVertexAttribArray(program.attr_ColorG);
    ctx.vertexAttrib1f(program.attr_ColorG, 0.0);
    //ctx.enableVertexAttribArray(program.attr_ColorB);
    ctx.vertexAttrib1f(program.attr_ColorB, 0.0);
    //ctx.enableVertexAttribArray(program.attr_ColorA);
    ctx.vertexAttrib1f(program.attr_ColorA, 1.0);
  }

  void setPerspective(GlMatrix m){
    ctx.uniformMatrix4fv(program.uni_Matrix, false, m.buffer);
  }
  void clearForNextFrame(){
    ctx.useProgram(program.program);
    ctx.clear(COLOR_BUFFER_BIT | DEPTH_BUFFER_BIT);
  }
}