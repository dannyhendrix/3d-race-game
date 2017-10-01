part of micromachines;

abstract class GameLevelElement{
}
class GameLevel extends GameLevelElement{
  List<GameLevelWall> walls = [];
  GameLevelPath path = new GameLevelPath();
  int w = 800;
  int d = 500;
}
class GameLevelWall extends GameLevelElement{
  double x,z,r;
  double w,d,h;
  GameLevelWall([this.x=0.0,this.z=0.0,this.r=0.0, this.w = 1.0,this.d = 1.0,this.h = 1.0]);
}
class GameLevelCheckPoint extends GameLevelElement{
  double x,z;
  double radius;
  GameLevelCheckPoint([this.x=0.0,this.z=0.0, this.radius = 0.0]);
}
class GameLevelPath extends GameLevelElement{
  bool circular = false;
  int laps = -1;
  List<GameLevelCheckPoint> checkpoints = [];
}

class LevelLoader{
  void loadLevelJson(Game game, Map json){
    GameLevel level = new GameLevel();
    level.w = json["w"];
    level.d = json["d"];
    level.path.circular = json["path"]["circular"];
    level.path.laps = json["path"]["laps"];
    level.path.checkpoints = json["path"]["checkpoints"].map((Map m)=>new GameLevelCheckPoint(m["x"],m["z"],m["radius"])).toList();
    level.walls = json["walls"].map((Map m)=>new GameLevelWall(m["x"],m["z"],m["r"],m["w"],m["d"],m["h"])).toList();
    loadLevel(game, level);
  }
  void loadLevel(Game game, GameLevel level){
    for(GameLevelWall wall in level.walls){
      game.gameobjects.add(new Wall(wall.x, wall.z, wall.w, wall.d, wall.r));
    }
    List<PathCheckPoint> checkpoints = [];
    for(GameLevelCheckPoint c in level.path.checkpoints){
      checkpoints.add(new PathCheckPoint(c.x,c.z,c.radius));
    }
    game.path = new Path(checkpoints,level.path.circular, level.path.laps);
  }
}