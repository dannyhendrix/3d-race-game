part of game;

class AiPlayerControl {
  VehicleControl _vehicleControl = new VehicleControl();
  void update(GameState game, Vehicle vehicle, AiPlayer player) {
    if (player.pathProgress.finished) {
      vehicle.setSteer(Steer.Left);
      vehicle.setAccelarate(false, 1.0);
      return;
    }
    if (game.state != GameStatus.Racing) return;

    if (vehicle.sensorCollision) {
      _vehicleControl.controlAvoidance(vehicle);
    } else {
      if (game.gamelevelType == GameLevelType.Checkpoint) {
        var target = game.level.trackPoint(player.trackProgress.currentIndex);
        if (vehicle.position.distanceToThis(target.vector) < target.width / 2) player.trackProgress.next();
        _vehicleControl.controlToTarget(vehicle, target.vector);
      }
    }
  }
}
