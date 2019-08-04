part of game.definitions;

class GameLevelInvalidException implements Exception{
  final String msg;
  GameLevelInvalidException(this.msg);
  String toString() => "Exception: Invalid game settings: $msg";
}

abstract class GameLevelElement{
  void validate(){
  }
}


enum GameLevelType {Checkpoint, Score}

class GameLevel extends GameLevelElement{
  int w;
  int h;
  GameLevelType gameLevelType;
  GameLevelPath path;
  GameLevelScore score;
  List<GameLevelWall> walls;
  List<GameLevelStaticObject> staticobjects;

  GameLevel([this.w=800,this.h=500,this.gameLevelType=GameLevelType.Checkpoint,this.path=null, this.score=null,this.walls=null,this.staticobjects=null]){
    if(walls == null) walls = <GameLevelWall>[];
    if(staticobjects == null) staticobjects = <GameLevelStaticObject>[];
  }
  void validate(){
    walls.forEach((x) => x.validate());
    staticobjects.forEach((x) => x.validate());
    switch(gameLevelType){

      case GameLevelType.Checkpoint:
        if(path == null) throw new GameLevelInvalidException("GameType is Checkpoint but path is null");
        path.validate();
        break;
      case GameLevelType.Score:
        if(score == null) throw new GameLevelInvalidException("GameType is Score but score is null");
        score.validate();
        break;
    }
  }
}
class GameLevelScore extends GameLevelElement{
  List<GameLevelScoreTeam> teams;
  List<GameLevelBall> balls;
  GameLevelScore([this.teams = null, this.balls = null]){
    if(teams == null) teams = <GameLevelScoreTeam>[];
    if(balls == null) balls = <GameLevelBall>[];
  }
  void validate(){
    if(balls.length == 0) throw new GameLevelInvalidException("GameScore.balls has length 0");
    if(teams.length == 0) throw new GameLevelInvalidException("GameScore.teams has length 0");
    balls.forEach((x) => x.validate());
    teams.forEach((x) => x.validate());
  }
}
class GameLevelScoreTeam extends GameLevelElement{
  List<GameLevelGoal> goals;
  List<GameLevelStartArea> startPositions;
  GameLevelScoreTeam([this.goals=null, this.startPositions=null]){
    if(goals == null) goals = <GameLevelGoal>[];
    if(startPositions == null) startPositions = <GameLevelStartArea>[];
  }
  void validate(){
    if(goals.length == 0) throw new GameLevelInvalidException("GameScore.team.goals has length 0");
    if(startPositions.length == 0) throw new GameLevelInvalidException("GameScore.team.startPositions has length 0");
    goals.forEach((x) => x.validate());
    startPositions.forEach((x) => x.validate());
  }
}
class GameLevelStartArea extends GameLevelElement{
  double x,y,r;
  double radius;
  GameLevelStartArea([this.x=0.0,this.y=0.0,this.r=0.0, this.radius = 0.0]);
}
class GameLevelWall extends GameLevelElement{
  double x,y,r;
  double w,h,d;
  GameLevelWall([this.x=0.0,this.y=0.0,this.r=0.0, this.w = 1.0,this.h = 1.0,this.d = 1.0]);
}
class GameLevelGoal extends GameLevelElement{
  double x,y,r;
  double w,h,d;
  int team;
  GameLevelGoal([this.x=0.0,this.y=0.0,this.r=0.0, this.w = 1.0,this.h = 1.0,this.d = 1.0, this.team=0]);
}
class GameLevelBall extends GameLevelElement{
  double x,y,r;
  GameLevelBall([this.x=0.0,this.y=0.0,this.r=0.0]);
}
class GameLevelStaticObject extends GameLevelElement{
  int id;
  double x,y,r;
  GameLevelStaticObject([this.id = 0, this.x=0.0,this.y=0.0,this.r=0.0]);
}
class GameLevelCheckPoint extends GameLevelElement{
  double x,y;
  double width;
  double lengthBefore;
  double lengthAfter;
  double angle;
  GameLevelCheckPoint([this.x=0.0,this.y=0.0, this.width = 0.0, this.angle = 0.0, this.lengthBefore = 50.0, this.lengthAfter = 50.0]);
}
class GameLevelPath extends GameLevelElement{
  bool circular;
  int laps;
  List<GameLevelCheckPoint> checkpoints;
  GameLevelPath([this.circular=true,this.laps=3,this.checkpoints = null]){
    if(checkpoints == null) checkpoints = <GameLevelCheckPoint>[];
  }
  void validate(){
    if(checkpoints.length == 0) throw new GameLevelInvalidException("Path.Checkpoints has length 0");
    checkpoints.forEach((x) => x.validate());
  }
}

class GameLevelLoader{
  GameLevel loadLevelJson(Map json){
    var upgrader = new GameLevelUpgrader();
    json = upgrader.upgrade(json);
    var level = _parseLevel(json);
    level.validate();
    return level;
  }

  List<T> _parseList<T>(Map json, String name, T parse(Map map)) => json.containsKey(name) ? json[name].map<T>(parse).toList() : <T>[];
  T _parseObject<T>(Map json, String name, T parse(Map map), [T defaultValue = null]) => json.containsKey(name) ? parse(json[name]) : defaultValue;
  T _parse<T>(Map json, String name, T defaultValue) => json.containsKey(name) ? json[name] : defaultValue;

  GameLevel _parseLevel(dynamic m) => new GameLevel(
      _parse(m, "w", 0),
      _parse(m, "h", 0),
      _parse(m, "type", "checkpoint") == "checkpoint" ? GameLevelType.Checkpoint : GameLevelType.Score,
      _parseObject(m, "path", _parsePath, new GameLevelPath()),
      _parseObject(m, "score", _parseGameLevelScore, new GameLevelScore()),
      _parseList(m, "walls",_parseWall),
      _parseList(m, "staticobjects",_parseStaticObject));
  GameLevelPath _parsePath(dynamic m) => new GameLevelPath(
      _parse(m, "circular", false),
      _parse(m, "laps", 3),
      _parseList(m, "checkpoints", _parseCheckpoint));
  GameLevelCheckPoint _parseCheckpoint(dynamic m)=> new GameLevelCheckPoint(
      _parse(m, "x", 0.0),
      _parse(m, "y", 0.0),
      _parse(m, "width", 20.0),
      _parse(m, "angle", 0.0),
      _parse(m, "lengthBefore", 20.0),
      _parse(m, "lengthAfter", 20.0)
  );
  GameLevelScore _parseGameLevelScore(dynamic m)=> new GameLevelScore(
      _parseList(m, "teams", _parseGameLevelScoreTeam),
      _parseList(m, "balls", _parseBall));
  GameLevelScoreTeam _parseGameLevelScoreTeam(dynamic m)=> new GameLevelScoreTeam(
      _parseList(m, "goals", _parseGoal),
      _parseList(m, "startingareas", _parseGameLevelStartArea));
  GameLevelStartArea _parseGameLevelStartArea(dynamic m)=> new GameLevelStartArea(
      _parse(m, "x", 0.0),
      _parse(m, "y", 0.0),
      _parse(m, "r", 0.0),
      _parse(m, "radius", 0.0));
  GameLevelWall _parseWall(dynamic m)=> new GameLevelWall(
      _parse(m, "x", 0.0),
      _parse(m, "y", 0.0),
      _parse(m, "r", 0.0),
      _parse(m, "w", 0.0),
      _parse(m, "h", 0.0),
      _parse(m, "d", 0.0));
  GameLevelGoal _parseGoal(dynamic m)=> new GameLevelGoal(
      _parse(m, "x", 0.0),
      _parse(m, "y", 0.0),
      _parse(m, "r", 0.0),
      _parse(m, "w", 0.0),
      _parse(m, "h", 0.0),
      _parse(m, "d", 0.0));
  GameLevelBall _parseBall(dynamic m)=> new GameLevelBall(
      _parse(m, "x", 0.0),
      _parse(m, "y", 0.0),
      _parse(m, "r", 0.0));
  GameLevelStaticObject _parseStaticObject(dynamic m)=> new GameLevelStaticObject(
      _parse(m, "id", 0),
      _parse(m, "x", 0.0),
      _parse(m, "y", 0.0),
      _parse(m, "r", 0.0));
}
class GameLevelSaver{
  Map levelToJson(GameLevel level){
    return _parseLevel(level);
  }
  Map _parseLevel(GameLevel level){
    var type = level.gameLevelType == GameLevelType.Score ? "score" : "checkpoint";
    return {
      "w":level.w,
      "h":level.h,
      "type": type,
      "walls" : level.walls.map(_parseWall).toList(),
      "staticobjects" : level.staticobjects.map(_parseStaticObject).toList(),
      "path" : _parsePath(level.path),
      "score" : _parseScore(level.score),
    };
  }
  Map _parsePath(GameLevelPath object){
    return object == null ? {} : {
      "circular" : object.circular,
      "laps" : object.laps,
      "checkpoints" : object.checkpoints.map(_parseCheckPoint).toList()
    };
  }
  Map _parseCheckPoint(GameLevelCheckPoint object){
    return {"x":object.x,"y":object.y, "width":object.width,"angle":object.angle,"lengthBefore":object.lengthBefore,"lengthAfter":object.lengthAfter};
  }
  Map _parseScore(GameLevelScore object){
    return object == null ? {} : {
      "balls" : object.balls.map(_parseBall).toList(),
      "teams" : object.teams.map(_parseScoreTeam).toList(),
    };
  }
  Map _parseScoreTeam(GameLevelScoreTeam object){
    return {
      "goals" : object.goals.map(_parseGoal).toList(),
      "startingareas" : object.startPositions.map(_parseStartArea).toList()
    };
  }
  Map _parseStartArea(GameLevelStartArea object){
    return {
      "x":object.x,"y":object.y, "r":object.r,
      "radius":object.radius
    };
  }
  Map _parseWall(GameLevelWall object){
    return {
      "x":object.x,"y":object.y, "r":object.r,
      "w":object.w, "h":object.h,"d":object.d
    };
  }
  Map _parseGoal(GameLevelGoal object){
    return {
      "x":object.x,"y":object.y, "r":object.r,
      "w":object.w, "h":object.h, "d":object.d
    };
  }
  Map _parseBall(GameLevelBall object){
    return {
      "x":object.x,"y":object.y, "r":object.r
    };
  }
  Map _parseStaticObject(GameLevelStaticObject object){
    return {
      "id":object.id,
      "x":object.x,"y":object.y, "r":object.r,
    };
  }
}