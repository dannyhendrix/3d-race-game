part of micromachines;

class Ball extends MoveableGameObject{
  Game game;
  double maxSpeed = 2.0;
  double speed = 0.0;
 Ball(this.game){
   position = new Point(400.0, 400.0);
   r = 1.7;
   w = 20.0;
   h = 20.0;
   double hw = w/2;
   double hh= h/2;
   collisionField = new Polygon([
     new Point(-hw,-hh),
     new Point(hw,-hh),
     new Point(hw,hh),
     new Point(-hw,hh),
   ]);
 }

  void onHit(double r){
    speed += 0.1;
    if(speed > maxSpeed)
      speed = maxSpeed;
    vector = new Vector.fromAngleRadians(r,speed);
    this.r = r;
  }


 void update(){
   //position += vector;
   var collisionCorrection = vector;
   bool collide = false;
   //check collisions
   for(GameObject g in game.gameobjects){
     if(g == this) continue;
     if(g is Vehicle) continue;


     Matrix2d M = getTransformation();
     Polygon A = collisionField.applyMatrix(M);
     Matrix2d oM = g.getTransformation();
     Polygon B = g.collisionField.applyMatrix(oM);

     CollisionResult r = A.collisionWithVector(B, vector);

     if (r.willIntersect) {
       if(!g.onCollision(this)){
         collide = true;
         collisionCorrection += r.minimumTranslationVector;
        vector = -vector;
       }
       //g.onCollision(this,polygonATranslation);
     }
   }
   /*
   if(collide) {
       _speed = _applyFriction(_speed, vehicleSettings.getValue(VehicleSettingKeys.collision_force));
       vector = new Vector.fromAngleRadians(r,_speed);
     }
   }
   */
   position += vector + collisionCorrection;
 }
}