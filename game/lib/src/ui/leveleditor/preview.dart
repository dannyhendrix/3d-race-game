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

  void _setWidthHeight(List<Polygon> polygons){
    double maxX = 0.0;
    double maxZ = 0.0;
    for(var c in polygons){
    for(var p in c.points)
    {
    var mx = p.x;
      var mz = p.y;
      if(mx > maxX) maxX = mx;
      if(mz > maxZ) maxZ = mz;
    }
    }
    canvas.width = (maxX*scale).ceil() + 100;
    canvas.height = (maxZ*scale).ceil() + 100;
  }

  void paintLevel(GameLevel level){
    scale = 0.5;

    //draw road
    _drawRoad(level.path, scale);
    //draw path
    _drawCheckPoints(level.path.checkpoints, scale);
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
  void _drawRoad(GameLevelPath path, double scale){
    PathToTrack pathToTrack = new PathToTrack();
    TrackToPolygons trackToPolygons = new TrackToPolygons();
    var track = pathToTrack.createTrack(path);
    var roadPolygons = trackToPolygons.createRoadPolygons(track, path.circular);


    _setWidthHeight(roadPolygons);
    ctx.fillStyle = "#999";
    ctx.strokeStyle = "#999";
    for(Polygon p in roadPolygons){
      _drawRoadPolygon(p, scale);
    }

    _drawPath(track, path.circular, scale);
  }
  void _drawPath(List<PathPoint> path, bool circular, double scale){
    //var angles = new GameLevelExtensions().getCheckpointAngles(path);
    if(path.length > 0)
    {
      // 1 line path
      var startPoint = path[0];
      ctx.beginPath();
      ctx.moveTo(startPoint.vector.x*scale, startPoint.vector.y*scale);
      for (int i = 1; i < path.length; i++)
      {
        var p = path[i];
        ctx.lineTo(p.vector.x*scale, p.vector.y*scale);
      }
      if (circular)
      {
        ctx.lineTo(startPoint.vector.x*scale, startPoint.vector.y*scale);
      }
      ctx.strokeStyle = '#555';
      ctx.stroke();
    }
  }

  void _drawCheckPoints(List<GameLevelCheckPoint> path, double scale){
    //var angles = new GameLevelExtensions().getCheckpointAngles(path);
    if(path.length > 0)
    {
      // 2 circles and angleline
      for (int i = 0; i < path.length; i++)
      {
        var p = path[i];
        ctx.beginPath();
        ctx.arc(p.x*scale, p.y*scale, p.width*scale, 0, 2 * Math.pi, false);
        ctx.stroke();

        ctx.save();
        ctx.translate(p.x*scale, p.y*scale);
        ctx.rotate(p.angle);
        ctx.beginPath();
        ctx.moveTo(-p.width*scale,0);
        ctx.lineTo(p.width*scale,0);
        ctx.stroke();
        ctx.closePath();

        ctx.restore();
      }

      // 3 starting positions
      var vehicleW = GameConstants.carSize.x;
      var vehicleH = GameConstants.carSize.y;
      var startingPositions = new StartingPositions();
      var positions = startingPositions.determineStartPositions(
          path[0].x,
          path[0].y,
          path[0].angle,
          path[0].width,
          vehicleW, vehicleH, 8);
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