part of game.collision;

class CollisionController {
  CollisionDetection _collistionDetection;
  CollisionHandling _collisionHandling;

  CollisionController(this._collisionHandling, this._collistionDetection);

  void handleCollisions(List<GameItemMovable> _gameItemsMovable) {
    // check all movable items
    for (var i = 0; i < _gameItemsMovable.length; i++) {
      var gameItemMovable = _gameItemsMovable[i];

      // check for collisions against all movable items with a higher index than this (this prevenst testing the same objects twice)
      for (var j = i + 1; j < _gameItemsMovable.length; j++) {
        var gameItem = _gameItemsMovable[j];
        // if both are not moving, skip checking
        if (!gameItem.isMoving && !gameItemMovable.isMoving) continue;
        if (!gameItemMovable.aabb.collidesWith(gameItem.aabb)) continue;
        var collision = _collistionDetection.polygonCollision(gameItemMovable.polygon, gameItem.polygon);
        if (collision == null) continue;

        _collisionHandling.handleCollision(gameItemMovable, gameItem, collision); // full bounce
      }
    }
  }

  void handleCollisions2(List<GameItemStatic> _gameItemsStatic, List<GameItemMovable> _gameItemsMovable) {
    // check all movable items
    for (var i = 0; i < _gameItemsMovable.length; i++) {
      var gameItemMovable = _gameItemsMovable[i];

      // if the object is moving, check for collisions against all static items
      if (gameItemMovable.isMoving) {
        for (var gameItem in _gameItemsStatic) {
          if (!gameItemMovable.aabb.collidesWith(gameItem.aabb)) continue;
          var collision = _collistionDetection.polygonCollision(gameItemMovable.polygon, gameItem.polygon);
          if (collision == null) continue;

          _collisionHandling.handleCollisionSingle(gameItemMovable, gameItem, collision); // no bounce
        }
      }
    }
  }

  void handleCollisions3(List<GameItemMovable> _gameItemsMovableA, List<GameItemMovable> _gameItemsMovableB) {
    // check all movable items
    for (var i = 0; i < _gameItemsMovableA.length; i++) {
      var gameItemMovable = _gameItemsMovableA[i];

      // check for collisions against all movable items with a higher index than this (this prevenst testing the same objects twice)
      for (var j = 0; j < _gameItemsMovableB.length; j++) {
        var gameItem = _gameItemsMovableB[j];
        // if both are not moving, skip checking
        if (!gameItem.isMoving && !gameItemMovable.isMoving) continue;
        if (!gameItemMovable.aabb.collidesWith(gameItem.aabb)) continue;
        var collision = _collistionDetection.polygonCollision(gameItemMovable.polygon, gameItem.polygon);
        if (collision == null) continue;

        _collisionHandling.handleCollision(gameItemMovable, gameItem, collision); // full bounce
      }
    }
  }

/*
  void handleCollisions(List<GameItemStatic> _gameItemsStatic, List<GameItemMovable> _gameItemsMovable) {
    // check all movable items
    for (var i = 0; i < _gameItemsMovable.length; i++) {
      var gameItemMovable = _gameItemsMovable[i];

      // check for collisions against all movable items with a higher index than this (this prevenst testing the same objects twice)
      for (var j = i + 1; j < _gameItemsMovable.length; j++) {
        var gameItem = _gameItemsMovable[j];
        // if both are not moving, skip checking
        if (!gameItem.isMoving && !gameItemMovable.isMoving) continue;
        if (!gameItemMovable.aabb.collidesWith(gameItem.aabb)) continue;
        var collision = _collistionDetection.polygonCollision(gameItemMovable.polygon, gameItem.polygon);
        if (collision == null) continue;

        _collisionHandling.handleCollision(gameItemMovable, gameItem, collision); // full bounce
      }

      // if the object is moving, check for collisions against all static items
      if (gameItemMovable.isMoving) {
        for (var gameItem in _gameItemsStatic) {
          if (!gameItemMovable.aabb.collidesWith(gameItem.aabb)) continue;
          var collision = _collistionDetection.polygonCollision(gameItemMovable.polygon, gameItem.polygon);
          if (collision == null) continue;

          _collisionHandling.handleCollisionSingle(gameItemMovable, gameItem, collision); // no bounce
        }
      }
    }
  }
  */
}
