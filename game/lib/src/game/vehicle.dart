part of micromachines;

class Vehicle extends MoveableGameObject{
  bool _isBraking = false;
  bool _isAccelerating = false;
  bool _isReverse = false;
  Steer _isSteering = Steer.None;
  double _speed = 0.0;
  double _acceleration = 0.0;
  double _braking = 0.0;
  double _reversing = 0.0;
  double _steering = 0.0;
  String info = "";

  Vehicle(){
    x = 150.0;
    y = 50.0;
    r = 1.7;
    w = 40;
    h = 80;
    collisionField = new Polygon([
      new Point(0,0),
      new Point(w,0),
      new Point(w,h),
      new Point(0,h),
    ]);
  }
  void setAccelarate(bool a){
    _isAccelerating = a;
    _acceleration = 0;
  }
  void setBrake(bool a){
    _isBraking = a;
    _braking = 0;
  }
  void setSteer(Steer a){
    _isSteering = a;
  }

  void update(){
    double maxAcc = 6.0;
    double stepAcc = 0.05;
    double stepAccRelease = 0.005;

    double maxRev = 0.01;
    double stepRev = 0.001;
    double stepRevRelease = -0.1;

    double maxBrake = 1.0;
    double stepBrake = 0.02;
    double stepBrakeRelease = -0.2;

    double maxSpeed = 8.0;

    if(_isAccelerating){
      _acceleration += stepAcc;
      if(_acceleration<-maxAcc) _acceleration = -maxAcc;
      if(_acceleration>maxAcc) _acceleration = maxAcc;
    }else{
      _acceleration -= stepAccRelease;
      if(_acceleration<-maxAcc) _acceleration = -maxAcc;
      if(_acceleration>maxAcc) _acceleration = maxAcc;
    }
    if(_isBraking){
      _braking += stepBrake;
      if(_braking<0) _braking = 0;
      if(_braking>maxBrake) _braking = maxBrake;
    }else{
      _braking = 0.0;
      /*
      _braking += stepBrakeRelease;
      if(_braking<0) _braking = 0;
      if(_braking>maxBrake) _braking = maxBrake;
      */
    }
    if(_acceleration > 0 || _speed > 0)    {
      _speed += _acceleration;
      if(_speed < 0) _speed = 0;
    }
    _speed -= _braking;
    //TODO: reverse
    //if(_speed < 0) _speed = 0.0;
    //if(_speed < 0) _speed = 0;
    if(_speed < -maxSpeed) _speed = -maxSpeed;
    if(_speed > maxSpeed) _speed = maxSpeed;




    double maxSteer = 0.06;
    double stepSteer = 0.006;
    double stepSteerRelease = 0.01;

    switch(_isSteering){
      case Steer.Left:
        _steering -= stepSteer;
        if(_steering < -maxSteer) _steering = -maxSteer;
        break;
      case Steer.Right:
        _steering += stepSteer;
        if(_steering > maxSteer) _steering = maxSteer;
        break;
      case Steer.None:
        if(_steering < 0){
          _steering += stepSteerRelease;
          if(_steering > 0) _steering = 0;
        }else{
          _steering -= stepSteerRelease;
          if(_steering < 0) _steering = 0;
        }
        break;
    }
    r += _steering;



    vector = new Vector.fromAngleRadians(r,_speed);
    //x += vector.x;
    //y += vector.y;
    info = "$_braking\n $_acceleration\n $_speed\n $_isSteering\n $_steering";
  }

  void onCollision(GameObject o){
    _speed = -_speed/2;
    _acceleration = 0.0;
    _braking = 0.0;
    _steering = 0.0;
  }
}