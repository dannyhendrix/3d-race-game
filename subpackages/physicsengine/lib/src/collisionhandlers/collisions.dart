part of physicsengine;

class Collisions {
  static List<List<CollisionHandler>> dispatch = [
    [CollisionCircleCircle.instance, CollisionCirclePolygon.instance],
    [CollisionPolygonCircle.instance, CollisionPolygonPolygon.instance]
  ];
}
