part of micromachines;

enum GameState {Initialized, Running, Countdown, Racing, Finished}

Map leveljson = {"w":2400,"d":1280,"walls":[{"x":1200.0,"z":8.0,"r":0.0,"w":2400.0,"d":16.0,"h":16.0},{"x":1200.0,"z":1272.0,"r":0.0,"w":480.0,"d":16.0,"h":16.0},{"x":8.0,"z":768.0,"r":0.0,"w":16.0,"d":960.0,"h":16.0},{"x":2392.0,"z":640.0,"r":0.0,"w":16.0,"d":1248.0,"h":16.0},{"x":1184.0,"z":344.0,"r":0.0,"w":1280.0,"d":16.0,"h":16.0},{"x":1856.0,"z":576.0,"r":1.4,"w":480.0,"d":16.0,"h":16.0},{"x":512.0,"z":576.0,"r":1.7,"w":480.0,"d":16.0,"h":16.0},{"x":1168.0,"z":992.0,"r":1.6,"w":560.0,"d":16.0,"h":16.0}],"staticobjects":[{"id":0,"x":70.0,"z":80.0,"r":0.5},{"id":0,"x":40.0,"z":150.0,"r":0.2},{"id":0,"x":30.0,"z":250.0,"r":0.8},{"id":0,"x":780.0,"z":500.0,"r":0.2},{"id":0,"x":850.0,"z":450.0,"r":0.1},{"id":0,"x":680.0,"z":510.0,"r":0.0},{"id":0,"x":1500.0,"z":500.0,"r":0.0},{"id":0,"x":1600.0,"z":560.0,"r":0.2},{"id":0,"x":1650.0,"z":800.0,"r":0.6},{"id":0,"x":1400.0,"z":1200.0,"r":0.2},{"id":0,"x":1260.0,"z":1100.0,"r":0.5}],"path":{"circular":true,"laps":5,"checkpoints":[{"x":944.0,"z":176.0,"radius":160.0},{"x":2080.0,"z":160.0,"radius":160.0},{"x":2080.0,"z":1024.0,"radius":160.0},{"x":1520.0,"z":1008.0,"radius":160.0},{"x":1200.0,"z":496.0,"radius":96.0},{"x":752.0,"z":960.0,"radius":160.0},{"x":288.0,"z":1040.0,"radius":160.0},{"x":304.0,"z":576.0,"radius":160.0},{"x":304.0,"z":176.0,"radius":160.0}]}};
class Game{
  List<GameObject> gameobjects = [];
  List<MoveableGameObject> _movableGameObjects = [];
  List<Player> players;
  HumanPlayer humanPlayer;
  String info = "";
  Path path;

  GameState state = GameState.Countdown;
  Countdown countdown;

  Game(){
  }


  void initSession(GameSettings gameSettings){
    gameSettings.validate();
    // 1. load level
    _loadLevel(gameSettings.level);

    // 2. load players
    players = [];
    for(var p in gameSettings.players){
      Player player;
      if(p.isHuman){
        player = new HumanPlayer(p.name, p.vehicleTheme);
        humanPlayer = player;
      }else{
        player = new AiPlayer(p.name, p.vehicleTheme);
      }
      players.add(player);

      Vehicle v = new Vehicle(this,player);
      gameobjects.add(v);
      _movableGameObjects.add(v);

      if(p.trailer != TrailerType.None){
        Trailer t = new CarTrailer(v);
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
    angle += Math.PI/2;
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