part of game;

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

class VehicleSettings {
  Map data = {
    VehicleSettingKeys.acceleration.toString(): 0.3,
    VehicleSettingKeys.acceleration_max.toString(): 5.0,
    VehicleSettingKeys.reverse_acceleration.toString(): 0.1,
    VehicleSettingKeys.reverse_acceleration_max.toString(): 2.0,
    VehicleSettingKeys.friction.toString(): 0.05,
    VehicleSettingKeys.brake_speed.toString(): 0.2,
    VehicleSettingKeys.steering_speed.toString(): 0.1,
    VehicleSettingKeys.standstill_delay.toString(): 6,
    VehicleSettingKeys.collision_force.toString(): 4.0,
    VehicleSettingKeys.collision_force_after_collision.toString(): 0.35,
  };
  dynamic getValue(VehicleSettingKeys key) {
    return data[key.toString()];
  }

  void setValue(VehicleSettingKeys key, dynamic value) {
    data[key.toString()] = value;
  }
}

// TODO: maybe make the whole car body a sensor?
class VehicleSensor {
  Polygon polygon;
  bool collides = false;
  VehicleSensor.fromVector(Vector origin, Vector v) {
    polygon = new Polygon([origin, origin + v]);
  }
}

class Truck extends Vehicle {
  Truck(Game game, Player player) : super(game, player, GameConstants.truckSize) {
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

class Car extends Vehicle {
  Car(Game game, Player player) : super(game, player, GameConstants.carSize);
}

class FormulaCar extends Vehicle {
  FormulaCar(Game game, Player player) : super(game, player, GameConstants.formulaCarSize) {
    vehicleSettings.setValue(VehicleSettingKeys.acceleration, 2.0);
    vehicleSettings.setValue(VehicleSettingKeys.acceleration_max, 7.0);
    vehicleSettings.setValue(VehicleSettingKeys.standstill_delay, 4);
  }
}

class PickupCar extends Vehicle {
  PickupCar(Game game, Player player) : super(game, player, GameConstants.pickupCarSize) {
    vehicleSettings.setValue(VehicleSettingKeys.acceleration, 1.0);
    vehicleSettings.setValue(VehicleSettingKeys.acceleration_max, 4.0);
    vehicleSettings.setValue(VehicleSettingKeys.standstill_delay, 6);
  }
}

abstract class Vehicle extends GameItemMovable {
  static int BASEID = 0x10000;
  Game game;
  Player player;
  bool _isBraking = false;
  double _brakeSpeed = 0.0;
  double _accSpeed = 0.0;
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

  Vehicle(this.game, this.player, Vector size) {
    setPolygon(Polygon.createSquare(0.0, 0.0, size.x, size.y, 0.0));
    id += BASEID;
    trailerSnapPoint = new Vector(-size.x / 2, 0.0);
    double hw = size.x / 2;
    double hh = size.y / 2;
    sensorLeftFrontAngle = new VehicleSensor.fromVector(new Vector(hw, -hh), new Vector.fromAngleRadians(-sensorFrontAngle, sensorLengthFrontSide));
    sensorLeftFront = new VehicleSensor.fromVector(new Vector(hw, -hh), new Vector(sensorLength, 0.0));
    sensorFront = new VehicleSensor.fromVector(new Vector(hw, 0.0), new Vector(sensorLength, 0.0));
    sensorRightFront = new VehicleSensor.fromVector(new Vector(hw, hh), new Vector(sensorLength, 0.0));
    sensorRightFrontAngle = new VehicleSensor.fromVector(new Vector(hw, hh), new Vector.fromAngleRadians(sensorFrontAngle, sensorLengthFrontSide));
    sensorLeft = new VehicleSensor.fromVector(new Vector(0.0, -hh), new Vector(0.0, -sensorLengthSide));
    sensorRight = new VehicleSensor.fromVector(new Vector(0.0, hh), new Vector(0.0, sensorLengthSide));
    sensors = [sensorLeftFrontAngle, sensorLeftFront, sensorFront, sensorRightFront, sensorRightFrontAngle, sensorLeft, sensorRight];
  }
  void setAccelarate(bool a, double speed) {
    _isAccelerating = a;
    _accSpeed = speed;
  }

  void setBrake(bool a, double speed) {
    _isBraking = a;
    _brakeSpeed = speed;
  }

  void setSteer(Steer a) {
    _isSteering = a;
  }

  bool get isCollided => _isCollided;

  void applyMatrix(Matrix2d matrix) {
    super.applyMatrix(matrix);
    for (var s in sensors) {
      s.polygon.applyMatrixToThis(matrix);
    }
  }
}
