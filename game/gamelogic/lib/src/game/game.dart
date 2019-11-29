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
  List<Ball> _balls = [];
  List<Tree> trees = [];
  List<Wall> walls = [];
  List<CheckpointGameItem> checkpoints = [];
  List<CheckpointGatePost> checkpointPosts = [];

  List<Player> players;
  HumanPlayer humanPlayer;
  String info = "";
  GameLevelType gamelevelType;
  GameLevelController level;
  GameObjectCollisionHandler _collisionHandler;
  CollisionController _collisionController = new CollisionController(new GameMode(), new CollisionDetection());

  GameStatus state = GameStatus.Countdown;
  Countdown countdown;
  GameSettings settings;

  Game(ILifetime lifetime) {
    settings = lifetime.resolve();
    _collisionHandler = new GameObjectCollisionHandler();
  }

  void initSession(GameInput gameSettings) {
    gameSettings.validate();
    // 1. load level
    level = new GameLevelController(gameSettings.level.path);
    _loadLevel(gameSettings.level);

    // 2. load players
    players = [];
    for (var t in gameSettings.teams) {
      Player player;
      for (var p in t.players) {
        if (p.isHuman) {
          player = new HumanPlayer(p, t.vehicleTheme);
          humanPlayer = player;
        } else {
          player = new AiPlayer(p, t.vehicleTheme);
        }
        players.add(player);

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

        if (p.trailer != TrailerType.None) {
          Trailer t;
          if (p.trailer == TrailerType.TruckTrailer)
            t = new TruckTrailer(v);
          else
            t = new Caravan(v);
          trailers.add(t);
        } else {
          new NullTrailer(v);
        }

        player.init(this, v, gameSettings.level.path);
      }
    }
    if (gamelevelType == GameLevelType.Checkpoint) _setStartingPositions(players, gameSettings.level.path);
/*
    var ball = new Ball(this);
    _movableGameObjects.add(ball);
    gameobjects.add(ball);
*/
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
    _collisionController.handleCollisions2(trees, _balls);
    _collisionController.handleCollisions2(walls, _balls);
    _collisionController.handleCollisions2(checkpointPosts, _balls);
    _collisionController.handleCollisions(_balls);
    _collisionController.handleCollisions(vehicles);
    _collisionController.handleCollisions3(_balls, vehicles);
    _collisionController.handleCollisions3(trailers, vehicles);

    for (Player p in players) p.update();
    for (var o in _balls) _collisionHandler.update(o);
    //for (var o in vehicles) _collisionHandler.update(o);
    for (var o in vehicles) o.update();
    players.sort((Player a, Player b) {
      double ap = a.pathProgress.progress;
      double bp = b.pathProgress.progress;
      if (ap < bp) return 1;
      if (ap > bp) return -1;
      return 0;
    });
    if (players.every((p) => p.finished)) {
      state = GameStatus.Finished;
    }
  }

  GameOutput createGameResult() {
    //TODO: fill raceTimes
    GameOutput result = new GameOutput();
    result.playerResults = [];
    for (int i = 0; i < players.length; i++) {
      Player p = players[i];
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
      _balls.add(ball);
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

  void _setStartingPositions(List<Player> players, GameLevelPath path) {
    StartingPositions startingPositionsCreater = new StartingPositions();
    double vehicleLength = 0.0;
    double vehicleH = 0.0;

    for (Player p in players) {
      Vehicle v = p.vehicle;
      vehicleH = max(vehicleH, v.polygon.dimensions.y);
      vehicleH = max(vehicleH, v.trailer.polygon.dimensions.y);
      vehicleLength = max(vehicleLength, v.polygon.dimensions.x - v.trailerSnapPoint.x + v.trailer.vehicleSnapPoint.x + v.trailer.polygon.dimensions.x / 2);
    }

    List<StartingPosition> startingPositions = startingPositionsCreater.determineStartPositions(path.checkpoints[0].x, path.checkpoints[0].y, path.checkpoints[0].angle, path.checkpoints[0].width, vehicleLength, vehicleH, players.length);
    int i = 0;
    for (Player player in players) {
      var rdif = startingPositions[i].r - player.vehicle.r;
      var rpos = startingPositions[i].point - player.vehicle.position;
      player.vehicle.applyOffsetRotation(rpos, rdif);
      //player.vehicle.Teleport(rpos,0.0);
      //player.vehicle.Teleport(new Vector(0.0,0.0), rdif);
      //player.vehicle.TelePort(startingPositions[i].point.x,startingPositions[i].point.y);
      player.vehicle.trailer.updateVehiclePosition();
      i++;
    }
  }
}
