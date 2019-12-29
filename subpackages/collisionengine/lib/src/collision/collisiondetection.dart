part of game.collision;

class CollisionDetection {
  // Check if polygon A is going to collide with polygon B for the given velocity
  PolygonCollisionResult polygonCollision(Polygon polygonA, Polygon polygonB) {
    var edgeCountA = polygonA.edges.length;
    var edgeCountB = polygonB.edges.length;
    var minIntervalDistance = double.maxFinite;
    Vector translationAxis = null;

    Map<Vector, int> pointOverlapAxisesA = new Map<Vector, int>();
    Map<Vector, int> pointOverlapAxisesB = new Map<Vector, int>();

    //fill overlapaxises
    for (var polygonPoint in polygonA.points) {
      pointOverlapAxisesA[polygonPoint] = 0;
    }
    for (var polygonPoint in polygonB.points) {
      pointOverlapAxisesB[polygonPoint] = 0;
    }
    var numberOfEdgesTested = edgeCountA + edgeCountB;

    // Loop through all the edges of both polygons
    for (var edgeIndex = 0; edgeIndex < edgeCountA + edgeCountB; edgeIndex++) {
      var edge = edgeIndex < edgeCountA ? polygonA.edges[edgeIndex] : polygonB.edges[edgeIndex - edgeCountA];

      var edgeVector = edge.pointB - edge.pointA;

      // Find the axis perpendicular to the current edge
      var axis = new Vector(-edgeVector.y, edgeVector.x);
      axis.normalizeThis();

      // Find the projection of the polygon on the current axis

      var projectionA = new PolygonProjection(axis, polygonA);
      var projectionB = new PolygonProjection(axis, polygonB);

      var ainb = projectionA.overlap(projectionB);
      var bina = projectionB.overlap(projectionA);

      var intervalDistance = projectionA.intervalDistance(projectionB);

      if (intervalDistance > 0) return null;

      intervalDistance = intervalDistance.abs();
      if (intervalDistance < minIntervalDistance) {
        minIntervalDistance = intervalDistance;
        translationAxis = axis;

        var d = polygonA.center - polygonB.center;
        if (d.dotProductThis(translationAxis) < 0) translationAxis = -translationAxis;
      }
      // count all overlapping
      for (var pointOnAxise in ainb) {
        pointOverlapAxisesA[pointOnAxise]++;
      }
      for (var pointOnAxise in bina) {
        pointOverlapAxisesB[pointOnAxise]++;
      }
    }

    var fromPolygonBInPolygonA = _selectPointsInAllEdges(pointOverlapAxisesB, numberOfEdgesTested);
    var fromPolygonAInPolygonB = _selectPointsInAllEdges(pointOverlapAxisesA, numberOfEdgesTested);

    var hitLocation = _getHitLocation(fromPolygonBInPolygonA, fromPolygonAInPolygonB);
    if (hitLocation == null) hitLocation = _middle(polygonA.center, polygonB.center);

    return new PolygonCollisionResult(translationAxis, minIntervalDistance, hitLocation);
  }

  List<Vector> _selectPointsInAllEdges(Map<Vector, int> pointOverlapAxises, int numberOfEdgesTested) {
    List<Vector> points = [];
    for (var key in pointOverlapAxises.keys) {
      if (pointOverlapAxises[key] == numberOfEdgesTested) points.add(key);
    }
    return points;
  }

  Vector _getHitLocation(List<Vector> pointsFromBinA, List<Vector> pointsFromAinB) {
    var numberOfBinA = pointsFromBinA.length;
    var numberOfAinB = pointsFromAinB.length;

    if (numberOfBinA == numberOfAinB) {
      if (numberOfBinA == 0) return null;
      if (numberOfBinA == 1) return _middle(pointsFromBinA[0], pointsFromAinB[0]);
      var averageA = _middle(pointsFromBinA[0], pointsFromBinA[1]);
      var averageB = _middle(pointsFromAinB[0], pointsFromAinB[1]);
      return _middle(averageA, averageB);
    }
    if (numberOfBinA == 2) return _middle(pointsFromBinA[0], pointsFromBinA[1]);
    if (numberOfAinB == 2) return _middle(pointsFromAinB[0], pointsFromAinB[1]);
    if (numberOfBinA == 1) return pointsFromBinA[0];
    if (numberOfAinB == 1) return pointsFromAinB[0];
    return null;
  }

  Vector _middle(Vector A, Vector B) {
    return new Vector((A.x + B.x) / 2, (A.y + B.y) / 2);
  }
}

class PolygonProjection {
  Polygon _polygon;
  double maxDistance;
  double minDistance;
  List<double> distances = new List<double>();
  PolygonProjection(Vector axis, this._polygon) {
    var polygonPoint = _polygon.points[0];
    var distance = axis.dotProductThis(polygonPoint);
    distances.add(distance);
    maxDistance = distance;
    minDistance = distance;

    for (int i = 1; i < _polygon.points.length; i++) {
      polygonPoint = _polygon.points[i];
      distance = axis.dotProductThis(polygonPoint);
      distances.add(distance);
      if (distance > maxDistance) maxDistance = distance;
      if (distance < minDistance) minDistance = distance;
    }
  }
  double intervalDistance(PolygonProjection other) {
    if (minDistance < other.minDistance) return other.minDistance - maxDistance;
    return minDistance - other.maxDistance;
  }

  bool overlaps(PolygonProjection other) {
    return intervalDistance(other) > 0;
  }

  List<Vector> overlap(PolygonProjection other) {
    var minA = other.minDistance;
    var maxA = other.maxDistance;
    List<Vector> result = new List<Vector>();
    for (int i = 0; i < distances.length; i++) {
      if (distances[i] >= minA && distances[i] <= maxA) result.add(_polygon.points[i]);
    }
    return result;
  }
}

class PolygonCollisionResult {
  Vector hitLocation;
  Vector translationVector;
  double translationForce;
  PolygonCollisionResult(this.translationVector, this.translationForce, this.hitLocation);
}
