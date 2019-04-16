part of micromachines;

enum GameState {Initialized, Running, Countdown, Racing, Finished}

class Game{
  List<GameItem> gameobjects = [];
  List<GameItemMovable> _movableGameObjects = [];
  List<Player> players;
  HumanPlayer humanPlayer;
  String info = "";
  Path path;
  CollisionController _collisionController = new CollisionController();

  GameState state = GameState.Countdown;
  Countdown countdown;
  GameSettings settings;

  Game(settings){
  }


  void initSession(GameInput gameSettings){
    gameSettings.validate();
    // 1. load level
    _loadLevel(gameSettings.level);

    // 2. load players
    players = [];
    for(var t in gameSettings.teams){
      Player player;
      var p = t.players[0];
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

      /*if(p.trailer != TrailerType.None){
        Trailer t;
        if(p.trailer == TrailerType.TruckTrailer)
          t = new TruckTrailer(v);
        else
          t = new Caravan(v);
        gameobjects.add(t);
        _movableGameObjects.add(t);
      }else{*/
        new NullTrailer(v);
      /*}*/

      player.init(this,v, path);
    }
    _setStartingPositions(players, path);
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
    for(GameLevelWall obj in level.walls){
      var wall = new Wall(obj.x, obj.z, obj.w, obj.d, obj.r);
      gameobjects.add(wall);
      _collisionController.register(wall);
    }
    for(GameLevelStaticObject obj in level.staticobjects){
      var tree = new Tree(obj.x, obj.z, obj.r);
      gameobjects.add(tree);
      _collisionController.register(tree);
    }
    /*
    List<PathCheckPoint> checkpoints = [];

    for(int i = 0; i < level.path.checkpoints.length; i++){
      GameLevelCheckPoint c = level.path.checkpoints[i];
      checkpoints.add(new PathCheckPoint(c.x,c.z,c.radius));
    }*/

    path = new Path(level.path);

    for(int i = 1; i < path.checkpoints.length-1; i++){
      PathCheckPoint c = path.checkpoints[i];
      var checkpoint = new CheckPoint(this,c,_getCheckpointAngle(c,path.checkpoints[i-1],path.checkpoints[i+1]));
      gameobjects.add(checkpoint);
      _collisionController.register(checkpoint);
    }
    //first checkpoint
    if(level.path.circular)
    {
      var checkpoint = new CheckPoint(this, path.checkpoints[0], _getCheckpointAngle(path.checkpoints[0], path.checkpoints.last, path.checkpoints[1]),true);
      gameobjects.add(checkpoint);
      _collisionController.register(checkpoint);
      checkpoint = new CheckPoint(this, path.checkpoints.last, _getCheckpointAngle(path.checkpoints.last, path.checkpoints[path.checkpoints.length - 2], path.checkpoints[0]));
      gameobjects.add(checkpoint);
      _collisionController.register(checkpoint);
    }
    else{
      var checkpoint = new CheckPoint(this, path.checkpoints[0], _getCheckpointAngleToNext(path.checkpoints[0], path.checkpoints[1]), true);
      gameobjects.add(checkpoint);
      _collisionController.register(checkpoint);
      checkpoint = new CheckPoint(this, path.checkpoints.last, _getCheckpointAngleToNext(path.checkpoints.last, path.checkpoints[0]), true);
      gameobjects.add(checkpoint);
      _collisionController.register(checkpoint);
    }
  }

  double _getCheckpointAngleToNext(PathCheckPoint c,PathCheckPoint cNext){
    return (cNext-c).angleThis();
  }
  double _getCheckpointAngle(PathCheckPoint c,PathCheckPoint cPrev,PathCheckPoint cNext){
    double angle = ((cPrev-c)+(c-cNext)).angleThis();
    angle += Math.pi/2;
    return angle;
  }

  void _setStartingPositions(List<Player> players, Path path){
    StartingPositions startingPositionsCreater = new StartingPositions();

    double vehicleLength = 0.0;
    double vehicleWidth = 0.0;

    for(Player p in players){
      Vehicle v = p.vehicle;
      vehicleWidth = Math.max(vehicleWidth, v.polygon.dimensions.y);
      vehicleWidth = Math.max(vehicleWidth, v.trailer.polygon.dimensions.y);
      vehicleLength = Math.max(vehicleLength, v.polygon.dimensions.x-v.trailerSnapPoint.x+v.trailer.vehicleSnapPoint.x+v.trailer.polygon.dimensions.x/2);
    }

    var start = path.point(0);
    var second = path.point(1);
    var last = path.point(path.length-1);
    double angle = path.circular ? _getCheckpointAngle(start,second,last) : start.angleWithThis(second);
    List<StartingPosition> startingPositions = startingPositionsCreater.DetermineStartPositions(
        path.point(0),
        angle,
        players.length,
        vehicleLength,
        vehicleWidth,
        30.0,
        60.0,
        path.point(0).radius*2
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