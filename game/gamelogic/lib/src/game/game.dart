part of game;

enum GameStatus { Initialized, Running, Countdown, Racing, Finished }

class GameState {
  List<GameItem> gameobjects = [];
  List<GameItemMovable> movableGameObjects = [];
  List<Player> players;
  HumanPlayer humanPlayer;
  GameLevelType gamelevelType;
  GameLevelController level;
  GameStatus state = GameStatus.Countdown;
}

class Game {
  //List<GameItem> gameobjects = [];
  //List<GameItemStatic> _staticObjects = [];
  //List<GameItemMovable> _movableGameObjects = [];
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
  HumanPlayer get humanPlayer => playersHuman[0];
  String info = "";
  GameLevelType gamelevelType;
  GameLevelController level;
  GameObjectCollisionHandler _collisionHandler;
  VehicleControl _vehicleControl;
  TrailerControl _trailerControl;
  AiPlayerControl _aiPlayerControl;
  CollisionController _collisionController = new CollisionController(new GameMode(), new CollisionDetection());
  GameStandings _gameStandings;

  GameStatus state = GameStatus.Countdown;
  Countdown countdown;
  GameSettings settings;

  Game(ILifetime lifetime) {
    settings = lifetime.resolve();
    _collisionHandler = new GameObjectCollisionHandler();
    _vehicleControl = new VehicleControl();
    _trailerControl = new TrailerControl();
    _gameStandings = new GameStandings();
    _aiPlayerControl = new AiPlayerControl();
  }

  void initSession(GameInput gameSettings) {
    gameSettings.validate();
    // 1. load level
    level = new GameLevelController(gameSettings.level.path);
    _loadLevel(gameSettings.level);

    // 2. load players
    playersCpu = [];
    for (var team in gameSettings.teams) {
      Player player;
      for (var p in team.players) {
        PathProgress pathProgress;
        if (gamelevelType == GameLevelType.Checkpoint)
          pathProgress = new PathProgressCheckpoint(gameSettings.level.path.checkpoints.length, gameSettings.level.path.laps, gameSettings.level.path.circular);
        else
          pathProgress = new PathProgressScore();
        if (p.isHuman) {
          player = new HumanPlayer(p, team.vehicleTheme, pathProgress);
          playersHuman.add(player);
        } else {
          player = new AiPlayer(p, team.vehicleTheme, pathProgress, new TrackProgress(level.trackLength()));
          playersCpu.add(player);
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
        vehicles.add(v);

        Trailer trailer;
        if (p.trailer == TrailerType.None)
          trailer = new NullTrailer();
        else if (p.trailer == TrailerType.TruckTrailer)
          trailer = new TruckTrailer();
        else
          trailer = new Caravan();
        trailers.add(trailer);
        _trailerControl.connectToVehicle(trailer, v);
        player.vehicle = v;
      }
    }
    if (gamelevelType == GameLevelType.Checkpoint) playerRanking = _setStartingPositions(playersHuman, playersCpu, gameSettings.level.path);
  }

  void startSession() {
    countdown = new Countdown(() {
      state = GameStatus.Racing;
    });
    countdown.start();
  }

  void step() {
    if (!countdown.complete) {
      countdown.tick();
    }

    _collisionController.handleCollisions2(trees, vehicles);
    _collisionController.handleCollisions2(walls, vehicles);
    _collisionController.handleCollisions2(checkpointPosts, vehicles);
    _collisionController.handleCollisions2(checkpoints, vehicles);
    _collisionController.handleCollisions2(trees, balls);
    _collisionController.handleCollisions2(walls, balls);
    _collisionController.handleCollisions2(checkpointPosts, balls);
    _collisionController.handleCollisions(balls);
    _collisionController.handleCollisions(vehicles);
    _collisionController.handleCollisions3(balls, vehicles);
    _collisionController.handleCollisions3(trailers, vehicles);

    for (AiPlayer p in playersCpu) _aiPlayerControl.update(this, p.vehicle, p);
    for (var o in balls) _collisionHandler.update(o);
    //for (var o in vehicles) _collisionHandler.update(o);
    for (var o in vehicles) _vehicleControl.update(o, this);
    for (var o in trailers) _trailerControl.update(o);
    if (playerRanking.last.pathProgress.finished) {
      state = GameStatus.Finished;
    }
  }

  GameOutput createGameResult() {
    //TODO: fill raceTimes
    GameOutput result = new GameOutput();
    result.playerResults = [];
    for (int i = 0; i < playerRanking.length; i++) {
      Player p = playerRanking[i];
      GamePlayerResult playerResult = new GamePlayerResult(p.player);
      playerResult.position = i;
      result.playerResults.add(playerResult);
    }
    return result;
  }

  void _loadLevel(GameLevel level) {
    gamelevelType = level.gameLevelType;
    for (var obj in level.walls) {
      var wall = new Wall(obj.x, obj.y, obj.w, obj.h, obj.r);
      walls.add(wall);
    }
    for (var obj in level.staticobjects) {
      var tree = new Tree(obj.x, obj.y, obj.r);
      trees.add(tree);
    }

    for (var obj in level.score.balls) {
      var ball = new Ball(obj.x, obj.y, obj.r);
      balls.add(ball);
    }

    if (level.gameLevelType == GameLevelType.Checkpoint) {
      for (var c in this.level.checkpoints) {
        checkpoints.add(c);
        var leftpost = new CheckpointGatePost(c, true);
        var rightpost = new CheckpointGatePost(c, false);
        checkpointPosts.add(leftpost);
        checkpointPosts.add(rightpost);
      }
    }
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
      i++;
    }
    for (var player in playersHuman) {
      var rdif = startingPositions[i].r - player.vehicle.r;
      var rpos = startingPositions[i].point - player.vehicle.position;
      player.vehicle.applyOffsetRotation(rpos, rdif);
      startRanking.add(player);
      i++;
    }
    for (var o in trailers) _trailerControl.connectToVehicle(o, o.vehicle);
    return startRanking;
  }

  void onControl(HumanPlayer player, Control control, bool active) => _vehicleControl.onControl(control, active, player, player.vehicle);
}
