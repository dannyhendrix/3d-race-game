part of micromachines;

class Player{
  Game _game;
  Vehicle vehicle;
  bool _isSteeringLeft;
  bool _isSteeringRight;
  List<Control> controlList = [];

  void init(Game game){
    _game = game;
  }
  void start(Vehicle v){
    vehicle = v;
  }
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
}