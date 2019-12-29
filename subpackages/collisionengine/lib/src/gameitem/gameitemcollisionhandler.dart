part of game.gameitem;

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

class GameObjectCollisionHandlerVehicle extends GameObjectHandler {
  void update(GameItemMovable gameobject) {
    var TOLERANCE = 1e-4;
    gameobject.isMoving = gameobject.velocityRotation.abs() >= TOLERANCE || gameobject.velocity.x.abs() >= TOLERANCE || gameobject.velocity.y.abs() >= TOLERANCE;

    if (!gameobject.isMoving && !gameobject.hasCollided) return;

    if (gameobject.hasCollided) {
      gameobject.velocity.addVectorToThis(gameobject.collisionCorrection);
      //gameobject.velocityRotation += gameobject.collisionCorrectionRotation;
    } else {
      gameobject.velocity.multiplyToThis(1 - gameobject.friction);
    }
    gameobject.applyOffsetRotation(gameobject.velocity, gameobject.velocityRotation);
    gameobject.resetCollisions();
  }
}

abstract class GameObjectHandler {
  update(GameItemMovable gameobject);
}
