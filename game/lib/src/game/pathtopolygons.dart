part of micromachines;

class PathToPolygons
{
  List<Polygon> createRoadPolygons(List<Point> path, double roadWidth, bool pathLoop)
  {
    List<Polygon> polygons = [];
    // 1 create square parts of the roads
    List<Polygon> roads = _createSquareRoadPolygons(path, roadWidth, pathLoop);
    // 2 create triangle intersections between roads
    polygons.addAll(_createIntersections(path, roads, pathLoop));
    // 3 create triangles for square roads
    polygons.addAll(_splitRoadsInTriangles(roads));
    //polygons.addAll((roads));
    return polygons;
  }

  List<Polygon> _createSquareRoadPolygons(List<Point> path, double roadWidth, bool pathLoop)
  {
    List<Polygon> roads = [];
    for(int i = 1; i < path.length; i++)
    {
      roads.add(_createSquareRoad(path[i-1], path[i], roadWidth));
    }
    if(pathLoop) roads.add(_createSquareRoad(path.last, path.first, roadWidth));
    return roads;
  }

  Polygon _createSquareRoad(Point A, Point B, double roadWidth)
  {
    double distance = A.distanceTo(B);
    Matrix2d M = (new Matrix2d.translationPoint(A)).rotate(A.angleWith(B));
    return new Polygon([
      M.apply(new Point(0.0, -roadWidth)),
      M.apply(new Point(distance, -roadWidth)),
      M.apply(new Point(distance, roadWidth)),
      M.apply(new Point(0.0, roadWidth)),
    ]);
  }

  List<Polygon> _createIntersections(List<Point> path, List<Polygon> roads, bool pathLoop)
  {
    List<Polygon> intersections = [];
    for(int i = 1; i < path.length - 1; i++)
    {
      intersections.add(_createIntersection(path[i], roads[i - 1], roads[i]));
    }
    if(pathLoop)
    {
      intersections.add(_createIntersection(path.first, roads.last, roads.first));
      intersections.add(_createIntersection(path.last, roads[roads.length - 2], roads.last));
    }
    return intersections;
  }

  Polygon _createIntersection(Point P, Polygon roadPrev, Polygon roadNext)
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
      roadPrev.points[1],
      roadNext.points[0],
    ]);
  }

  List<Polygon> _splitRoadsInTriangles(List<Polygon> roads)
  {
    List<Polygon> polygons = [];
    for(Polygon P in roads)
    {
      polygons.add(new Polygon([
        P.points[0],
        P.points[1],
        P.points[2],
      ]));
      polygons.add(new Polygon([
        P.points[2],
        P.points[3],
        P.points[0],
      ]));
    }
    return polygons;
  }

  bool _intersect(Point A, Point B, Point C, Point D)
  {
    return _ccw(A, C, D) != _ccw(B, C, D) && _ccw(A, B, C) != _ccw(A, B, D);
  }

  bool _ccw(Point A, Point B, Point C)
  {
    return (C.y - A.y) * (B.x - A.x) > (B.y - A.y) * (C.x - A.x);
  }
}