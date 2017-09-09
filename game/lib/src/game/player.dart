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
        if(active){
          controlList.remove(Control.SteerLeft);
          controlList.add(Control.SteerLeft);
        }else{
          controlList.remove(Control.SteerLeft);
        }
        break;
      case Control.SteerRight:
        if(active){
          controlList.remove(Control.SteerRight);
          controlList.add(Control.SteerRight);
        }else{
          controlList.remove(Control.SteerRight);
        }
        break;
    }
    if(controlList.length == 0){
      vehicle.setSteer(Steer.None);
    }else{
      var last = controlList.last;
      if(last == Control.SteerLeft)
        vehicle.setSteer(Steer.Left);
      else
        vehicle.setSteer(Steer.Right);
    }
  }
}