part of webgl;

class Render{
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;

  Buffer colorRedBuffer;
  GlSquare square0 ,square1;
  GlCube cube1, cube2;

  Render(RenderLayer3d layer){
    RenderingContext ctx = layer.ctx;


    square0 = new GlSquare(0.0,0.0,0.0,1.0,1.0, ctx);
    square1 = new GlSquare(3.0,0.0,0.0,1.0,1.0, ctx);
    cube1 = new GlCube(4.0,0.0,0.0, 1.0,2.0,3.0, ctx);
    cube2 = new GlCube(-2.0,0.0,0.0, 1.0,2.0,3.0, ctx);
    cube2.ry = 1.3;


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
    layer.pMatrix = Matrix4.perspective(45.0, aspect, 0.1, 100.0);

    layer.mvPushMatrix();
    layer.mvMatrix.translate([0.0, 0.0, -38.0]);
    layer.mvMatrix.rotateX(x);
    layer.mvMatrix.rotateY(y);
    layer.mvMatrix.rotateZ(z);
    layer.setMatrixUniforms();

    //square0.draw(program.attributes['aVertexPosition'], ctx);
    cube1.draw(layer.program.attributes['aVertexPosition'], layer);
    cube2.draw(layer.program.attributes['aVertexPosition'], layer);

    layer.mvPopMatrix();
  }
}