part of micromachines;

class HumanPlayer extends Player{
  bool _isSteeringLeft = false;
  bool _isSteeringRight = false;
  bool _isAccelarating = false;
  bool _isBreaking = false;

  HumanPlayer(GameSettingsPlayer player,VehicleTheme theme):super(player,theme){
  }

  void onControl(Control control, bool active){
    switch(control){
      case Control.Accelerate:
        _isAccelarating = active;
        break;
      case Control.Brake:
        _isBreaking = active;
        break;
      case Control.SteerLeft:
        _isSteeringLeft = active;
        break;
      case Control.SteerRight:
        _isSteeringRight = active;
        break;
      default:
        break;
    }

    vehicle.setAccelarate(_isAccelarating);
    vehicle.setBrake(_isBreaking);
    if(_isSteeringRight && !_isSteeringLeft)
      vehicle.setSteer(Steer.Right);
    else if(!_isSteeringRight && _isSteeringLeft)
      vehicle.setSteer(Steer.Left);
    else
      vehicle.setSteer(Steer.None);
  }

  void update(){
    Point2d p =  pathProgress.current;
    Point2d v =  vehicle.position;
    Vector V =  new Vector(p.x-v.x,p.y-v.y);
    vehicle.info = "${pathProgress.finished}";
    if(V.magnitude < pathProgress.current.radius){
      pathProgress.next();
    }
  }
}
class AiPlayer extends Player{
  AiPlayer(GameSettingsPlayer player,VehicleTheme theme):super(player,theme){
  }
  void update(){
    if(pathProgress.finished){
      vehicle.setSteer(Steer.Left);
      vehicle.setAccelarate(false);
      return;
    }
    if(_game.state != GameState.Racing) return;
    Point2d p =  pathProgress.current;
    Point2d v =  vehicle.position;
    Vector V =  new Vector(p.x-v.x,p.y-v.y);
    if(V.magnitude < pathProgress.current.radius){
      pathProgress.next();
    }
    if(vehicle.sensorCollision){
      controlAvoidance();
    }else{
      controlToTarget();
    }
  }

  void controlToTarget(){
    Point2d p =  pathProgress.current;
    Point2d v =  vehicle.position;
    vehicle.setSteer(steerToPoint(v,vehicle.r,p));
    vehicle.setAccelarate(true);
  }
  void controlAvoidance(){
    Steer steer = Steer.None;
    bool accelerate = true;
    double correction = 0.0;
    if(vehicle.sensorLeft.collides) correction -= 0.2;
    if(vehicle.sensorLeftFront.collides) correction -= 0.5;
    if(vehicle.sensorLeftFrontAngle.collides) correction -= 0.5;
    if(vehicle.sensorRight.collides) correction += 0.2;
    if(vehicle.sensorRightFront.collides) correction += 0.5;
    if(vehicle.sensorRightFrontAngle.collides) correction += 0.5;

    if(vehicle.sensorFront.collides) accelerate = false;

    if(correction > 0.0) steer = Steer.Left;
    else if(correction < 0.0) steer = Steer.Right;
    else if(vehicle.sensorFront.collides) steer = Steer.Right;

    vehicle.setSteer(steer);
    vehicle.setAccelarate(accelerate);
    /*
    bool leftCollision = vehicle.sensorLeft.collides || vehicle.sensorLeftFront.collides || vehicle.sensorLeftFrontAngle.collides;
    bool rightCollision = vehicle.sensorRight.collides || vehicle.sensorRightFront.collides || vehicle.sensorRightFrontAngle.collides;
    if(leftCollision && rightCollision) return Steer.None;
    if(leftCollision) return Steer.Right;
    if(rightCollision) return Steer.Left;
    return Steer.None;*/
  }

  Steer steerToPoint(Point2d A, double RA, Point2d B){
    var dist = B-A;
    var normT = new Vector(dist.x,dist.y);//.normalized;
    var normA = new Vector.fromAngleRadians(RA,1.0);
    var ra = normA.angle;
    var rt = normT.angle;
    if(ra == 0){
      if(rt>0) return Steer.Right;
      return Steer.Left;
    }
    if(rt == 0){
      if(ra<0) return Steer.Right;
      return Steer.Left;
    }
    if(ra < 0 && rt < 0){
      if(ra < rt) return Steer.Right;
      return Steer.Left;
    }
    if(ra > 0 && rt > 0){
      if(rt < ra) return Steer.Left;
      return Steer.Right;
    }
    if(ra < 0 && rt > 0){
      if(rt-ra > Math.pi) return Steer.Left;
      return Steer.Right;
    }
    if(ra > 0 && rt < 0){
      if(ra-rt > Math.pi) return Steer.Right;
      return Steer.Left;
    }
    return Steer.None;
  }
}

abstract class Player{
  Game _game;
  Vehicle vehicle;
  PathProgress pathProgress;
  GameSettingsPlayer player;
  VehicleTheme theme;
  Player(this.player, this.theme);

  bool get finished => pathProgress.finished;

  void init(Game game, Vehicle v, Path path){
    _game = game;
    vehicle = v;
    pathProgress = new PathProgress(path);
  }
  void update();
}