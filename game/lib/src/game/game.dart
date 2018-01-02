part of micromachines;

enum GameState {Initialized, Running, Countdown, Racing, Finished}

Map leveljson = {"w":2400,"d":1280,"walls":[{"x":1200.0,"z":8.0,"r":0.0,"w":2400.0,"d":16.0,"h":16.0},{"x":1200.0,"z":1272.0,"r":0.0,"w":480.0,"d":16.0,"h":16.0},{"x":8.0,"z":768.0,"r":0.0,"w":16.0,"d":960.0,"h":16.0},{"x":2392.0,"z":640.0,"r":0.0,"w":16.0,"d":1248.0,"h":16.0},{"x":1184.0,"z":344.0,"r":0.0,"w":1280.0,"d":16.0,"h":16.0},{"x":1856.0,"z":576.0,"r":1.4,"w":480.0,"d":16.0,"h":16.0},{"x":512.0,"z":576.0,"r":1.7,"w":480.0,"d":16.0,"h":16.0},{"x":1168.0,"z":992.0,"r":1.6,"w":560.0,"d":16.0,"h":16.0}],"staticobjects":[{"id":0,"x":70.0,"z":80.0,"r":0.5},{"id":0,"x":40.0,"z":150.0,"r":0.2},{"id":0,"x":30.0,"z":250.0,"r":0.8}],"path":{"circular":true,"laps":5,"checkpoints":[{"x":944.0,"z":176.0,"radius":160.0},{"x":2080.0,"z":160.0,"radius":160.0},{"x":2080.0,"z":1024.0,"radius":160.0},{"x":1520.0,"z":1008.0,"radius":160.0},{"x":1200.0,"z":496.0,"radius":96.0},{"x":752.0,"z":960.0,"radius":160.0},{"x":288.0,"z":1040.0,"radius":160.0},{"x":304.0,"z":576.0,"radius":160.0},{"x":304.0,"z":176.0,"radius":160.0}]}};

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
    humanPlayer = new HumanPlayer("Player1", new VehicleTheme(VehicleThemeColor.Yellow,VehicleThemeColor.Blue));
    players = [
      humanPlayer,
      new AiPlayer("Tom", new VehicleTheme(VehicleThemeColor.Red,VehicleThemeColor.White)),
      new AiPlayer("Jake", new VehicleTheme(VehicleThemeColor.Blue,VehicleThemeColor.Blue)),
      new AiPlayer("Rose", new VehicleTheme(VehicleThemeColor.Pink,VehicleThemeColor.White)),
      new AiPlayer("Marie", new VehicleTheme(VehicleThemeColor.Black,VehicleThemeColor.Green)),
      new AiPlayer("Adam", new VehicleTheme(VehicleThemeColor.Orange,VehicleThemeColor.Orange)),
    ];
  }
  void init(){
    players.forEach((player) => player.init(this));
  }
  void start(){
    GameLevelLoader levelLoader = new GameLevelLoader();
    GameLevel level = levelLoader.loadLevelJson(leveljson);
    _loadLevel(level);

    StartingPositions startingPositionsCreater = new StartingPositions();

    for(Player player in players){
      Vehicle v = new Vehicle(this,player);
      player.start(v, path);
      gameobjects.add(v);
      _movableGameObjects.add(v);

      Trailer t = new Trailer(v);
      gameobjects.add(t);
      _movableGameObjects.add(t);
    }
    Vehicle v = players.first.vehicle;
    double totalLength = v.w-v.trailerSnapPoint.x+v.trailer.vehicleSnapPoint.x+v.trailer.w/2;
    double totalWidth = v.h;
    Point2d start = path.point(0);
    Point2d second = path.point(1);
    Point2d last = path.point(path.length-1);
    double angle = level.path.circular ? _getCheckpointAngle(start,second,last) : start.angleWith(second);
    List<StartingPosition> startingPositions = startingPositionsCreater.DetermineStartPositions(
        path.point(0),
        angle,
        players.length,
        totalLength,
        totalWidth,
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
    var ball = new Ball(this);
    _movableGameObjects.add(ball);
    gameobjects.add(ball);
    //gameobjects.add(new CheckPoint(this, 1100.0, 100.0, 0.3));
    countdown = new Countdown((){
      state = GameState.Racing;
    });
    countdown.start();
  }

  void update(){
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
}