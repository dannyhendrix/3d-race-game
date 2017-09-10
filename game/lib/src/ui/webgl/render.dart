part of webgl;

class Render{
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;
  double rx = 0.0;
  double ry = 0.0;
  double rz = 0.0;

  List<GlDrawObject> drawobjects = [];

  Render(RenderLayer3d layer){
    RenderingContext ctx = layer.ctx;

    x = 50.0;
    z = -1100.0;
    y = 420.0;
    rx = 1.0;
/*
    square0 = new GlSquare(0.0,0.0,0.0,1.0,1.0, ctx);
    square1 = new GlSquare(3.0,0.0,0.0,1.0,1.0, ctx);
    cube1 = new GlCube(4.0,0.0,0.0, 20.0,4.0,3.0, ctx);
    cube2 = new GlCube(4.0,0.0,10.0, 20.0,4.0,3.0, ctx);
    //cube2.ry = 0.3;
*/

    // Specify the color to clear with (black with 100% alpha) and then enable depth testing.
    ctx.clearColor(0.0, 0.0, 0.0, 1.0);
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
    layer.pMatrix = Matrix4.perspective(45.0, aspect, 0.1, 1200.0);

    layer.mvPushMatrix();
    layer.mvMatrix.translate([x,y,z]);
    layer.mvMatrix.rotateX(rx);
    layer.mvMatrix.rotateY(ry);
    layer.mvMatrix.rotateZ(rz);
    layer.setMatrixUniforms();

    //square0.draw(program.attributes['aVertexPosition'], ctx);
    for(GlDrawObject o in drawobjects)
      o.draw(layer.program.attributes['aVertexPosition'], layer);

    layer.mvPopMatrix();
  }
}