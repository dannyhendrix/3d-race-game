part of game.collision;

abstract class CollisionHandling {
  void handleCollision(GameItemMovable a, GameItemMovable b, PolygonCollisionResult collision);
  void handleCollisionSingle(GameItemMovable a, GameItemStatic b, PolygonCollisionResult collision);
}

class CollisionHandlingPhysics implements CollisionHandling {
  //private double _elasticy = 1.5;// elacity between 1 and 2. 2 is bounce
  void handleCollision(GameItemMovable a, GameItemMovable b, PolygonCollisionResult collision) {
    var elasticy = a.elasticy * 0.5 + b.elasticy * 0.5;
    var centerToHitA = a.polygon.center - collision.hitLocation;
    var centerToHitB = b.polygon.center - collision.hitLocation;
    // vp -> velocity on impact (including rotation)

    var velocityOnImpact = centerToHitA.clone().crossProductToThis(a.velocityRotation).addVectorToThis(a.velocity).subtractToThis(b.velocity).subtractToThis(centerToHitB.clone().crossProductToThis(b.velocityRotation));
    var resultingForce = velocityOnImpact.dotProductThis(collision.translationVector); // negative val = moving towards each other
    if (resultingForce >= 0) {
      // do they move apart?
      return;
    }
    var massImpactA = 1 / a.mass;
    var massImpactB = 1 / b.mass;

    // normal impulse
    double normalImpulse = -elasticy * resultingForce / (massImpactA + pow(collision.translationVector.crossProductThis(centerToHitA), 2) / a.rotationalMass + massImpactB + pow(collision.translationVector.crossProductThis(centerToHitB), 2) / b.rotationalMass);
    var resultingImpulse = collision.translationVector * normalImpulse;
    //

    a.collisionCorrectionRotation += resultingImpulse.crossProductThis(centerToHitA) / a.rotationalMass;
    b.collisionCorrectionRotation -= resultingImpulse.crossProductThis(centerToHitB) / b.rotationalMass;
    a.collisionCorrection.addToThis(resultingImpulse.x * massImpactA, resultingImpulse.y * massImpactA);
    b.collisionCorrection.addToThis(-resultingImpulse.x * massImpactB, -resultingImpulse.y * massImpactB);

    a.hasCollided = true;
    b.hasCollided = true;
  }

  void handleCollisionSingle(GameItemMovable a, GameItemStatic b, PolygonCollisionResult collision) {
    var elasticy = a.elasticy * 0.5 + b.elasticy * 0.5;
    var centerToHitA = a.polygon.center - collision.hitLocation;
    var velocityOnImpact = centerToHitA.clone().crossProductToThis(a.velocityRotation).addVectorToThis(a.velocity);

    var resultingForce = velocityOnImpact.dotProductThis(collision.translationVector); // negative val = moving towards each other
    if (resultingForce >= 0) {
      // do they move apart?
      return;
    }

    var massImpactA = 1 / a.mass;

    // normal impulse
    var normalImpulse = -elasticy * resultingForce / (massImpactA + pow(collision.translationVector.crossProductThis(centerToHitA), 2) / a.rotationalMass);
    var resultingImpulse = collision.translationVector * normalImpulse;
    //
    a.collisionCorrectionRotation += resultingImpulse.crossProductThis(centerToHitA) / a.rotationalMass;
    a.collisionCorrection.addToThis(resultingImpulse.x * massImpactA, resultingImpulse.y * massImpactA);
    a.hasCollided = true;
  }
}
