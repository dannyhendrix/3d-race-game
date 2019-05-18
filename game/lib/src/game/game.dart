part of micromachines;

enum GameState {Initialized, Running, Countdown, Racing, Finished}

class Game{
  List<GameItem> gameobjects = [];
  List<GameItemMovable> _movableGameObjects = [];
  List<Player> players;
  HumanPlayer humanPlayer;
  String info = "";
  GameLevelType gamelevelType;
  GameLevelController level;
  CollisionController _collisionController = new CollisionController(new GameMode());

  GameState state = GameState.Countdown;
  Countdown countdown;
  GameSettings settings;

  Game(settings){
  }


  void initSession(GameInput gameSettings){
    gameSettings.validate();
    // 1. load level
    level = new GameLevelController(gameSettings.level.path);
    _loadLevel(gameSettings.level);

    // 2. load players
    players = [];
    for(var t in gameSettings.teams){
      Player player;
      for(var p in t.players){
        if(p.isHuman){
          player = new HumanPlayer(p, t.vehicleTheme);
          humanPlayer = player;
        }else{
          player = new AiPlayer(p, t.vehicleTheme);
        }
        players.add(player);

        Vehicle v;
        if(p.vehicle == VehicleType.Truck)
          v = new Truck(this,player);
        else if(p.vehicle == VehicleType.Formula)
          v = new FormulaCar(this,player);
        else
          v = new Car(this,player);
        gameobjects.add(v);
        _movableGameObjects.add(v);
        _collisionController.register(v);

        if(p.trailer != TrailerType.None){
          Trailer t;
          if(p.trailer == TrailerType.TruckTrailer)
            t = new TruckTrailer(v);
          else
            t = new Caravan(v);
          gameobjects.add(t);
          _movableGameObjects.add(t);
          _collisionController.register(t);
        }else{
          new NullTrailer(v);
        }

        player.init(this,v, gameSettings.level.path);
      }
    }
    if(gamelevelType == GameLevelType.Checkpoint)
      _setStartingPositions(players, gameSettings.level.path);
/*
    var ball = new Ball(this);
    _movableGameObjects.add(ball);
    gameobjects.add(ball);
*/
  }
  void startSession(){
    countdown = new Countdown((){
      state = GameState.Racing;
    });
    countdown.start();
  }

  void step(){
    if(!countdown.complete){
      countdown.tick();
    }
    _collisionController.handleCollisions();
    for(Player p in players) p.update();
    for(var o in _movableGameObjects){
      o.update();
    }
    players.sort((Player a, Player b){
      double ap = a.pathProgress.progress;
      double bp = b.pathProgress.progress;
      if(ap < bp) return 1;
      if(ap > bp) return -1;
      return 0;
    });
    if(players.every((p)=>p.finished)){
      state = GameState.Finished;
    }
  }

  GameOutput createGameResult(){
    //TODO: fill raceTimes
    GameOutput result = new GameOutput();
    result.playerResults = [];
    for(int i = 0; i < players.length; i++){
      Player p = players[i];
      GamePlayerResult playerResult = new GamePlayerResult(p.player);
      playerResult.position = i;
      result.playerResults.add(playerResult);
    }
    return result;
  }

  void _loadLevel(GameLevel level){
    gamelevelType = level.gameLevelType;
    for(var obj in level.walls){
      var wall = new Wall(obj.x, obj.z, obj.w, obj.d, obj.r);
      gameobjects.add(wall);
      _collisionController.register(wall);
    }
    for(var obj in level.staticobjects){
      var tree = new Tree(obj.x, obj.z, obj.r);
      gameobjects.add(tree);
      _collisionController.register(tree);
    }
    /*
    for(var obj in level.balls){
      var ball = new Ball(obj.x, obj.z, obj.r);
      gameobjects.add(ball);
      _collisionController.register(ball);
      _movableGameObjects.add(ball);
    }
*/
    if(level.gameLevelType == GameLevelType.Checkpoint){
      for(var c in this.level.checkpoints){
        gameobjects.add(c);
        _collisionController.register(c);
        var leftpost = new CheckpointGatePost(c, true);
        var rightpost = new CheckpointGatePost(c, false);
        gameobjects.add(leftpost);
        _collisionController.register(leftpost);
        gameobjects.add(rightpost);
        _collisionController.register(rightpost);
      }
    }
  }


  void _setStartingPositions(List<Player> players, GameLevelPath path){
    StartingPositions startingPositionsCreater = new StartingPositions();

    double vehicleLength = 0.0;
    double vehicleWidth = 0.0;

    for(Player p in players){
      Vehicle v = p.vehicle;
      vehicleWidth = Math.max(vehicleWidth, v.polygon.dimensions.y);
      vehicleWidth = Math.max(vehicleWidth, v.trailer.polygon.dimensions.y);
      vehicleLength = Math.max(vehicleLength, v.polygon.dimensions.x-v.trailerSnapPoint.x+v.trailer.vehicleSnapPoint.x+v.trailer.polygon.dimensions.x/2);
    }

    List<StartingPosition> startingPositions = startingPositionsCreater.DetermineStartPositions(
        level.checkpoints[0].position,
        level.checkpoints[0].r,
        players.length,
        vehicleLength,
        vehicleWidth,
        30.0,
        60.0,
        path.checkpoints[0].radius*2
    );
    int i = 0;
    for(Player player in players){
      var rdif = startingPositions[i].r - player.vehicle.r;
      player.vehicle.Teleport(startingPositions[i].point, rdif);
      player.vehicle.trailer.updateVehiclePosition();
      i++;
    }
  }
}