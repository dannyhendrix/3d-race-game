library object2map.test;
import "package:gameutils/math.dart";
import "package:test/test.dart";
import "dart:math" as Math;

void main()
{
  test("Translate", (){
    Point center = new Point(2.0,4.0);
    Point targetPosition = new Point(12.0,14.0);
    Polygon polygon = new Polygon([
      new Point(0.0,0.0),
      new Point(4.0,0.0),
      new Point(4.0,8.0),
      new Point(0.0,8.0)
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
    Point center = new Point(2.0,4.0);
    Polygon polygon = new Polygon([
      new Point(0.0,0.0),
      new Point(4.0,0.0),
      new Point(4.0,8.0),
      new Point(0.0,8.0)
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
      new Point(0.0,0.0),
      new Point(4.0,0.0),
      new Point(4.0,8.0),
      new Point(0.0,8.0)
    ]);
    Polygon polygonB = new Polygon([
      new Point(0.0,0.0),
      new Point(4.0,0.0),
      new Point(4.0,8.0),
      new Point(0.0,8.0)
    ]);
    CollisionResult res = polygonA.collision(polygonB, new Vector.empty());

  });
}