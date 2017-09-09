part of webgl;

class RenderLayer3d{
  CanvasElement canvas;
  RenderingContext ctx;
  int w,h;

  RenderLayer3d(this.w, this.h){
    canvas = new CanvasElement();
    canvas.height = w;
    canvas.width = h;
    ctx = canvas.getContext3d();
    if (ctx == null)
      throw new Exception("Could not create 3d context!");
  }
}