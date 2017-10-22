part of micromachines;

enum GameState {Initialized, Running, Countdown, Racing, Finished}

Map leveljson ={"w":1500,"d":800,"walls":[{"x":750.0,"z":5.0,"r":0.0,"w":1500.0,"d":10.0,"h":10.0},{"x":750.0,"z":795.0,"r":0.0,"w":300.0,"d":10.0,"h":10.0},{"x":5.0,"z":480.0,"r":0.0,"w":10.0,"d":600.0,"h":10.0},{"x":1495.0,"z":400.0,"r":0.0,"w":10.0,"d":780.0,"h":10.0},{"x":740.0,"z":215.0,"r":0.0,"w":800.0,"d":10.0,"h":10.0},{"x":1160.0,"z":360.0,"r":1.4,"w":300.0,"d":10.0,"h":10.0},{"x":320.0,"z":360.0,"r":1.7,"w":300.0,"d":10.0,"h":10.0},{"x":730.0,"z":620.0,"r":1.6,"w":350.0,"d":10.0,"h":10.0}],"path":{"circular":true,"laps":5,"checkpoints":[{"x":190.0,"z":110.0,"radius":100.0},{"x":1300.0,"z":100.0,"radius":100.0},{"x":1300.0,"z":640.0,"radius":100.0},{"x":950.0,"z":630.0,"radius":100.0},{"x":750.0,"z":310.0,"radius":60.0},{"x":470.0,"z":600.0,"radius":100.0},{"x":180.0,"z":650.0,"radius":100.0}]}};

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
    double totalLength = v.w+v.trailerSnapPoint.x+v.trailer.vehicleSnapPoint.x+v.trailer.w/2;
    double totalWidth = v.h;
    List<StartingPosition> startingPositions = startingPositionsCreater.DetermineStartPositions(path.point(0),path.point(0),players.length,totalLength,totalWidth,15.0,15.0,path.point(0).radius*2);
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
    return ((cPrev-c)+(cNext-c)).angle;
  }
}