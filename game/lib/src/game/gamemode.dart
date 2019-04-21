part of micromachines;

class GameMode extends CollisionHandling{
  CollisionHandling _physicsHandler = new CollisionHandlingPhysics();
  @override
  void handleCollision(GameItemMovable a, GameItemMovable b, PolygonCollisionResult collision) {
    _physicsHandler.handleCollision(a, b, collision);
  }

  @override
  void handleCollisionSingle(GameItemMovable a, GameItemStatic b, PolygonCollisionResult collision) {
    if(b is CheckpointGameItem){
      Vehicle v = a;
      CheckpointGameItem c = b;
      v.player.pathProgress.collect(c);
      return;
    }
    _physicsHandler.handleCollisionSingle(a, b, collision);
  }

  void handleCollisionId(int idA, int idB){
    var aIsCar = idA & Vehicle.BASEID;
  }
}


abstract class GameProgress{
  GameState state;
  void collisionEvent(GameItem itemA, GameItem itemB){
    //order based on ID
    if(itemA.id < itemB.id){
      var itemC = itemA;
      itemA = itemB;
      itemB = itemC;
    }


  }
}