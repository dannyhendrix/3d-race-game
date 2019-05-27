part of game.leveleditor;

class Preview{
  double mouseX = 0.0;
  double mouseY = 0.0;
  double scale = 0.5;
  CanvasElement canvas;
  CanvasRenderingContext2D ctx;

  Element createElement(){
    canvas = new CanvasElement();
    ctx = canvas.context2D;
    return canvas;
  }

  void _setWidthHeight(GameLevelPath path){
    double maxX = 0.0;
    double maxZ = 0.0;
    for(var c in path.checkpoints){
      var mx = c.x + c.radius/2;
      var mz = c.y + c.radius/2;
      if(mx > maxX) maxX = mx;
      if(mz > maxZ) maxZ = mz;
    }
    canvas.width = (maxX*scale).ceil() + 100;
    canvas.height = (maxZ*scale).ceil() + 100;
  }

  void paintLevel(GameLevel level){
    scale = 0.5;
    _setWidthHeight(level.path);

    //draw road
    _drawRoad(level.path, scale);
    //draw path
    _drawPath(level.path, scale);
/*
    //draw walls
    ctx.fillStyle = "#222";
    for(GameLevelWall o in level.walls){
      _drawSquare(o.x,o.z,o.w,o.d,o.r,scale);
    }

    // draw trees
    ctx.fillStyle = "#282";
    for(GameLevelStaticObject o in level.staticobjects){
      _drawSquare(o.x,o.z,50.0,50.0,o.r,scale);
    }
*/
  }
  void _drawStartingPositions(){
  }
  void _drawRoad(GameLevelPath path, double scale){
    PathToPolygons pathToPolygons = new PathToPolygons();
    var roadPolygons = pathToPolygons.createRoadPolygons(path);

    ctx.fillStyle = "#999";
    ctx.strokeStyle = "#999";
    for(Polygon p in roadPolygons){
      _drawRoadPolygon(p, scale);
    }
  }
  void _drawPath(GameLevelPath path, double scale){
    var angles = new GameLevelExtensions().getCheckpointAngles(path);
    if(path.checkpoints.length > 0)
    {
      // 1 line path
      var startPoint = path.checkpoints[0];
      ctx.beginPath();
      ctx.moveTo(startPoint.x*scale, startPoint.y*scale);
      for (int i = 1; i < path.checkpoints.length; i++)
      {
        var p = path.checkpoints[i];
        ctx.lineTo(p.x*scale, p.y*scale);
      }
      if (path.circular)
      {
        ctx.lineTo(startPoint.x*scale, startPoint.y*scale);
      }
      ctx.strokeStyle = '#555';
      ctx.stroke();

      // 2 circles and angleline
      for (int i = 0; i < path.checkpoints.length; i++)
      {
        var p = path.checkpoints[i];
        ctx.beginPath();
        ctx.arc(p.x*scale, p.y*scale, p.radius*scale, 0, 2 * Math.pi, false);
        ctx.stroke();

        ctx.save();
        ctx.translate(p.x*scale, p.y*scale);
        ctx.rotate(angles[i]);
        ctx.beginPath();
        ctx.moveTo(-p.radius*scale,0);
        ctx.lineTo(p.radius*scale,0);
        ctx.stroke();
        ctx.closePath();

        ctx.restore();
      }
      var vehicleW = GameConstants.carSize.x;
      var vehicleH = GameConstants.carSize.y;
      var startingPositions = new StartingPositions();
      var positions = startingPositions.DetermineStartPositions2(path.checkpoints[0], angles[0], 8, vehicleW, vehicleH, GameConstants.startingPositionSpacing.x, GameConstants.startingPositionSpacing.y);
      var startingPositionsPreview = new StartingPositionsPreview();
      startingPositionsPreview.paintPositions(ctx, positions, vehicleW, vehicleH, scale);
    }
  }
  void _drawSquare(double x, double z, double w, double d, double r, double scale){
    ctx.save();
    ctx.translate(x*scale,z*scale);
    ctx.rotate(r);
    ctx.fillRect(-w*scale/2, -d*scale/2, w*scale, d*scale);
    ctx.restore();
  }
  void _drawRoadPolygon(Polygon polygon, double scale){
    ctx.beginPath();
    var first = polygon.points.first;
    ctx.moveTo(first.x*scale,first.y*scale);
    for(Vector p in polygon.points){
      ctx.lineTo(p.x*scale,p.y*scale);
    }
    ctx.lineTo(first.x*scale,first.y*scale);
    ctx.fill();
    ctx.stroke();
  }
}