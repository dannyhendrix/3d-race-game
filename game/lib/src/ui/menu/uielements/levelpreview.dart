part of game.menu;

class LevelPreview extends UiRenderLayer
{
  LevelPreview(ILifetime lifetime) : super(lifetime);

  void draw(GameLevel level, String style){
    clear();

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
    double windowAvailableX = actualwidth - 2.0*borderOffset;
    double windowAvailableY = actualheight- 2.0*borderOffset;
    double scale = Math.min(windowAvailableX/levelW, windowAvailableY/levelH);

    double centerOffsetX = borderOffset+(windowAvailableX - levelW*scale)/2;
    double centerOffsetY = borderOffset+(windowAvailableY - levelH*scale)/2;

    double offsetX = centerOffsetX - minX*scale;
    double offsetY = centerOffsetY - minZ*scale;

    var pathToTrack = new PathToTrack();
    var trackToPolygons = new TrackToPolygons();
    var track = pathToTrack.createTrack(level.path);
    var roadPolygons = trackToPolygons.createRoadPolygons(track, level.path.circular);

    ctx.strokeStyle = style;
    ctx.fillStyle = style;
    for(Polygon p in roadPolygons){
      _drawRoadPolygon(p, offsetX, offsetY, scale);
    }
  }

  void _drawRoadPolygon(Polygon polygon, double offsetX, double offsetY, double scale){
    ctx.beginPath();
    var first = polygon.points.first;
    ctx.moveTo(first.x*scale+offsetX,first.y*scale+offsetY);
    for(Vector p in polygon.points){
      ctx.lineTo(p.x*scale+offsetX,p.y*scale+offsetY);
    }
    ctx.lineTo(first.x*scale+offsetX,first.y*scale+offsetY);
    ctx.fill();
    ctx.stroke();
  }
}