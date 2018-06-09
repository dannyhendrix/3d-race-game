part of micromachines;

enum GameState {Initialized, Running, Countdown, Racing, Finished}

class Game{
  List<GameObject> gameobjects = [];
  List<MoveableGameObject> _movableGameObjects = [];
  List<Player> players;
  HumanPlayer humanPlayer;
  String info = "";
  Path path;

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
        player = new HumanPlayer(p.name, t.vehicleTheme);
        humanPlayer = player;
      }else{
        player = new AiPlayer(p.name, t.vehicleTheme);
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

      if(p.trailer != TrailerType.None){
        Trailer t;
        if(p.trailer == TrailerType.TruckTrailer)
          t = new TruckTrailer(v);
        else
          t = new Caravan(v);
        gameobjects.add(t);
        _movableGameObjects.add(t);
      }else{
        new NullTrailer(v);
      }

      player.init(this,v, path);
    }
    _setStartingPositions(players, path);

    var ball = new Ball(this);
    _movableGameObjects.add(ball);
    gameobjects.add(ball);

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

    for(MoveableGameObject o in _movableGameObjects){
      o.resetCache();
    }
    for(Player p in players) p.update();
    for(MoveableGameObject o in _movableGameObjects){
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
      GamePlayerResult playerResult = new GamePlayerResult();
      playerResult.name = p.name;
      playerResult.playerId = p.playerId;
      playerResult.position = i;
      result.playerResults.add(playerResult);
    }
    return result;
  }

  void _loadLevel(GameLevel level){
    for(GameLevelWall wall in level.walls){
      gameobjects.add(new Wall(wall.x, wall.z, wall.w, wall.d, wall.r));
    }
    for(GameLevelStaticObject obj in level.staticobjects){
      gameobjects.add(new Tree(obj.x, obj.z, obj.r));
    }
    List<PathCheckPoint> checkpoints = [];

    for(int i = 0; i < level.path.checkpoints.length; i++){
      GameLevelCheckPoint c = level.path.checkpoints[i];
      checkpoints.add(new PathCheckPoint(c.x,c.z,c.radius));
    }

    for(int i = 1; i < checkpoints.length-1; i++){
      PathCheckPoint c = checkpoints[i];
      gameobjects.add(new CheckPoint(this,c,_getCheckpointAngle(c,checkpoints[i-1],checkpoints[i+1])));
    }
    //first checkpoint
    if(level.path.circular)
    {
      gameobjects.add(new CheckPoint(this, checkpoints[0], _getCheckpointAngle(checkpoints[0], checkpoints.last, checkpoints[1])));
      gameobjects.add(new CheckPoint(this, checkpoints.last, _getCheckpointAngle(checkpoints.last, checkpoints[checkpoints.length - 2], checkpoints[0])));
    }
    else{
      gameobjects.add(new CheckPoint(this, checkpoints[0], _getCheckpointAngleToNext(checkpoints[0], checkpoints[1])));
      gameobjects.add(new CheckPoint(this, checkpoints.last, _getCheckpointAngleToNext(checkpoints.last, checkpoints[0])));

    }
    path = new Path(checkpoints,level.path.circular, level.path.laps);
  }

  double _getCheckpointAngleToNext(PathCheckPoint c,PathCheckPoint cNext){
    return (cNext-c).angle;
  }
  double _getCheckpointAngle(PathCheckPoint c,PathCheckPoint cPrev,PathCheckPoint cNext){
    double angle = ((cPrev-c)+(c-cNext)).angle;
    angle += Math.pi/2;
    return angle;
  }

  void _setStartingPositions(List<Player> players, Path path){
    StartingPositions startingPositionsCreater = new StartingPositions();

    double vehicleLength = 0.0;
    double vehicleWidth = 0.0;

    for(Player p in players){
      Vehicle v = p.vehicle;
      vehicleWidth = Math.max(vehicleWidth, v.h);
      vehicleWidth = Math.max(vehicleWidth, v.trailer.h);
      vehicleLength = Math.max(vehicleLength, v.w-v.trailerSnapPoint.x+v.trailer.vehicleSnapPoint.x+v.trailer.w/2);
    }

    Point2d start = path.point(0);
    Point2d second = path.point(1);
    Point2d last = path.point(path.length-1);
    double angle = path.circular ? _getCheckpointAngle(start,second,last) : start.angleWith(second);
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
      player.vehicle.position = startingPositions[i].point;
      player.vehicle.r = startingPositions[i].r;
      player.vehicle.trailer.updateVehiclePosition();
      i++;
    }
  }
}