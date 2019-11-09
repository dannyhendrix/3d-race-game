part of gameutils.math;

class Aabb {
  static Vector _axisX = new Vector(1, 0);
  static Vector _axisY = new Vector(0, 1);
  double x;
  double y;
  double x2;
  double y2;

  void update(Polygon polygon) {
    //project polygon on x and y
    var polygonPoint = polygon.points[0];
    var distanceX = _axisX.dotProductThis(polygonPoint);
    var distanceY = _axisY.dotProductThis(polygonPoint);
    x2 = distanceX;
    x = distanceX;
    y2 = distanceY;
    y = distanceY;

    for (int i = 1; i < polygon.points.length; i++) {
      polygonPoint = polygon.points[i];
      distanceX = _axisX.dotProductThis(polygonPoint);
      if (distanceX > x2) x2 = distanceX;
      if (distanceX < x) x = distanceX;
      distanceY = _axisY.dotProductThis(polygonPoint);
      if (distanceY > y2) y2 = distanceY;
      if (distanceY < y) y = distanceY;
    }
  }

  bool collidesWith(Aabb other) => !(other.x > x2 || other.x2 < x || other.y > y2 || other.y2 < y);
}

class Edge {
  Vector pointA;
  Vector pointB;
  Edge(this.pointA, this.pointB);
}

class Polygon {
  Vector center;
  Vector dimensions;
  List<Edge> edges;

  List<Vector> points;

  static Polygon createSquare(double nx, double ny, double nw, double nh, double nr){
    double hw = nw/2;
    double hh= nh/2;
    var m = new Matrix2d()
        .translateThis(nx,ny)
        .rotateThis(nr);
    return new Polygon([
      new Vector(-hw,-hh),
      new Vector(hw,-hh),
      new Vector(hw,hh),
      new Vector(-hw,hh),
    ]).applyMatrixToThis(m);
  }

  Polygon(this.points) {
    edges = _createEdges(points.length > 2);
    center = _createCenter();
    dimensions = _createDimensions();
  }

  Polygon clone() => new Polygon(points.map((p) => p.clone()).toList());

  Polygon applyMatrixToThis(Matrix2d m) {
    for (Vector vector in points) vector.applyMatrixToThis(m);
    center.applyMatrixToThis(m);
    return this;
  }

  // Note that closed can only be set to false for lines. Otherwise the polygon is not convex anymore (one of the assumptions for collision detection).
  List<Edge> _createEdges(bool closed) {
    if (points.length <= 1) return [];
    Vector p1;
    Vector p2;
    List<Edge> edges = [];
    p1 = points[0];
    for (var i = 1; i < points.length; i++) {
      p2 = points[i];
      edges.add(new Edge(p1, p2));
      p1 = p2;
    }
    if (closed) {
      p2 = points[0];
      edges.add(new Edge(p1, p2));
    }
    return edges;
  }

  Vector _createCenter() {
    var totalX = 0.0;
    var totalY = 0.0;
    var totalP = points.length;
    for (var p in points) {
      totalX += p.x;
      totalY += p.y;
    }
    return new Vector(totalX / totalP, totalY / totalP);
  }

  Vector _createDimensions() {
    var minx = points[0].x;
    var maxx = minx;
    var miny = points[0].y;
    var maxy = miny;

    for (var p in points) {
      var x = p.x;
      var y = p.y;
      if (x < minx)
        minx = x;
      else if (x > maxx) maxx = x;
      if (y < miny)
        miny = y;
      else if (y > maxy) maxy = y;
    }
    return new Vector(maxx - minx, maxy - miny);
  }
}
