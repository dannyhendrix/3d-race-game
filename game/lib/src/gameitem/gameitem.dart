part of game.gameitem;

class GameItemStatic extends GameItem {
  GameItemStatic(Polygon polygon) : super(polygon);
}

class GameItemMovable extends GameItem {
  bool hasCollided = false;
  Vector collisionCorrection = new Vector(0, 0);
  double collisionCorrectionRotation = 0;
  double velocityRotation = 0;
  Vector velocity = new Vector(0, 0);
  double mass = 0.0;
  double rotationalMass = 0.0;
  bool isMoving = false;

  double _density = 1;
  double _friction = 0.001;

  void update() {
    var TOLERANCE = 1e-4;
    isMoving = velocityRotation.abs() >= TOLERANCE || velocity.x.abs() >= TOLERANCE || velocity.y.abs() >= TOLERANCE;

    if (!isMoving && !hasCollided) return;

    if (hasCollided) {
      velocity.addVectorToThis(collisionCorrection);
      velocityRotation += collisionCorrectionRotation;
    } else {
      velocity.multiplyToThis(1 - _friction);
      velocityRotation *= (1 - _friction);
    }
    Teleport(velocity, velocityRotation);

    ResetCollisions();
  }

  void ResetCollisions() {
    collisionCorrectionRotation = 0;
    collisionCorrection.reset();
    hasCollided = false;
  }

  GameItemMovable(Polygon polygon) : super(polygon) {
    var width = polygon.dimensions.x;
    var height = polygon.dimensions.y;
    mass = width * width + height * height; //w * h * h / 1000;
    rotationalMass = 4.0 /
        3.0 *
        width *
        height *
        (width * width + height * height) *
        _density; //rotational mass, 4/3 * width * height * (width^2 + height^2) * a.density
  }
}

class GameItem {
  double elasticy = 1.5;
  Polygon polygon;
  Aabb aabb = new Aabb();
  double r = 0.0;

  Vector get position => polygon.center;

  GameItem(this.polygon) {
    aabb.update(polygon);
  }

  void TelePort(double x, double y) {
    applyMatrix(new Matrix2d.translation(x - polygon.center.x, y - polygon.center.y));
  }

  void Teleport(Vector offset, double rotate) {
    var centerX = polygon.center.x;
    var centerY = polygon.center.y;
    r += rotate;
    var m = new Matrix2d.translation(centerX, centerY)
        .rotateThis(rotate)
        .translateThis(-centerX, -centerY)
        .translateThisVector(offset);
    applyMatrix(m);
  }

  void applyMatrix(Matrix2d matrix){
    polygon.applyMatrixToThis(matrix);
    aabb.update(polygon);
  }

  void onCollision(GameItem other) {}
}
