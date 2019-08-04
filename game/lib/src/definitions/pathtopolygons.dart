part of game.definitions;

class PathPoint{
  Vector vector;
  double angle;
  double width;
  PathPoint(this.vector, this.angle, this.width);
}

class PathToTrack{

  List<PathPoint> createTrack(GameLevelPath path)
  {
    if(path.checkpoints.length <= 1) return [];

    var roads = _createRoadsFromCheckpoints(path.checkpoints);
    roads = _cutCollidingRoads(roads, path.circular);
    _fixAngles(roads, path.circular);

    return roads;
  }

  // for each checkpoint, add a vector before and after the checkpoint to create a road in the given angle
  List<PathPoint> _createRoadsFromCheckpoints(List<GameLevelCheckPoint> checkpoints){
    List<PathPoint> data = [];
    for(var checkpoint in checkpoints){
      var angle = checkpoint.angle;
      var actual = new Vector(checkpoint.x, checkpoint.y);
      var newPointBefore = actual.clone().addVectorToThis(new Vector.fromAngleRadians(angle+Math.pi, checkpoint.lengthBefore));
      var newPointAfter = actual.clone().addVectorToThis(new Vector.fromAngleRadians(angle, checkpoint.lengthAfter));

      data.add(new PathPoint(newPointBefore, angle, checkpoint.width));
      data.add(new PathPoint(actual, angle, checkpoint.width));
      data.add(new PathPoint(newPointAfter, angle, checkpoint.width));
    }
    return data;
  }
  // if 2 roads from 2 checkpoints intersect, cut them and use the intersection point instead
  List<PathPoint> _cutCollidingRoads(List<PathPoint> path, bool circular){
    List<PathPoint> data= [];
    for(int i = 1; i < path.length-2; i+=3){
      _cutCollidingRoad(path[i], path[i+1], path[i+2], path[i+3], data);
    }
    if(circular)
      _cutCollidingRoad(path[path.length-2], path[path.length-1], path[0], path[1], data);
    return data;
  }
  void _cutCollidingRoad(PathPoint pa, PathPoint pb, PathPoint pc, PathPoint pd, List<PathPoint> output){
    var a = pa.vector;
    var b = pb.vector;
    var c = pc.vector;
    var d = pd.vector;
    Vector intersect = Vector.intersection(a, b,c,d);
    var lengthAB = a.distanceToThis(b);
    var lengthCD = c.distanceToThis(d);
    var lengthAE = a.distanceToThis(intersect);
    var lengthDE = d.distanceToThis(intersect);

    if(lengthAE < lengthAB || lengthDE < lengthCD){
      output.add(new PathPoint(intersect,(pb.angle+pc.angle)/2,(pb.width+pc.width)/2));
    }else{
      output.add(pb);
      output.add(pc);
    }
  }
  void _fixAngles(List<PathPoint> path, bool circular){
    for(int i = 1; i < path.length-1; i++){
      path[i].angle = (path[i-1].vector.angleWithThis(path[i+1].vector)) - Math.pi/2;
    }
    if(circular){
      path[0].angle = (path[path.length-1].vector.angleWithThis(path[1].vector)) - Math.pi/2;
      path[path.length-1].angle = (path[path.length-2].vector.angleWithThis(path[0].vector)) - Math.pi/2;
    }else{
      path[0].angle = (path[0].vector.angleWithThis(path[1].vector)) - Math.pi/2;
      path[path.length-1].angle = (path[path.length-1].vector.angleWithThis(path[0].vector)) - Math.pi/2;
    }
  }
}

class TrackToPolygons
{
  List<Polygon> createRoadPolygons(List<PathPoint> roads, bool circular)
  {
    List<Polygon> polygons = [];
    if(roads.length <= 1) return polygons;

    // 1 create square parts of the roads
    List<Polygon> roadPolygons = _createSquareRoadPolygons(roads, circular);
    // 2 create triangle intersections between roads
    polygons.addAll(_createIntersections(roads, roadPolygons, circular));
    // 3 create triangles for square roads
    polygons.addAll(_splitRoadsInTriangles(roadPolygons));
    //polygons.addAll((roads));

    return polygons;
  }

  List<Polygon> _createSquareRoadPolygons(List<PathPoint> path, bool circular)
  {
    List<Polygon> roads = [];
    for(int i = 1; i < path.length; i++)
    {
      int a = i-1;
      int b = i;
      roads.add(_createSquareRoad(path[a], path[b]));
    }
    int a = path.length - 1;
    int b = 0;
    if(circular) roads.add(_createSquareRoad(path[a], path[b]));
    return roads;
  }

  Polygon _createSquareRoad(PathPoint A, PathPoint B)
  {
    double distance = A.vector.distanceToThis(B.vector);
    Matrix2d M = (new Matrix2d.translationVector(A.vector)).rotate(A.vector.angleWithThis(B.vector));
    return new Polygon([
      M.apply(new Vector(0.0, -A.width/2)),
      M.apply(new Vector(distance, -B.width/2)),
      M.apply(new Vector(distance, B.width/2)),
      M.apply(new Vector(0.0, A.width/2)),
    ]);
  }

  List<Polygon> _createIntersections(List<PathPoint> path, List<Polygon> roads, circular)
  {
    List<Polygon> intersections = [];
    for(int i = 1; i < path.length - 1; i++)
    {
      intersections.add(_createIntersection(path[i], roads[i - 1], roads[i]));
    }
    if(circular)
    {
      intersections.add(_createIntersection(path.first, roads.last, roads.first));
      intersections.add(_createIntersection(path.last, roads[roads.length - 2], roads.last));
    }
    return intersections;
  }

  Polygon _createIntersection(PathPoint P, Polygon roadPrev, Polygon roadNext)
  {
    // Take both top lines of the roads. If they intersect, connect the bottom. Otherwise connect the top.
    if(_intersect(roadPrev.points[0], roadPrev.points[1], roadNext.points[0], roadNext.points[1]))
    {
      return new Polygon([
        P.vector,
        roadPrev.points[2],
        roadNext.points[3],
      ]);
    }
    return new Polygon([
      P.vector,
      roadNext.points[0],
      roadPrev.points[1],
    ]);
  }

  List<Polygon> _splitRoadsInTriangles(List<Polygon> roads)
  {
    List<Polygon> polygons = [];
    for(Polygon P in roads)
    {
      polygons.add(new Polygon([
        P.points[0],
        P.points[2],
        P.points[1],
      ]));
      polygons.add(new Polygon([
        P.points[2],
        P.points[0],
        P.points[3],
      ]));
    }
    return polygons;
  }

  bool _intersect(Vector A, Vector B, Vector C, Vector D)
  {
    return _ccw(A, C, D) != _ccw(B, C, D) && _ccw(A, B, C) != _ccw(A, B, D);
  }

  bool _ccw(Vector A, Vector B, Vector C)
  {
    return (C.y - A.y) * (B.x - A.x) > (B.y - A.y) * (C.x - A.x);
  }
}