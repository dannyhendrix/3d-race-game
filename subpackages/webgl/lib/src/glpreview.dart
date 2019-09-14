part of webgl;

typedef List<GlModelInstanceCollection> GlPreviewCreateModels(GlModelCollection modelCollection);
class GlPreview
{
  double rx = 0.5,
      ry = 2.6,
      rz = 0.0;
  double ox = 0.0,
      oy = 0.0,
      oz = 400.0;
  double lx = 0.0,
      ly = 0.5,
      lz = -1.0;
  double lightImpact = 0.5;

  double windowW = 500.0;
  double windowH = 400.0;
  bool _enableTextures = false;

  GlRenderLayer layer;
  List<GlModelInstanceCollection> modelInstances = [];
  GlCameraDistanseToTarget camera;
  GlPreviewCreateModels createModels;
  GlColor background = new GlColor(1.0,1.0,1.0);

  GlPreview(this.windowW, this.windowH, this.createModels, [this._enableTextures = false]);

  void create(){
    layer = new GlRenderLayer.withSize(windowW.toInt(),windowH.toInt(), false, _enableTextures);

    // Tell WebGL how to convert from clip space to pixels
    layer.ctx.viewport(0, 0, layer.canvas.width, layer.canvas.height);
    layer.setClearColor(background);

    //3 set view perspective
    camera = new GlCameraDistanseToTarget();
    camera.setPerspective(aspect : windowW / windowH);

    //4 create models
    GlModelCollection modelCollection = new GlModelCollectionBuffer(layer);
    modelInstances = createModels(modelCollection);
  }

  void draw(){
    layer.clearForNextFrame();
    camera.setCameraAngleAndOffset(new GlVector(0.0,0.0,0.0),rx:rx,ry:ry,rz:rz,offsetX:ox,offsetY:oy,offsetZ:oz);
    GlMatrix viewProjectionMatrix = camera.cameraMatrix;
    GlMatrix worldMatrix = GlMatrix.rotationYMatrix(0.0);

    //2 call draw method with buffer
    for(GlModelInstanceCollection m in modelInstances){
      GlMatrix matrix = m.CreateTransformMatrix().multThis(worldMatrix);
      GlMatrix objPerspective = viewProjectionMatrix.clone().multThis(matrix);

      for(GlModelInstance mi in m.modelInstances){
        layer.setWorld(worldMatrix,objPerspective.clone().multThis(mi.CreateTransformMatrix()), new GlVector(lx,ly,lz),lightImpact);
        layer.drawModel(mi);
      }
    }
  }
}