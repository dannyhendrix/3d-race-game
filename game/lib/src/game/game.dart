part of micromachines;

class Game{
  List<GameObject> gameobjects = [];
  List<MoveableGameObject> _movableGameObjects = [];
  Player player;
  String info = "";
  Game(){
    player = new Player();
  }
  void init(){
    player.init(this);
  }
  void start(){
    Vehicle vehicle = new Vehicle(this);
    player.start(vehicle);
    gameobjects.add(vehicle);
    //gameobjects.add(new Wall(0.0,0.0,1500,800));
    gameobjects.add(new Wall.zeroOnLeftTop(0.0,0.0,1500.0,5.0));
    gameobjects.add(new Wall.zeroOnLeftTop(0.0,800.0-5,1500.0,5.0));
    gameobjects.add(new Wall.zeroOnLeftTop(0.0,0.0,5.0,800.0));
    gameobjects.add(new Wall.zeroOnLeftTop(1500.0-5,0.0,5.0,800.0));
    gameobjects.add(new Wall(500.0, 200.0, 100.0, 20.0, 1.0));
    gameobjects.add(new Wall(700.0, 600.0, 60.0, 20.0, 0.3));
    _movableGameObjects.add(vehicle);
  }

  void update(){
    for(MoveableGameObject o in _movableGameObjects){
      o.update();
    }
  }
}