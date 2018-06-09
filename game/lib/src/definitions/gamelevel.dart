part of game.definitions;

class GameLevelInvalidException implements Exception{
  final String msg;
  GameLevelInvalidException(this.msg);
  String toString() => "Exception: Invalid game settings: $msg";
}

abstract class GameLevelElement{
}
class GameLevel extends GameLevelElement{
  int w = 800;
  int d = 500;
  GameLevelPath path = new GameLevelPath();
  List<GameLevelWall> walls = <GameLevelWall>[];
  List<GameLevelStaticObject> staticobjects = <GameLevelStaticObject>[];

  void validate(){} // TODO: validate level
}
class GameLevelWall extends GameLevelElement{
  double x,z,r;
  double w,d,h;
  GameLevelWall([this.x=0.0,this.z=0.0,this.r=0.0, this.w = 1.0,this.d = 1.0,this.h = 1.0]);
}
class GameLevelStaticObject extends GameLevelElement{
  int id;
  double x,z,r;
  GameLevelStaticObject([this.id = 0, this.x=0.0,this.z=0.0,this.r=0.0]);
}
class GameLevelCheckPoint extends GameLevelElement{
  double x,z;
  double radius;
  GameLevelCheckPoint([this.x=0.0,this.z=0.0, this.radius = 0.0]);
}
class GameLevelPath extends GameLevelElement{
  bool circular = false;
  int laps = -1;
  List<GameLevelCheckPoint> checkpoints = <GameLevelCheckPoint>[];
}

class GameLevelLoader{
  GameLevel loadLevelJson(Map json){
    GameLevel level = new GameLevel();
    level.w = json["w"];
    level.d = json["d"];
    level.path.circular = json["path"]["circular"];
    level.path.laps = json["path"]["laps"];
    level.path.checkpoints = json["path"]["checkpoints"].map<GameLevelCheckPoint>((Map m)=>new GameLevelCheckPoint(m["x"],m["z"],m["radius"])).toList();
    if(json.containsKey("walls")) level.walls = json["walls"].map<GameLevelWall>((Map m)=>new GameLevelWall(m["x"],m["z"],m["r"],m["w"],m["d"],m["h"])).toList();
    if(json.containsKey("staticobjects")) level.staticobjects = json["staticobjects"].map<GameLevelStaticObject>((Map m)=>new GameLevelStaticObject(m["id"],m["x"],m["z"],m["r"])).toList();
    return level;
  }
}
class GameLevelSaver{
  Map levelToJson(GameLevel level){
    return _parseLevel(level);
  }
  Map _parseLevel(GameLevel level){
    return {
      "w":level.w,
      "d":level.d,
      "walls" : level.walls.map((GameLevelWall o) => _parseWall(o)).toList(),
      "staticobjects" : level.staticobjects.map((GameLevelStaticObject o) => _parseStaticObject(o)).toList(),
      "path" : _parsePath(level.path)
    };
  }
  Map _parsePath(GameLevelPath path){
    return {
      "circular" : path.circular,
      "laps" : path.laps,
      "checkpoints" : path.checkpoints.map((GameLevelCheckPoint o) => _parseCheckPoint(o)).toList()
    };
  }
  Map _parseCheckPoint(GameLevelCheckPoint checkpoint){
    return {"x":checkpoint.x,"z":checkpoint.z, "radius":checkpoint.radius};
  }
  Map _parseWall(GameLevelWall wall){
    return {
      "x":wall.x,"z":wall.z, "r":wall.r,
      "w":wall.w,"d":wall.d, "h":wall.h,
    };
  }
  Map _parseStaticObject(GameLevelStaticObject object){
    return {
      "id":object.id,
      "x":object.x,"z":object.z, "r":object.r,
    };
  }
}