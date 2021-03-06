part of uihelper;

/**
Makes it easier to work with canvases, you can always access the canvas and ctx resource
**/
class UiRenderLayer extends UiElement {
  static bool DEFAULT_FIX_SCALE_RATIO = false;
  static double IMAGE_SCALE = 1.0;
  CanvasElement canvas;
  CanvasRenderingContext2D ctx;
  bool scaleratiofixed = false;
  int actualwidth = 0;
  int actualheight = 0;
  double ratio = 1.0;

  UiRenderLayer(ILifetime lifetime) :super(lifetime) {
    canvas = new Element.tag("canvas");
    element = canvas;
  }

  @override
  void build(){
    super.build();
    ctx = canvas.getContext("2d");
  }

  void setSize(int width, int height) {
    canvas.height = actualheight = height;
    canvas.width = actualwidth = width;
    if (scaleratiofixed) fixScalingRatio();
  }

  void clear() {
    ctx.clearRect(0, 0, actualwidth, actualheight);
  }

  /*
  Note: use these instead of layer.ctx.drawImage due to fixratio
  */
  void drawLayer(UiRenderLayer layer, num destX, num destY) {
    if (layer.scaleratiofixed)
      ctx.drawImageScaledFromSource(layer.canvas, 0, 0, layer.canvas.width, layer.canvas.height, destX, destY, layer.actualwidth, layer.actualheight);
    else
      ctx.drawImage(layer.canvas, destX, destY);
  }

  void drawLayerPart(UiRenderLayer layer, num destX, num destY, num sourceX, num sourceY, num sourceW, num sourceH) {
    if (layer.scaleratiofixed)
      ctx.drawImageScaledFromSource(layer.canvas, sourceX, sourceY, (sourceW * ratio).toInt(), (sourceH * ratio).toInt(), destX, destY, sourceW, sourceH);
    else
      ctx.drawImageScaledFromSource(layer.canvas, sourceX, sourceY, sourceW, sourceH, destX, destY, sourceW, sourceH);
  }

  void drawImage(ImageElement el, num destX, num destY) {
    if (IMAGE_SCALE != 1.0)
      ctx.drawImageScaledFromSource(el, 0, 0, el.width * IMAGE_SCALE, el.height * IMAGE_SCALE, destX, destY, el.width, el.height);
    else
      ctx.drawImage(el, destX, destY);
  }

  void drawImagePart(ImageElement el, num destX, num destY, num sourceX, num sourceY, num sourceW, num sourceH) {
    if (IMAGE_SCALE != 1.0)
      ctx.drawImageScaledFromSource(el, sourceX, sourceY, (sourceW * IMAGE_SCALE).toInt(), (sourceH * IMAGE_SCALE).toInt(), destX, destY, sourceW, sourceH);
    else
      ctx.drawImageScaledFromSource(el, sourceX, sourceY, sourceW, sourceH, destX, destY, sourceW, sourceH);
  }

  void fixScalingRatio() {
    //fix scale
    double devicePixelRatio = window.devicePixelRatio;
    double backingStoreRatio = ctx.backingStorePixelRatio;

    //TODO:turn this if on again
    //if (devicePixelRatio != backingStoreRatio) {

    ratio = devicePixelRatio / backingStoreRatio;

    //actualwidth = canvas.width;
    //actualheight = canvas.height;

    canvas.width = (actualwidth * ratio).toInt();
    canvas.height = (actualheight * ratio).toInt();

    ctx.imageSmoothingEnabled = false;

    canvas.style.width = "${actualwidth}px";
    canvas.style.height = "${actualheight}px";

    // now scale the context to counter
    // the fact that we've manually scaled
    // our canvas element
    ctx.scale(ratio, ratio);
    scaleratiofixed = true;
    //}
  }
}
