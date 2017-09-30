part of micromachines;

class HumanPlayer extends Player{
  bool _isSteeringLeft;
  bool _isSteeringRight;

  void onControl(Control control, bool active){
    switch(control){
      case Control.Accelerate:
        vehicle.setAccelarate(active);
        break;
      case Control.Brake:
        vehicle.setBrake(active);
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
    if(_isSteeringRight && !_isSteeringLeft)
      vehicle.setSteer(Steer.Right);
    else if(!_isSteeringRight && _isSteeringLeft)
      vehicle.setSteer(Steer.Left);
    else
      vehicle.setSteer(Steer.None);
  }

  void update(){
    Point p =  pathProgress.current;
    Point v =  vehicle.position;
    Vector V =  new Vector(p.x-v.x,p.y-v.y);
    vehicle.info = "${pathProgress.finished}";
    if(V.magnitude < pathProgress.path.pointRadius){
      pathProgress.next();
    }
  }
}
class AiPlayer extends Player{
  void update(){
    if(pathProgress.finished){
      vehicle.setSteer(Steer.Left);
      vehicle.setAccelarate(false);
      return;
    }
    Point p =  pathProgress.current;
    Point v =  vehicle.position;
    Vector V =  new Vector(p.x-v.x,p.y-v.y);
    vehicle.info = "${pathProgress.finished}";
    if(V.magnitude < pathProgress.path.pointRadius){
      pathProgress.next();
    }
    Steer steer = determineSteerAngle(v,vehicle.r,p);
    vehicle.setSteer(steer);
    vehicle.setAccelarate(true);
  }

  Steer determineSteerAngle(Point A, double RA, Point B){
    var dist = B-A;
    var normT = new Vector(dist.x,dist.y).normalized;
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
      if(rt-ra > Math.PI) return Steer.Left;
      return Steer.Right;
    }
    if(ra > 0 && rt < 0){
      if(ra-rt > Math.PI) return Steer.Right;
      return Steer.Left;
    }
    return Steer.None;
  }
}

abstract class Player{
  Game _game;
  Vehicle vehicle;
  PathProgress pathProgress;

  void init(Game game){
    _game = game;
  }
  void start(Vehicle v, Path path){
    vehicle = v;
    pathProgress = new PathProgress(path);
  }
  void update();
}