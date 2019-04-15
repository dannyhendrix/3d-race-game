part of micromachines;

class PathProgress{
  int round = 0;
  Path path;
  bool finished = false;
  int _index = 0;
  int _roundCompleted = 0;

  PathCheckPoint get current => path.point(_index);
  double get completedFactor => _roundCompleted.toDouble()/path.length.toDouble();
  double get progress => round*1.0 + completedFactor;

  PathProgress(this.path);

  void next(){
    if(finished) return;
    if(_index == 0){
      round++;
      _roundCompleted = 0;
      if(path.roundsToFinish > -1 && round > path.roundsToFinish){
        finished = true;
        return;
      }
    }
    _index++;
    _roundCompleted++;
    if(_index >= path.length){
      _index = 0;
      if(!path.circular) finished = true;
    }
  }
}
class PathCheckPoint extends Vector{
  double radius;
  PathCheckPoint([double x=0.0, double y=0.0, this.radius=0.0]) : super(x, y);

}
class Path{
  List<PathCheckPoint> checkpoints;
  List<Polygon> roadPolygons;
  bool circular;
  int roundsToFinish;
  int get length => checkpoints.length;
  PathCheckPoint point(int index) => checkpoints[index];
  Path(GameLevelPath path){
    checkpoints = [];

    for(int i = 0; i < path.checkpoints.length; i++){
      GameLevelCheckPoint c = path.checkpoints[i];
      checkpoints.add(new PathCheckPoint(c.x,c.z,c.radius));
    }
    circular = path.circular;
    roundsToFinish = path.laps;

    PathToPolygons pathToPolygons = new PathToPolygons();
    roadPolygons = pathToPolygons.createRoadPolygons(path);
  }
  bool onRoad(Vector p){
    for(int i = 0; i< roadPolygons.length; i++){
      if(_inTriangle(p,roadPolygons[i])){
        return true;
      }
    }
    return false;
  }
  bool _inTriangle(Vector P, Polygon p){
    var A = p.points[0];
    var B = p.points[1];
    var C = p.points[2];
    var Area = 0.5 *(-B.y*C.x + A.y*(-B.x + C.x) + A.x*(B.y - C.y) + B.x*C.y);
    var s = 1/(2*Area)*(A.y*C.x - A.x*C.y + (C.y - A.y)*P.x + (A.x - C.x)*P.y);
    var t = 1/(2*Area)*(A.x*B.y - A.y*B.x + (A.y - B.y)*P.x + (B.x - A.x)*P.y);
    return s > 0 && t > 0 && 1-s-t > 0;
  }
}