part of game.menu;

class LevelPreview
{
  double windowW = 500.0;
  double windowH = 400.0;

  RenderLayer layer;

  LevelPreview(this.windowW, this.windowH);

  void create(){
    layer = new RenderLayer.withSize(windowW.toInt(),windowH.toInt());
  }

  void draw(GameLevel level, String style){
    layer.clear();

    int borderOffset = 10;
    double minX = 0.0;
    double minZ = 0.0;
    double maxX = 0.0;
    double maxZ = 0.0;
    for(GameLevelCheckPoint c in level.path.checkpoints){
      double xMi = c.x - c.width/2;
      double xMa = c.x + c.width/2;
      double yMi = c.y - c.width/2;
      double yMa = c.y + c.width/2;
      if(minX == null || xMi < minX) minX = xMi;
      if(maxX == null || xMa > maxX) maxX = xMa;
      if(minZ == null || yMi < minZ) minZ = yMi;
      if(maxZ == null || yMa > maxZ) maxZ = yMa;
    }
    double levelW = maxX - minX;
    double levelH = maxZ - minZ;
    double windowAvailableX = windowW - 2*borderOffset;
    double windowAvailableY = windowH - 2*borderOffset;
    double scale = Math.min(windowAvailableX/levelW, windowAvailableY/levelH);

    double centerOffsetX = borderOffset+(windowAvailableX - levelW*scale)/2;
    double centerOffsetY = borderOffset+(windowAvailableY - levelH*scale)/2;

    double offsetX = centerOffsetX - minX*scale;
    double offsetY = centerOffsetY - minZ*scale;

    PathToPolygons pathToPolygons = new PathToPolygons();
    List<Polygon> roadPolygons = pathToPolygons.createRoadPolygons(level.path);

    layer.ctx.strokeStyle = style;
    layer.ctx.fillStyle = style;
    for(Polygon p in roadPolygons){
      _drawRoadPolygon(p, offsetX, offsetY, scale, layer);
    }
  }

  void _drawRoadPolygon(Polygon polygon, double offsetX, double offsetY, double scale,RenderLayer layer){
    layer.ctx.beginPath();
    var first = polygon.points.first;
    layer.ctx.moveTo(first.x*scale+offsetX,first.y*scale+offsetY);
    for(Vector p in polygon.points){
      layer.ctx.lineTo(p.x*scale+offsetX,p.y*scale+offsetY);
    }
    layer.ctx.lineTo(first.x*scale+offsetX,first.y*scale+offsetY);
    layer.ctx.fill();
    layer.ctx.stroke();
  }
}