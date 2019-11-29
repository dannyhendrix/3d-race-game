part of game.gameitem;

abstract class GameItem {
  static int _idCounter = 0;
  int id = _idCounter++;
  double elasticy = 1.5;
  double r = 0.0;
  bool canCollide = true;
  Polygon _polygon;
  Aabb _aabb = new Aabb();
  Polygon get polygon => _polygon;
  Vector get position => _polygon.center;
  Aabb get aabb => _aabb;
  void setPolygon(Polygon polygon) {
    _polygon = polygon;
    _aabb.update(polygon);
  }

  void applyOffsetRotation(Vector offset, double rotate) {
    var centerX = _polygon.center.x;
    var centerY = _polygon.center.y;
    r += rotate;
    var m = new Matrix2d().translateThisVector(offset).translateThis(centerX, centerY).rotateThis(rotate).translateThis(-centerX, -centerY);
    applyMatrix(m);
  }

  void applyMatrix(Matrix2d matrix) {
    _polygon.applyMatrixToThis(matrix);
    _aabb.update(_polygon);
  }
}

abstract class GameItemStatic extends GameItem {}

abstract class GameItemMovable extends GameItem {
  bool hasCollided = false;
  Vector collisionCorrection = new Vector(0, 0);
  double collisionCorrectionRotation = 0;
  double velocityRotation = 0;
  Vector velocity = new Vector(0, 0);
  double mass = 0.0;
  double rotationalMass = 0.0;
  bool isMoving = false;

  double density = 1;
  double friction = 0.001;

  @override
  void setPolygon(Polygon polygon) {
    super.setPolygon(polygon);
    var width = polygon.dimensions.x;
    var height = polygon.dimensions.y;
    mass = width * width + height * height; //w * h * h / 1000;
    rotationalMass = 4.0 / 3.0 * width * height * (width * width + height * height) * density; //rotational mass, 4/3 * width * height * (width^2 + height^2) * a.density
  }

  void resetCollisions() {
    collisionCorrectionRotation = 0;
    collisionCorrection.reset();
    hasCollided = false;
  }
}

class GameObjectCollisionHandler extends GameObjectHandler {
  void update(GameItemMovable gameobject) {
    var TOLERANCE = 1e-4;
    gameobject.isMoving = gameobject.velocityRotation.abs() >= TOLERANCE || gameobject.velocity.x.abs() >= TOLERANCE || gameobject.velocity.y.abs() >= TOLERANCE;

    if (!gameobject.isMoving && !gameobject.hasCollided) return;

    if (gameobject.hasCollided) {
      gameobject.velocity.addVectorToThis(gameobject.collisionCorrection);
      gameobject.velocityRotation += gameobject.collisionCorrectionRotation;
    } else {
      gameobject.velocity.multiplyToThis(1 - gameobject.friction);
      gameobject.velocityRotation *= (1 - gameobject.friction);
    }
    gameobject.applyOffsetRotation(gameobject.velocity, gameobject.velocityRotation);
    gameobject.resetCollisions();
  }
}

abstract class GameObjectHandler {
  update(GameItemMovable gameobject);
}
