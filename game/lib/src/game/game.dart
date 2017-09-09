part of micromachines;

class Game{
  List<GameObject> gameobjects = [];
  List<MovableGameObject> _movableGameObjects = [];
  Player player;
  String info = "";
  Game(){
    player = new Player();
  }
  void init(){
    player.init(this);
  }
  void start(){
    Vechicle vehicle = new Vehicle();
    player.start(vehicle);
    gameobjects.add(vehicle);
    //gameobjects.add(new Wall(0.0,0.0,1500,800));
    gameobjects.add(new Wall.zeroOnLeftTop(0.0,0.0,1500,5));
    gameobjects.add(new Wall.zeroOnLeftTop(0.0,800.0-5,1500,5));
    gameobjects.add(new Wall.zeroOnLeftTop(0.0,0.0,5,800));
    gameobjects.add(new Wall.zeroOnLeftTop(1500.0-5,0.0,5,800));
    gameobjects.add(new Wall(500.0, 200.0, 100, 20, 1.0));
    _movableGameObjects.add(vehicle);
  }

  void update(){
    for(MovableGameObject o in _movableGameObjects){
      o.update();
      //Vector polygonATranslation = new Vector.empty();
      Vector polygonATranslation = o.vector;
      for(GameObject g in gameobjects){
        if(g == o) continue;


        CollisionResult r = o.createPolygonOnActualLocation().collision(g.createPolygonOnActualLocation(), o.vector);

        if (r.willIntersect) {
          // Move the polygon by its velocity, then move
          // the polygons appart using the Minimum Translation Vector
          polygonATranslation = o.vector + r.minimumTranslationVector;
          //o.onCollision(g);
        } else {
          // Just move the polygon by its velocity
          //polygonATranslation = o.vector;
        }

        //info = "${r.intersect} ${r.willIntersect}";
      }

      o.x+=polygonATranslation.x;
      o.y+=polygonATranslation.y;
    }
  }
}