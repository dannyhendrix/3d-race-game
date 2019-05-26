part of micromachines;

enum VehicleSettingKeys {
  acceleration,
  acceleration_max,
  reverse_acceleration,
  reverse_acceleration_max,
  friction,
  brake_speed,
  steering_speed,
  standstill_delay,
  collision_force,
  collision_force_after_collision,
}

class VehicleSettings{
  Map data = {
    VehicleSettingKeys.acceleration.toString() :0.3,
    VehicleSettingKeys.acceleration_max.toString() : 5.0,
    VehicleSettingKeys.reverse_acceleration.toString() : 0.1,
    VehicleSettingKeys.reverse_acceleration_max.toString() : 2.0,
    VehicleSettingKeys.friction.toString() : 0.05,
    VehicleSettingKeys.brake_speed.toString() : 0.2,
    VehicleSettingKeys.steering_speed.toString() : 0.1,
    VehicleSettingKeys.standstill_delay.toString() : 6,
    VehicleSettingKeys.collision_force.toString() : 4.0,
    VehicleSettingKeys.collision_force_after_collision.toString() : 0.35,
  };
  dynamic getValue(VehicleSettingKeys key){
    return data[key.toString()];
  }
  void setValue(VehicleSettingKeys key, dynamic value){
    data[key.toString()] = value;
  }
}
// TODO: maybe make the whole car body a sensor?
class VehicleSensor{
  Polygon polygon;
  bool collides = false;
  VehicleSensor.fromVector(Vector origin, Vector v){
    polygon = new Polygon([origin, origin + v]);
  }
}
class Truck extends Vehicle{
  Truck(Game game, Player player) : super(game,player, GameConstants.truckSize){
    /*
    VehicleSettingKeys.acceleration.toString() :0.3,
    VehicleSettingKeys.acceleration_max.toString() : 5.0,
    VehicleSettingKeys.reverse_acceleration.toString() : 0.1,
    VehicleSettingKeys.reverse_acceleration_max.toString() : 2.0,
    VehicleSettingKeys.friction.toString() : 0.05,
    VehicleSettingKeys.brake_speed.toString() : 0.2,
    VehicleSettingKeys.steering_speed.toString() : 0.1,
    VehicleSettingKeys.standstill_delay.toString() : 6,
    VehicleSettingKeys.collision_force.toString() : 4.0,
    VehicleSettingKeys.collision_force_after_collision.toString() : 0.35,
     */
    vehicleSettings.setValue(VehicleSettingKeys.acceleration, 0.2);
    vehicleSettings.setValue(VehicleSettingKeys.acceleration_max, 5.0);
    vehicleSettings.setValue(VehicleSettingKeys.standstill_delay, 8);
  }
}
class Car extends Vehicle{
  Car(Game game, Player player) : super(game,player, GameConstants.carSize);
}
class FormulaCar extends Vehicle{
  FormulaCar(Game game, Player player) : super(game,player, GameConstants.formulaCarSize){
    vehicleSettings.setValue(VehicleSettingKeys.acceleration, 2.0);
    vehicleSettings.setValue(VehicleSettingKeys.acceleration_max, 7.0);
    vehicleSettings.setValue(VehicleSettingKeys.standstill_delay, 4);
  }
}
abstract class Vehicle extends GameItemMovable{
  static int BASEID = 0x10000;
  Game game;
  Player player;
  bool _isBraking = false;
  bool _isAccelerating = false;
  Steer _isSteering = Steer.None;
  double _speed = 0.0;
  String info = "";
  int _currentStandStillDelay = 0;
  bool _isCollided = false;
  VehicleSettings vehicleSettings = new VehicleSettings();
  int theme = 0;
  Vector trailerSnapPoint;
  /**
   * There are 7 sensor on the car body: (facing upwards)
   *     1 2  3  4 5
   *     \|  |  |/
   *       _____
   *      |  ^  |
   *   6 -|     |- 7
   *      |_____|
   *
   *  Naming:
   *  1 LeftFrontAngle
   *  2 LeftFront
   *  3 Front
   *  4 RightFront
   *  5 RightFrontAngle
   *  6 Left
   *  7 Right
   *
   *  Sensor behaviour:
   *  if 1,2 Steer right 0.5
   *  if 4,5 Steer left 0.5
   *  if 3 brake
   *  if 6 Steer right 0.2
   *  if 7 Steer left 0.2
   */
  double sensorLength = 30.0;
  double sensorLengthSide = 10.0;
  double sensorLengthFrontSide = 20.0;
  double sensorFrontAngle = 1.0;
  VehicleSensor sensorLeftFrontAngle;
  VehicleSensor sensorLeftFront;
  VehicleSensor sensorFront;
  VehicleSensor sensorRightFront;
  VehicleSensor sensorRightFrontAngle;
  VehicleSensor sensorLeft;
  VehicleSensor sensorRight;
  List<VehicleSensor> sensors = [];
  bool sensorCollision = false;
  Trailer trailer;

  Vehicle(this.game, this.player, Vector size):super(Polygon.createSquare(0.0, 0.0, size.x, size.y, 0.0)){
    id += BASEID;
    trailerSnapPoint = new Vector(-size.x/2,0.0);
    double hw = size.x/2;
    double hh= size.y/2;
    sensorLeftFrontAngle = new VehicleSensor.fromVector(new Vector(hw,-hh), new Vector.fromAngleRadians(-sensorFrontAngle, sensorLengthFrontSide));
    sensorLeftFront = new VehicleSensor.fromVector(new Vector(hw,-hh), new Vector(sensorLength, 0.0));
    sensorFront = new VehicleSensor.fromVector(new Vector(hw,0.0), new Vector(sensorLength, 0.0));
    sensorRightFront = new VehicleSensor.fromVector(new Vector(hw,hh), new Vector(sensorLength, 0.0));
    sensorRightFrontAngle = new VehicleSensor.fromVector(new Vector(hw,hh), new Vector.fromAngleRadians(sensorFrontAngle, sensorLengthFrontSide));
    sensorLeft = new VehicleSensor.fromVector(new Vector(0.0,-hh), new Vector(0.0, -sensorLengthSide));
    sensorRight = new VehicleSensor.fromVector(new Vector(0.0,hh), new Vector(0.0, sensorLengthSide));
    sensors = [sensorLeftFrontAngle, sensorLeftFront, sensorFront, sensorRightFront, sensorRightFrontAngle, sensorLeft, sensorRight];
  }
  void setAccelarate(bool a){
    _isAccelerating = a;
  }
  void setBrake(bool a){
    _isBraking = a;
  }
  void setSteer(Steer a){
    _isSteering = a;
  }

  bool get isCollided => _isCollided;

  void update(){
    bool gameStateRacing = game.state == GameState.Racing;
    //bool gameStateRacingOrCountDown = game.state == GameState.Racing || game.state == GameState.Countdown;
    //Steering
    var oldr = r;
    if(gameStateRacing) r = _applySteering(r,vehicleSettings.getValue(VehicleSettingKeys.steering_speed), _isSteering);
var newr = r;
r=oldr;

    //Apply Forces
    bool wasStandingStill = _speed == 0;
    _speed = _applyAccelerationAndBrake(_speed,
        vehicleSettings.getValue(VehicleSettingKeys.acceleration),
        vehicleSettings.getValue(VehicleSettingKeys.reverse_acceleration),
        vehicleSettings.getValue(VehicleSettingKeys.brake_speed),
        vehicleSettings.getValue(VehicleSettingKeys.acceleration_max),
        vehicleSettings.getValue(VehicleSettingKeys.reverse_acceleration_max),
        _currentStandStillDelay==0,  _isAccelerating && gameStateRacing, _isBraking && gameStateRacing);
    _speed = _applyFriction(_speed,vehicleSettings.getValue(VehicleSettingKeys.friction));

    // slower off road
    // TODO: make this level dependant?
    if(!game.level.onRoad(position)){
      _speed *= 0.9;
    }
    _currentStandStillDelay = _updateStandStillDelay(_currentStandStillDelay,vehicleSettings.getValue(VehicleSettingKeys.standstill_delay), wasStandingStill, _speed==0);

    //Velocity *= 0.6;
    //Velocity += Vector.NewFromAngleRadians(R, Speed)*0.01;
    var rdif = newr - oldr;
    //position += vector;
    //base.Step();

    isMoving = true;
    //VelocityRotation = rdif;
    velocityRotation = rdif;

    var _friction = 0.5;

    velocity.addVectorToThis(collisionCorrection);
    velocityRotation += collisionCorrectionRotation;

    if (!hasCollided)
    {
      velocity.multiplyToThis(1 - _friction);
      //VelocityRotation *= (1 - _friction);
      velocity.addVectorToThis(new Vector.fromAngleRadians(r, _speed) * 0.5);
    }

    Teleport(velocity, velocityRotation);

    ResetCollisions();






   /*
    bool gameStateRacing = game.state == GameState.Racing;
    //bool gameStateRacingOrCountDown = game.state == GameState.Racing || game.state == GameState.Countdown;
    //Steering
    if(gameStateRacing) r = _applySteering(r,vehicleSettings.getValue(VehicleSettingKeys.steering_speed), _isSteering);

    //Apply Forces
    bool wasStandingStill = _speed == 0;
    _speed = _applyAccelerationAndBrake(_speed,
        vehicleSettings.getValue(VehicleSettingKeys.acceleration),
        vehicleSettings.getValue(VehicleSettingKeys.reverse_acceleration),
        vehicleSettings.getValue(VehicleSettingKeys.brake_speed),
        vehicleSettings.getValue(VehicleSettingKeys.acceleration_max),
        vehicleSettings.getValue(VehicleSettingKeys.reverse_acceleration_max),
        _currentStandStillDelay==0,  _isAccelerating && gameStateRacing, _isBraking && gameStateRacing);
    _speed = _applyFriction(_speed,vehicleSettings.getValue(VehicleSettingKeys.friction));

    // slower off road
    // TODO: make this level dependant?
    if(!player.pathProgress.path.onRoad(position)){
      _speed *= 0.9;
    }
    _currentStandStillDelay = _updateStandStillDelay(_currentStandStillDelay,vehicleSettings.getValue(VehicleSettingKeys.standstill_delay), wasStandingStill, _speed==0);
*//*
    velocity = new Vector.fromAngleRadians(r,_speed);
    //position += vector;
    var collisionCorrection = vector;
    bool collide = false;

    sensorCollision = false;
    for(VehicleSensor s in sensors) s.collides = false;
    //check collisions
    for(GameObject g in game.gameobjects){
      if(g == this) continue;

      Matrix2d M = getTransformation();

      //sensors
      for(VehicleSensor s in sensors){
        if(s.collides) continue;
        Polygon A = s.polygon.applyMatrix(M);
        s.collides = g.collidesPolygon(A, false).collision;//s.polygon.applyMatrix(M).collision(B);
        if(s.collides) sensorCollision = true;
      }

      //CollisionResult r = A.collisionWithVector(B, vector);
      GameObjectCollision collision = collidesVector(vector,g,false);

      if (collision.collision) {
        if(g is Ball){
          Ball b = g;
          b.onHit(this.r);
          continue;
        }
        else if(!g.onCollision(collision)){
          collide = true;
          collisionCorrection += collision.polygonCollisions.first.collisionResult.minimumTranslationVector;
        }
        //g.onCollision(this,polygonATranslation);
      }
    }
    if(collide) {
      if(_isCollided){
        double friction = vehicleSettings.getValue(VehicleSettingKeys.collision_force_after_collision);
        if(friction < _speed){
          _speed = _applyFriction(_speed, friction);
          vector = new Vector.fromAngleRadians(r,_speed);
        }
      }
      else{
        _speed = _applyFriction(_speed, vehicleSettings.getValue(VehicleSettingKeys.collision_force));
        vector = new Vector.fromAngleRadians(r,_speed);
      }
    }
    _isCollided = collide;
    position += vector + collisionCorrection;
    */
  }

  void applyMatrix(Matrix2d matrix){
    super.applyMatrix(matrix);
    for(var s in sensors){
      s.polygon.applyMatrixToThis(matrix);
    }
  }

  double _applyFriction(double V, double F){
    if(V > 0) V -= Math.min(V,F);
    else if(V < 0) V += Math.min(-V,F);
    return V;
  }
  double _applyAccelerationAndBrake(double V, double A, double R, double B, double MaxA, double MaxR, bool canStartFromZero, bool acc, bool brake){
    if(acc && brake){
      if(V>0) V -= B;
      else if(V<0) V += B;
    }else{
      if(V==0){
        if(canStartFromZero)
        {
          if (acc) V += A;
          if (brake) V -= R;
        }
      }
      else if(V>0){
        if(acc) V += A;
        if(brake) V -= Math.min(V,B);
      }
      else if(V<0){
        if(acc) V +=  Math.min(-V,B);
        if(brake) V -= R;
      }
    }
    if(V > MaxA) V = MaxA;
    if(V < -MaxR) V = -MaxR;
    return V;
  }
  int _updateStandStillDelay(int currentStandStillDelay, int standStillDelay, bool wasStandingStill, bool standingStill){
    if(!standingStill || !wasStandingStill) return standStillDelay;

    currentStandStillDelay -= 1;
    if(currentStandStillDelay < 0)
      currentStandStillDelay = 0;

    return currentStandStillDelay;
  }
  double _applySteering(double r, double S, Steer steering){
    switch(steering){
      case Steer.Left:
        r -= S;
        break;
      case Steer.Right:
        r += S;
        break;
      default:
        break;
    }
    return r;
  }
}