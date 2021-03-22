part of game;

enum GameStatus { Initialized, Running, Countdown, Racing, Finished }

class GameState {
  List<Vehicle> vehicles = [];
  List<Trailer> trailers = [];
  List<Ball> balls = [];
  List<Tree> trees = [];
  List<Wall> walls = [];
  List<CheckpointGameItem> checkpoints = [];
  List<CheckpointGatePost> checkpointPosts = [];
  List<Player> playerRanking;
  List<AiPlayer> playersCpu = [];
  List<HumanPlayer> playersHuman = [];
  GameLevelType gamelevelType;
  GameLevelContainer level;
  GameStatus state = GameStatus.Countdown;
  Countdown countdown;
  HumanPlayer get humanPlayer => playersHuman[0];
}

class Game {
  GameObjectCollisionHandler _collisionHandler;
  VehicleControl _vehicleControl;
  TrailerControl _trailerControl;
  AiPlayerControl _aiPlayerControl;
  CollisionController _collisionController;
  GameStandings _gameStandings;
  GameLevelController _levelController;

  GameState state;
  GameSettings settings;

  Game(ILifetime lifetime) {
    settings = lifetime.resolve();
    _collisionHandler = new GameObjectCollisionHandler();
    _vehicleControl = new VehicleControl();
    _trailerControl = new TrailerControl();
    _gameStandings = new GameStandings();
    _aiPlayerControl = new AiPlayerControl();
    _levelController = new GameLevelController();
    //TODO: circular dep..
    _collisionController = new CollisionController(new GameMode(this), new CollisionDetection());
    state = new GameState();
  }

  void initSession(GameInput gameSettings) {
    gameSettings.validate();
    // 1. load level
    state.level = _levelController.createLevel(gameSettings.level.path);
    _levelController.loadLevel(gameSettings.level, state);

    // 2. load players
    state.playersCpu = [];
    for (var team in gameSettings.teams) {
      Player player;
      for (var p in team.players) {
        PathProgress pathProgress;
        if (state.gamelevelType == GameLevelType.Checkpoint)
          pathProgress = new PathProgressCheckpoint(gameSettings.level.path.checkpoints.length, gameSettings.level.path.laps, gameSettings.level.path.circular);
        else
          pathProgress = new PathProgressScore();
        if (p.isHuman) {
          player = new HumanPlayer(p, team.vehicleTheme, pathProgress);
          state.playersHuman.add(player);
        } else {
          player = new AiPlayer(p, team.vehicleTheme, pathProgress, new TrackProgress(state.level.trackLength()));
          state.playersCpu.add(player);
        }

        Vehicle v;
        switch (p.vehicle) {
          case VehicleType.Truck:
            v = new Truck(this, player);
            break;
          case VehicleType.Pickup:
            v = new PickupCar(this, player);
            break;
          case VehicleType.Formula:
            v = new FormulaCar(this, player);
            break;
          case VehicleType.Car:
            v = new Car(this, player);
            break;
        }
        state.vehicles.add(v);

        Trailer trailer;
        if (p.trailer == TrailerType.None)
          trailer = new NullTrailer();
        else if (p.trailer == TrailerType.TruckTrailer)
          trailer = new TruckTrailer();
        else
          trailer = new Caravan();
        state.trailers.add(trailer);
        _trailerControl.connectToVehicle(trailer, v);
        player.vehicle = v;
      }
    }
    if (state.gamelevelType == GameLevelType.Checkpoint) state.playerRanking = _setStartingPositions(state.playersHuman, state.playersCpu, gameSettings.level.path);

    for (var o in state.trailers) _trailerControl.connectToVehicle(o, o.vehicle);

    state.countdown = new Countdown(() {
      state.state = GameStatus.Racing;
    }, 60, gameSettings.startCountdown);
  }

  void startSession() {
    state.countdown.start();
  }

  void step() {
    if (!state.countdown.complete) {
      state.countdown.tick();
    }

    _collisionController.handleCollisions2(state.trees, state.vehicles);
    _collisionController.handleCollisions2(state.walls, state.vehicles);
    _collisionController.handleCollisions2(state.checkpointPosts, state.vehicles);
    _collisionController.handleCollisions2(state.checkpoints, state.vehicles);
    _collisionController.handleCollisions2(state.trees, state.balls);
    _collisionController.handleCollisions2(state.walls, state.balls);
    _collisionController.handleCollisions2(state.checkpointPosts, state.balls);
    _collisionController.handleCollisions(state.balls);
    _collisionController.handleCollisions(state.vehicles);
    _collisionController.handleCollisions3(state.balls, state.vehicles);
    _collisionController.handleCollisions3(state.trailers, state.vehicles);

    _vehicleControl.setControl(state.humanPlayer.controlState, state.humanPlayer.vehicle);

    for (AiPlayer p in state.playersCpu) _aiPlayerControl.update(state, p.vehicle, p);
    for (var o in state.balls) _collisionHandler.update(o);
    //for (var o in vehicles) _collisionHandler.update(o);
    for (var o in state.vehicles) _vehicleControl.update(o, state);
    for (var o in state.trailers) _trailerControl.update(o);
    if (state.gamelevelType == GameLevelType.Checkpoint && state.playerRanking.last.pathProgress.finished) {
      state.state = GameStatus.Finished;
    }
  }

  GameOutput createGameResult() {
    //TODO: fill raceTimes
    GameOutput result = new GameOutput();
    result.playerResults = [];
    for (int i = 0; i < state.playerRanking.length; i++) {
      Player p = state.playerRanking[i];
      GamePlayerResult playerResult = new GamePlayerResult(p.player);
      playerResult.position = i;
      result.playerResults.add(playerResult);
    }
    return result;
  }

  List<Player> _setStartingPositions(List<HumanPlayer> playersHuman, List<AiPlayer> playersAi, GameLevelPath path) {
    StartingPositions startingPositionsCreater = new StartingPositions();
    double vehicleLength = 0.0;
    double vehicleH = 0.0;

    for (var p in playersAi) {
      Vehicle v = p.vehicle;
      vehicleH = max(vehicleH, v.polygon.dimensions.y);
      vehicleH = max(vehicleH, v.trailer.polygon.dimensions.y);
      vehicleLength = max(vehicleLength, v.polygon.dimensions.x - v.trailerSnapPoint.x + v.trailer.vehicleSnapPoint.x + v.trailer.polygon.dimensions.x / 2);
    }
    for (var p in playersHuman) {
      Vehicle v = p.vehicle;
      vehicleH = max(vehicleH, v.polygon.dimensions.y);
      vehicleH = max(vehicleH, v.trailer.polygon.dimensions.y);
      vehicleLength = max(vehicleLength, v.polygon.dimensions.x - v.trailerSnapPoint.x + v.trailer.vehicleSnapPoint.x + v.trailer.polygon.dimensions.x / 2);
    }

    List<StartingPosition> startingPositions = startingPositionsCreater.determineStartPositions(path.checkpoints[0].x, path.checkpoints[0].y, path.checkpoints[0].angle, path.checkpoints[0].width, vehicleLength, vehicleH, playersHuman.length + playersAi.length);
    int i = 0;
    List<Player> startRanking = [];
    //human players start last
    for (var player in playersAi) {
      var rdif = startingPositions[i].r - player.vehicle.r;
      var rpos = startingPositions[i].point - player.vehicle.position;
      player.vehicle.applyOffsetRotation(rpos, rdif);
      startRanking.add(player);
      player.position = i;
      i++;
    }
    for (var player in playersHuman) {
      var rdif = startingPositions[i].r - player.vehicle.r;
      var rpos = startingPositions[i].point - player.vehicle.position;
      player.vehicle.applyOffsetRotation(rpos, rdif);
      startRanking.add(player);
      player.position = i;
      i++;
    }
    return startRanking;
  }

  void collectCheckPoint(Vehicle vehicle, CheckpointGameItem checkpoint) {
    if (vehicle.player.pathProgress.collect(checkpoint)) _gameStandings.collect(vehicle.player, state.playerRanking);
  }
}
