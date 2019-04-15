part of game.collision;

class CollisionController
{
  List<GameItemStatic> _gameItemsStatic = new List<GameItemStatic>();
  List<GameItemMovable> _gameItemsMovable = new List<GameItemMovable>();
  CollisionDetection _collistionDetection = new CollisionDetection();
  CollisionHandling _collisionHandling = new CollisionHandling();

  void register(GameItem item)
  {
    if(item is GameItemStatic) _gameItemsStatic.add(item);
    if(item is GameItemMovable) _gameItemsMovable.add(item);
  }

  void handleCollisions()
  {
    // check all movable items
    for (var i = 0; i < _gameItemsMovable.length; i++)
    {
      var gameItemMovable = _gameItemsMovable[i];

      // check for collisions against all movable items with a higher index than this (this prevenst testing the same objects twice)
      for (var j = i + 1; j < _gameItemsMovable.length; j++)
      {
        var gameItem = _gameItemsMovable[j];
        // if both are not moving, skip checking
        if (!gameItem.IsMoving && !gameItemMovable.IsMoving) continue;
        if (!gameItemMovable.aabb.collidesWith(gameItem.aabb)) continue;
        var collision = _collistionDetection.polygonCollision(gameItemMovable.polygon, gameItem.polygon);
        if (collision == null) continue;

        _collisionHandling.handleCollision(gameItemMovable, gameItem, collision); // full bounce
        gameItemMovable.OnCollision(gameItem);
        gameItem.OnCollision(gameItemMovable);
      }

      // if the object is moving, check for collisions against all static items
      if (gameItemMovable.IsMoving)
      {
        for (var gameItem in _gameItemsStatic)
        {
          if (!gameItemMovable.aabb.collidesWith(gameItem.aabb)) continue;
          var collision = _collistionDetection.polygonCollision(gameItemMovable.polygon, gameItem.polygon);
          if (collision == null) continue;

          _collisionHandling.handleCollisionSingle(gameItemMovable, gameItem, collision); // no bounce
          gameItemMovable.OnCollision(gameItem);
          gameItem.OnCollision(gameItemMovable);
        }
      }
    }
  }
}