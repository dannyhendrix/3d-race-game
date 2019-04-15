library object2map.test;
import "package:gameutils/math.dart";
import "package:test/test.dart";
import "dart:math" as Math;
/*
void main()
{
  test("Edges", (){
    Polygon polygon = new Polygon([
      new Point2d(0.0,0.0),
      new Point2d(4.0,0.0),
      new Point2d(4.0,8.0),
      new Point2d(0.0,8.0)
    ], false);
    var center = polygon.center;
    expect(center.x, equals(2.0));
    expect(center.y, equals(4.0));
    var edges = polygon.edges;
    expect(edges.length, equals(3));
    expect(edges[0].x, equals(4.0));
    expect(edges[0].y, equals(0.0));
    expect(edges[1].x, equals(0.0));
    expect(edges[1].y, equals(8.0));
    expect(edges[2].x, equals(-4.0));
    expect(edges[2].y, equals(0.0));
  });
  test("EdgesClosed", (){
    Polygon polygon = new Polygon([
      new Point2d(0.0,0.0),
      new Point2d(4.0,0.0),
      new Point2d(4.0,8.0),
      new Point2d(0.0,8.0)
    ], true);
    var center = polygon.center;
    expect(center.x, equals(2.0));
    expect(center.y, equals(4.0));
    var edges = polygon.edges;
    expect(edges.length, equals(4));
    expect(edges[0].x, equals(4.0));
    expect(edges[0].y, equals(0.0));
    expect(edges[1].x, equals(0.0));
    expect(edges[1].y, equals(8.0));
    expect(edges[2].x, equals(-4.0));
    expect(edges[2].y, equals(0.0));
    expect(edges[3].x, equals(0.0));
    expect(edges[3].y, equals(-8.0));
  });
  test("Translate", (){
    Point2d center = new Point2d(2.0,4.0);
    Point2d targetPosition = new Point2d(12.0,14.0);
    Polygon polygon = new Polygon([
      new Point2d(0.0,0.0),
      new Point2d(4.0,0.0),
      new Point2d(4.0,8.0),
      new Point2d(0.0,8.0)
    ]);
    Polygon translated = polygon.translate(targetPosition,center);
    expect(translated.points.length, equals(4));
    expect(translated.points[0].x, equals(10.0));
    expect(translated.points[0].y, equals(10.0));
    expect(translated.points[1].x, equals(14.0));
    expect(translated.points[1].y, equals(10.0));
    expect(translated.points[2].x, equals(14.0));
    expect(translated.points[2].y, equals(18.0));
    expect(translated.points[3].x, equals(10.0));
    expect(translated.points[3].y, equals(18.0));
  });/*
  test("Rotate", (){
    Point2d center = new Point2d(2.0,4.0);
    Polygon polygon = new Polygon([
      new Point2d(0.0,0.0),
      new Point2d(4.0,0.0),
      new Point2d(4.0,8.0),
      new Point2d(0.0,8.0)
    ]);
    Polygon translated = polygon.rotate(Math.PI/2,center);
    expect(translated.points.length, equals(4));
    expect(translated.points[0].x, equals(6.0));
    expect(translated.points[0].y, equals(2.0));
    expect(translated.points[1].x, equals(6.0));
    expect(translated.points[1].y, equals(6.0));
    expect(translated.points[2].x, equals(-2.0));
    expect(translated.points[2].y, equals(6.0));
    expect(translated.points[3].x, equals(-2.0));
    expect(translated.points[3].y, equals(2.0));
  });*/
  test("Collision", (){
    Polygon polygonA = new Polygon([
      new Point2d(0.0,0.0),
      new Point2d(4.0,0.0),
      new Point2d(4.0,8.0),
      new Point2d(0.0,8.0)
    ]);
    Polygon polygonB = new Polygon([
      new Point2d(0.0,0.0),
      new Point2d(4.0,0.0),
      new Point2d(4.0,8.0),
      new Point2d(0.0,8.0)
    ]);
    CollisionResult res = polygonA.collisionWithVector(polygonB, new Vector.empty());

  });
  test("CollisionLine", (){
    Polygon polygonA = new Polygon([
      new Point2d(0.0,2.0),
      new Point2d(4.0,2.0)
    ]);
    Polygon polygonB = new Polygon([
      new Point2d(2.0,0.0),
      new Point2d(2.0,4.0)
    ]);
    Polygon polygonC = new Polygon([
      new Point2d(-1.0,0.0),
      new Point2d(-1.0,4.0)
    ]);
    CollisionResult res = polygonA.collisionWithVector(polygonB, new Vector.empty());
    expect(res.intersect, equals(true));
    expect(res.willIntersect, equals(true));
    res = polygonA.collisionWithVector(polygonC, new Vector(2.0,0.0));
    expect(res.intersect, equals(false));
    //expect(res.willIntersect, equals(true));
  });
}*/