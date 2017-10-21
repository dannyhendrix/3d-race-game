part of micromachines;

Map leveljson ={"w":1500,"d":800,"walls":[{"x":750.0,"z":5.0,"r":0.0,"w":1500.0,"d":10.0,"h":10.0},{"x":750.0,"z":795.0,"r":0.0,"w":300.0,"d":10.0,"h":10.0},{"x":5.0,"z":400.0,"r":0.0,"w":10.0,"d":780.0,"h":10.0},{"x":1495.0,"z":400.0,"r":0.0,"w":10.0,"d":780.0,"h":10.0},{"x":740.0,"z":215.0,"r":0.0,"w":800.0,"d":10.0,"h":10.0},{"x":1160.0,"z":360.0,"r":1.4,"w":300.0,"d":10.0,"h":10.0},{"x":320.0,"z":360.0,"r":1.7,"w":300.0,"d":10.0,"h":10.0},{"x":730.0,"z":620.0,"r":1.6,"w":350.0,"d":10.0,"h":10.0}],"path":{"circular":true,"laps":-1,"checkpoints":[{"x":190.0,"z":110.0,"radius":100.0},{"x":1300.0,"z":100.0,"radius":100.0},{"x":1300.0,"z":640.0,"radius":100.0},{"x":950.0,"z":630.0,"radius":100.0},{"x":750.0,"z":310.0,"radius":60.0},{"x":470.0,"z":600.0,"radius":100.0},{"x":180.0,"z":650.0,"radius":100.0}]}};
class Game{
  List<GameObject> gameobjects = [];
  List<MoveableGameObject> _movableGameObjects = [];
  List<Player> players;
  HumanPlayer humanPlayer;
  String info = "";
  Path path;
  Game(){
    humanPlayer = new HumanPlayer("Player1", new VehicleTheme(VehicleThemeColor.Yellow,VehicleThemeColor.Blue));
    players = [
      humanPlayer,
      new AiPlayer("Tom", new VehicleTheme(VehicleThemeColor.Red,VehicleThemeColor.White)),
      new AiPlayer("Jake", new VehicleTheme(VehicleThemeColor.Blue,VehicleThemeColor.Blue)),
      new AiPlayer("Rose", new VehicleTheme(VehicleThemeColor.Pink,VehicleThemeColor.White)),
      new AiPlayer("Marie", new VehicleTheme(VehicleThemeColor.Black,VehicleThemeColor.Green)),
      new AiPlayer("Adam", new VehicleTheme(VehicleThemeColor.Orange,VehicleThemeColor.Orange))];
  }
  void init(){
    //"load" level
    path = new Path([
      new PathCheckPoint(200.0,200.0),
      new PathCheckPoint(400.0,200.0),
      new PathCheckPoint(650.0,350.0),
      new PathCheckPoint(600.0,600.0),
      new PathCheckPoint(300.0,450.0),
      new PathCheckPoint(200.0,600.0)
    ],true);

    players.forEach((player) => player.init(this));
  }
  void start(){
    LevelLoader levelLoader = new LevelLoader();
    levelLoader.loadLevelJson(this, leveljson);

    List<Point> startLocation = [new Point(80.0,100.0),new Point(80.0,160.0),new Point(120.0,100.0),new Point(120.0,160.0),new Point(160.0,100.0),new Point(160.0,160.0)];
    int i = 0;
    for(Player player in players){
      Vehicle v = new Vehicle(this,player);
      v.position = startLocation[i];
      player.start(v, path);
      gameobjects.add(v);
      _movableGameObjects.add(v);
      i++;
    }
    print(_movableGameObjects.length);
    var ball = new Ball(this);
    _movableGameObjects.add(ball);
    gameobjects.add(ball);
    //gameobjects.add(new CheckPoint(this, 1100.0, 100.0, 0.3));
  }

  void update(){
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
}