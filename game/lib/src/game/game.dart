part of micromachines;

class Game{
  List<GameObject> gameobjects = [];
  List<MoveableGameObject> _movableGameObjects = [];
  List<Player> players;
  String info = "";
  Game(){
    players = [new Player(),new Player()];
  }
  void init(){
    players.forEach((player) => player.init(this));
  }
  void start(){
    List<Point> startLocation = [new Point(100.0,100.0),new Point(500.0,500.0)];
    int i = 0;
    for(Player player in players){
      Vehicle v = new Vehicle(this,player);
      v.position = startLocation[i];
      player.start(v);
      gameobjects.add(v);
      _movableGameObjects.add(v);
      i++;
    }
    double wallD = 15.0;
    //gameobjects.add(new Wall(0.0,0.0,1500,800));
    gameobjects.add(new Wall.zeroOnLeftTop(0.0,0.0,1500.0,wallD));
    gameobjects.add(new Wall.zeroOnLeftTop(0.0,800.0-wallD,1500.0,wallD));
    gameobjects.add(new Wall.zeroOnLeftTop(0.0,0.0,wallD,800.0));
    gameobjects.add(new Wall.zeroOnLeftTop(1500.0-wallD,0.0,wallD,800.0));
    gameobjects.add(new Wall(500.0, 200.0, 100.0, 20.0, 1.0));
    gameobjects.add(new Wall(700.0, 600.0, 60.0, 20.0, 0.3));
    //gameobjects.add(new CheckPoint(this, 1100.0, 100.0, 0.3));
  }

  void update(){
    for(MoveableGameObject o in _movableGameObjects){
      o.update();
    }
  }
}