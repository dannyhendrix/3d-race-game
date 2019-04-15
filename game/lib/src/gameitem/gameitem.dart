part of game.gameitem;

class GameItemStatic extends GameItem {
  GameItemStatic(Polygon polygon) : super(polygon);
}

class GameItemMovable extends GameItem {
  bool HasCollided = false;
  Vector CollisionCorrection = new Vector(0, 0);
  double CollisionCorrectionRotation = 0;
  double VelocityRotation = 0;
  Vector Velocity = new Vector(0, 0);
  double Mass = 0.0;
  double RotationalMass = 0.0;
  bool IsMoving = false;

  double _density = 1;
  double _friction = 0.001;

  void Step() {
    var TOLERANCE = 1e-4;
    IsMoving = VelocityRotation.abs() >= TOLERANCE || Velocity.x.abs() >= TOLERANCE || Velocity.y.abs() >= TOLERANCE;

    if (!IsMoving && !HasCollided) return;

    if (HasCollided) {
      Velocity.addVectorToThis(CollisionCorrection);
      VelocityRotation += CollisionCorrectionRotation;
    } else {
      Velocity.multiplyToThis(1 - _friction);
      VelocityRotation *= (1 - _friction);
    }
    Teleport(Velocity, VelocityRotation);

    ResetCollisions();
  }

  void ResetCollisions() {
    CollisionCorrectionRotation = 0;
    CollisionCorrection.reset();
    HasCollided = false;
  }

  GameItemMovable(Polygon polygon) : super(polygon) {
    var width = polygon.dimensions.x;
    var height = polygon.dimensions.y;
    Mass = width * width + height * height; //w * h * h / 1000;
    RotationalMass = 4.0 /
        3.0 *
        width *
        height *
        (width * width + height * height) *
        _density; //rotational mass, 4/3 * width * height * (width^2 + height^2) * a.density
  }
}

class GameItem {
  double Elasticy = 1.5;
  Polygon polygon;
  Aabb aabb = new Aabb();

  Vector get Position => polygon.center;

  GameItem(this.polygon) {
    aabb.update(polygon);
  }

  void TelePort(double x, double y) {
    polygon.applyMatrixToThis(new Matrix2d.translation(x - polygon.center.x, y - polygon.center.y));
    aabb.update(polygon);
  }

  void Teleport(Vector offset, double rotate) {
    var centerX = polygon.center.x;
    var centerY = polygon.center.y;
    var m = new Matrix2d.translation(centerX, centerY)
        .rotateThis(rotate)
        .translateThis(-centerX, -centerY)
        .translateThisVector(offset);
    polygon.applyMatrixToThis(m);
    aabb.update(polygon);
  }

  void OnCollision(GameItem other) {}
}
