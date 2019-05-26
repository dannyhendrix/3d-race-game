part of game.definitions;

class PathToPolygons
{
  List<Polygon> createRoadPolygons(GameLevelPath path)
  {
    List<Polygon> polygons = [];
    if(path.checkpoints.length <= 1) return polygons;
    List<Vector> points = _pointsFromCheckPoints(path);
    // 1 create square parts of the roads
    List<Polygon> roads = _createSquareRoadPolygons(path, points);
    // 2 create triangle intersections between roads
    polygons.addAll(_createIntersections(points, roads, path.circular));
    // 3 create triangles for square roads
    polygons.addAll(_splitRoadsInTriangles(roads));
    //polygons.addAll((roads));
    return polygons;
  }

  List<Vector> _pointsFromCheckPoints(GameLevelPath path){
    List<Vector> list = [];
    for(GameLevelCheckPoint p in path.checkpoints){
      list.add(_pointFromCheckpoint(p));
    }
    return list;
  }

  Vector _pointFromCheckpoint(GameLevelCheckPoint p){
    return new Vector(p.x, p.z);
  }

  List<Polygon> _createSquareRoadPolygons(GameLevelPath path, List<Vector> points)
  {
    List<Polygon> roads = [];
    for(int i = 1; i < points.length; i++)
    {
      int a = i-1;
      int b = i;
      roads.add(_createSquareRoad(points[a], points[b], path.checkpoints[a].radius, path.checkpoints[b].radius));
    }
    int a = points.length - 1;
    int b = 0;
    if(path.circular) roads.add(_createSquareRoad(points[a], points[b], path.checkpoints[a].radius, path.checkpoints[b].radius));
    return roads;
  }

  Polygon _createSquareRoad(Vector A, Vector B, double radiusA, double radiusB)
  {
    double distance = A.distanceToThis(B);
    Matrix2d M = (new Matrix2d.translationVector(A)).rotate(A.angleWithThis(B));
    return new Polygon([
      M.apply(new Vector(0.0, -radiusA)),
      M.apply(new Vector(distance, -radiusB)),
      M.apply(new Vector(distance, radiusB)),
      M.apply(new Vector(0.0, radiusA)),
    ]);
  }

  List<Polygon> _createIntersections(List<Vector> path, List<Polygon> roads, circular)
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

  Polygon _createIntersection(Vector P, Polygon roadPrev, Polygon roadNext)
  {
    // Take both top lines of the roads. If they intersect, connect the bottom. Otherwise connect the top.
    if(_intersect(roadPrev.points[0], roadPrev.points[1], roadNext.points[0], roadNext.points[1]))
    {
      return new Polygon([
        P,
        roadPrev.points[2],
        roadNext.points[3],
      ]);
    }
    return new Polygon([
      P,
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