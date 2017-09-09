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
  List<Point> points;
  List<Vector> edges;
  Point center;
  Polygon(this.points){
    edges = _createEdges();
    center = _createCenter();
  }

  List<Vector> _createEdges(){
    if(points.length <= 1) return [];
    Point p1,p2;
    List<Vector> edges = [];
    for (int i = 0; i < points.length; i++) {
      p1 = points[i];
      p2 = (i + 1 >= points.length) ? points[0] : points[i + 1];
      edges.add(new Vector(p2.x - p1.x, p2.y-p1.y));
    }
    return edges;
  }

  Point _createCenter(){
    double totalX = 0.0;
    double totalY = 0.0;
    int totalP = points.length;
    for (Point p in points) {
      totalX += p.x;
      totalY += p.y;
    }
    return new Point(totalX/totalP, totalY/totalP);
  }

  Polygon rotate(double r, Point origin){
    List<Point> newPoints = [];
    for(Point p in points){
      newPoints.add(p.rotate(r,origin));
    }
    return new Polygon(newPoints);
  }

  Polygon translate(Point position, Point origin){
    List<Point> newPoints = [];
    for(Point p in points){
      newPoints.add(position-(origin - p));
    }
    return new Polygon(newPoints);
  }
  Polygon offset(Vector offset){
    List<Point> newPoints = [];
    for(Point p in points){
      newPoints.add(p-offset);
    }
    return new Polygon(newPoints);
  }

  Polygon rotateAndTranslate(Point position,double r, Point origin){
    List<Point> newPoints = [];
    for(Point p in points){
      Point translated = position-(origin-p);
      newPoints.add(translated.rotate(r,position));
    }
    return new Polygon(newPoints);
  }

  /**Collisions**/
  //https://www.codeproject.com/Articles/15573/2D-Polygon-Collision-Detection
  // Check if polygon A is going to collide with polygon B for the given velocity
  CollisionResult collision(Polygon polygonB, Vector velocity) {
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
      if (_intervalDistance(minMaxA.min, minMaxA.max, minMaxB.min, minMaxB.max) > 0) result.intersect = false;

      // ===== 2. Now find if the polygons *will* intersect =====

      // Project the velocity on the current axis
      double velocityProjection = axis.dotProduct(velocity);

      // Get the projection of polygon A during the movement
      if (velocityProjection < 0) minMaxA.min += velocityProjection;
      else minMaxA.max += velocityProjection;

      // Do the same test as above for the new projection
      double intervalDistance = _intervalDistance(minMaxA.min, minMaxA.max, minMaxB.min, minMaxB.max);
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

        Point d = polygonA.center - polygonB.center;
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
  double _intervalDistance(double minA, double maxA, double minB, double maxB) => (minA < minB) ? minB - maxA : minA - maxB;

  // Calculate the projection of a polygon on an axis and returns it as a [min, max] interval
  MinMax _projectPolygon(Vector axis, Polygon polygon) {
    // To project a point on an axis use the dot product
    double d = axis.dotProduct(polygon.points[0]);
    double min = d;
    double max = d;
    for (Point p in polygon.points){
      d = axis.dotProduct(p);
      if (d < min) min = d;
      else if (d > max) max = d;
    }
    return new MinMax(min,max);
  }
}