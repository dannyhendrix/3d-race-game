library dependencyinjection.test;

import 'package:gamelogic/collision.dart';
import 'package:gamelogic/gameitem.dart';
import 'package:gameutils/math.dart';
import "package:test/test.dart";
import "dart:math";

abstract class Base {}

class TestObj extends GameItem {
  TestObj(double x, double y, double r) {
    setPolygon(Polygon.createSquare(0, 0, 10, 10, 0));
    applyOffsetRotation(new Vector(x, y), r);
  }
}

void main() {
  test("headonX", () {
    var a = new TestObj(0, 0, 0);
    var b = new TestObj(5, 0, 0);
    var detection = new CollisionDetection();
    var result = detection.polygonCollision(a.polygon, b.polygon);
    expect(result.isHit, equals(true));
    expect(result.hitLocation.x, equals(2.5));
    expect(result.hitLocation.y, equals(0.0));
  });
  test("headonY", () {
    var a = new TestObj(0, 0, 0);
    var b = new TestObj(0, 5, 0);
    var detection = new CollisionDetection();
    var result = detection.polygonCollision(a.polygon, b.polygon);
    expect(result.isHit, equals(true));
    expect(result.hitLocation.x, equals(0.0));
    expect(result.hitLocation.y, equals(2.5));
  });
  test("headonXY", () {
    var a = new TestObj(0, 0, 0);
    var b = new TestObj(5, 5, 0);
    var detection = new CollisionDetection();
    var result = detection.polygonCollision(a.polygon, b.polygon);
    expect(result.isHit, equals(true));
    expect(result.hitLocation.x, equals(2.5));
    expect(result.hitLocation.y, equals(2.5));
  });
  test("headonRX", () {
    var a = new TestObj(0, 0, 0);
    var b = new TestObj(5, 0, pi / 4);
    var detection = new CollisionDetection();
    var result = detection.polygonCollision(a.polygon, b.polygon);
    expect(result.isHit, equals(true));
    expect(result.hitLocation.x, equals(5));
    expect(result.hitLocation.y, equals(0));
  });
  test("headonRY", () {
    var a = new TestObj(0, 0, 0);
    var b = new TestObj(0, 5, pi / 4);
    var detection = new CollisionDetection();
    var result = detection.polygonCollision(a.polygon, b.polygon);
    expect(result.isHit, equals(true));
    expect(result.hitLocation.x, equals(0));
    expect(result.hitLocation.y, equals(5));
  });
  test("headonRXY", () {
    var a = new TestObj(0, 0, 0);
    var b = new TestObj(5, 5, pi / 4);
    var detection = new CollisionDetection();
    var result = detection.polygonCollision(a.polygon, b.polygon);
    expect(result.isHit, equals(true));
    expect(result.hitLocation.x, equals(1.4644660940672622));
    expect(result.hitLocation.y, equals(1.4644660940672622));
  });
}
