part of gameutils.math;

class CollisionResult {
  bool intersect; // Are the polygons currently intersecting
  bool willIntersect; // Are the polygons going to intersect forward in time?
  Vector minimumTranslationVector; // The translation to apply to polygon A to push the polygons appart.
}
class MinMax{
  double min, max;
  MinMax(this.min, this.max);
}

class Polygon{
  List<Point2d> points;
  List<Vector> edges;
  Point2d center;
  // Note that closed can only be set to false for lines. Otherwise the polygon is not convex anymore (one of the assumptions for collision detection).
  Polygon(this.points, [bool closed = true]){
    edges = _createEdges(closed);
    center = _createCenter();
  }

  List<Vector> _createEdges(bool closed){
    if(points.length <= 1) return [];
    Point2d p1,p2;
    List<Vector> edges = [];
    p1 = points[0];
    for(int i = 1; i < points.length; i++){
      p2 = points[i];
      edges.add(new Vector(p2.x - p1.x, p2.y-p1.y));
      p1 = p2;
    }
    if(closed){
      p2 = points[0];
      edges.add(new Vector(p2.x - p1.x, p2.y-p1.y));
    }
    return edges;
  }

  Point2d _createCenter(){
    double totalX = 0.0;
    double totalY = 0.0;
    int totalP = points.length;
    for (Point2d p in points) {
      totalX += p.x;
      totalY += p.y;
    }
    return new Point2d(totalX/totalP, totalY/totalP);
  }

  Polygon applyMatrix(Matrix2d M){
    return new Polygon(points.map((Point2d p) => M.apply(p)).toList());
  }

  //TODO: use matrices here (rather than rotate and translate seperatly)
  Polygon rotate(double r, Point2d origin){
    List<Point2d> newPoints = [];
    for(Point2d p in points){
      newPoints.add(p.rotate(r,origin));
    }
    return new Polygon(newPoints);
  }

  Polygon translate(Point2d position, Point2d origin){
    List<Point2d> newPoints = [];
    for(Point2d p in points){
      newPoints.add(position-(origin - p));
    }
    return new Polygon(newPoints);
  }
  Polygon offset(Vector offset){
    List<Point2d> newPoints = [];
    for(Point2d p in points){
      newPoints.add(p-offset);
    }
    return new Polygon(newPoints);
  }

  Polygon rotateAndTranslate(Point2d position,double r, Point2d origin){
    List<Point2d> newPoints = [];
    for(Point2d p in points){
      Point2d translated = position-(origin-p);
      newPoints.add(translated.rotate(r,position));
    }
    return new Polygon(newPoints);
  }

  /**Collisions**/
  //https://www.codeproject.com/Articles/15573/2D-Polygon-Collision-Detection
  // Check if polygon A is going to collide with polygon B for the given velocity
  bool collision(Polygon polygonB){
    Polygon polygonA = this;

    int edgeCountA = polygonA.edges.length;
    int edgeCountB = polygonB.edges.length;
    Vector edge;

    // Loop through all the edges of both polygons
    for (int edgeIndex = 0; edgeIndex < edgeCountA + edgeCountB; edgeIndex++)
    {
      edge = (edgeIndex < edgeCountA) ? polygonA.edges[edgeIndex] : polygonB.edges[edgeIndex - edgeCountA];

      // ===== 1. Find if the polygons are currently intersecting =====

      // Find the axis perpendicular to the current edge
      Vector axis = new Vector(-edge.y, edge.x).normalized;

      // Find the projection of the polygon on the current axis
      MinMax minMaxA = _projectPolygon(axis, polygonA);
      MinMax minMaxB = _projectPolygon(axis, polygonB);

      // Check if the polygon projections are currentlty intersecting
      if (_intervalDistance(minMaxA, minMaxB) > 0) return false;
    }
    return true;
  }
  CollisionResult collisionWithVector(Polygon polygonB, Vector velocity) {
    Polygon polygonA = this;
    CollisionResult result = new CollisionResult();
    result.intersect = true;
    result.willIntersect = true;

    int edgeCountA = polygonA.edges.length;
    int edgeCountB = polygonB.edges.length;
    double minIntervalDistance = double.MAX_FINITE;
    Vector translationAxis = new Vector.empty();
    Vector edge;

    // Loop through all the edges of both polygons
    for (int edgeIndex = 0; edgeIndex < edgeCountA + edgeCountB; edgeIndex++) {
      edge = (edgeIndex < edgeCountA) ? polygonA.edges[edgeIndex] : polygonB.edges[edgeIndex - edgeCountA];

      // ===== 1. Find if the polygons are currently intersecting =====

      // Find the axis perpendicular to the current edge
      Vector axis = new Vector(-edge.y, edge.x).normalized;

      // Find the projection of the polygon on the current axis
      MinMax minMaxA = _projectPolygon(axis, polygonA);
      MinMax minMaxB = _projectPolygon(axis, polygonB);

      // Check if the polygon projections are currentlty intersecting
      if (_intervalDistance(minMaxA, minMaxB) > 0) result.intersect = false;

      // ===== 2. Now find if the polygons *will* intersect =====

      // Project the velocity on the current axis
      double velocityProjection = axis.dotProduct(velocity);

      // Get the projection of polygon A during the movement
      if (velocityProjection < 0) minMaxA.min += velocityProjection;
      else minMaxA.max += velocityProjection;

      // Do the same test as above for the new projection
      double intervalDistance = _intervalDistance(minMaxA, minMaxB);
      if (intervalDistance > 0) result.willIntersect = false;

      // If the polygons are not intersecting and won't intersect, exit the loop
      if (!result.intersect && !result.willIntersect) break;

      // Check if the current interval distance is the minimum one. If so store
      // the interval distance and the current distance.
      // This will be used to calculate the minimum translation vector
      intervalDistance = intervalDistance.abs();

      if (intervalDistance < minIntervalDistance) {
        minIntervalDistance = intervalDistance;
        translationAxis = axis;

        Point2d d = polygonA.center - polygonB.center;
        if (translationAxis.dotProduct(d) < 0) translationAxis = -translationAxis;
      }

    }

    // The minimum translation vector can be used to push the polygons appart.
    // First moves the polygons by their velocity
    // then move polygonA by MinimumTranslationVector.
    if (result.willIntersect) result.minimumTranslationVector = translationAxis * minIntervalDistance;

    return result;
  }

  // Calculate the distance between [minA, maxA] and [minB, maxB]
  // The distance will be negative if the intervals overlap
  //double _intervalDistance(double minA, double maxA, double minB, double maxB) => (minA < minB) ? minB - maxA : minA - maxB;
  double _intervalDistance(MinMax A, MinMax B) => (A.min < B.min) ? B.min - A.max : A.min - B.max;

  // Calculate the projection of a polygon on an axis and returns it as a [min, max] interval
  MinMax _projectPolygon(Vector axis, Polygon polygon) {
    // To project a point on an axis use the dot product
    double d = axis.dotProduct(polygon.points[0]);
    double min = d;
    double max = d;
    for (Point2d p in polygon.points){
      d = axis.dotProduct(p);
      if (d < min) min = d;
      else if (d > max) max = d;
    }
    return new MinMax(min,max);
  }

  bool pointInPoligon(double x, double y){
    bool inside = false;
    Vector p = new Vector(x,y);
    for ( int i = 0, j = points.length - 1 ; i < points.length ; j = i++ )
    {
      if ( ( points[i].y > p.y ) != ( points[j].y > p.y ) && p.x < ( points[j].x - points[i].x ) * (p.y - points[i].y ) / ( points[j].y - points[i].y ) + points[i].x)
      {
        inside = !inside;
      }
    }
    return inside;
  }
}