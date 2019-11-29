part of game;

class GameMode extends CollisionHandling {
  CollisionHandling _physicsHandler = new CollisionHandlingPhysics();
  Game _game;
  GameMode(this._game);
  @override
  void handleCollision(GameItemMovable a, GameItemMovable b, PolygonCollisionResult collision) {
    _physicsHandler.handleCollision(a, b, collision);
  }

  @override
  void handleCollisionSingle(GameItemMovable a, GameItemStatic b, PolygonCollisionResult collision) {
    if (b is CheckpointGameItem && a is Vehicle) {
      _game.collectCheckPoint(a, b);
      return;
    }
    _physicsHandler.handleCollisionSingle(a, b, collision);
  }
}
