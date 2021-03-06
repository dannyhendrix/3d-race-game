part of game.definitions;

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