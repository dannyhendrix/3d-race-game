part of game.collision;

class CollisionHandling {
  //private double _elasticy = 1.5;// elacity between 1 and 2. 2 is bounce
  void handleCollision(GameItemMovable a, GameItemMovable b, PolygonCollisionResult collision) {
    var elasticy = a.Elasticy * 0.5 + b.Elasticy * 0.5;
    var centerToHitA = a.polygon.center - collision.hitLocation;
    var centerToHitB = b.polygon.center - collision.hitLocation;
    // vp -> velocity on impact (including rotation)

    var velocityOnImpact = centerToHitA.clone()
        .crossProductToThis(a.VelocityRotation)
        .addVectorToThis(a.Velocity)
        .subtractToThis(b.Velocity)
        .subtractToThis(centerToHitB.clone().crossProductToThis(b.VelocityRotation));
    var resultingForce =
        velocityOnImpact.dotProductThis(collision.translationVector); // negative val = moving towards each other
    if (resultingForce >= 0) {
      // do they move apart?
      return;
    }
    var massImpactA = 1 / a.Mass;
    var massImpactB = 1 / b.Mass;

    // normal impulse
    double normalImpulse = -elasticy *
        resultingForce /
        (massImpactA +
            Math.pow(collision.translationVector.crossProductThis(centerToHitA), 2) / a.RotationalMass +
            massImpactB +
            Math.pow(collision.translationVector.crossProductThis(centerToHitB), 2) / b.RotationalMass);
    var resultingImpulse = collision.translationVector * normalImpulse;
    //

    a.CollisionCorrectionRotation += resultingImpulse.crossProductThis(centerToHitA) / a.RotationalMass;
    b.CollisionCorrectionRotation -= resultingImpulse.crossProductThis(centerToHitB) / b.RotationalMass;
    a.CollisionCorrection.addToThis(resultingImpulse.x * massImpactA, resultingImpulse.y * massImpactA);
    b.CollisionCorrection.addToThis(-resultingImpulse.x * massImpactB, -resultingImpulse.y * massImpactB);

    a.HasCollided = true;
    b.HasCollided = true;
  }

  void handleCollisionSingle(GameItemMovable a, GameItemStatic b, PolygonCollisionResult collision) {
    var elasticy = a.Elasticy * 0.5 + b.Elasticy * 0.5;
    var centerToHitA = a.polygon.center - collision.hitLocation;
    var velocityOnImpact = centerToHitA.clone().crossProductToThis(a.VelocityRotation).addVectorToThis(a.Velocity);

    var resultingForce =
        velocityOnImpact.dotProductThis(collision.translationVector); // negative val = moving towards each other
    if (resultingForce >= 0) {
      // do they move apart?
      return;
    }

    var massImpactA = 1 / a.Mass;

    // normal impulse
    var normalImpulse = -elasticy *
        resultingForce /
        (massImpactA + Math.pow(collision.translationVector.crossProductThis(centerToHitA), 2) / a.RotationalMass);
    var resultingImpulse = collision.translationVector * normalImpulse;
    //
    a.CollisionCorrectionRotation += resultingImpulse.crossProductThis(centerToHitA) / a.RotationalMass;
    a.CollisionCorrection.addToThis(resultingImpulse.x * massImpactA, resultingImpulse.y * massImpactA);
    a.HasCollided = true;
  }
}
