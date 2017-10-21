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
    if(_index == 0){
      round++;
      _roundCompleted = 0;
      if(path.roundsToFinish > -1 && round >= path.roundsToFinish){
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
class PathCheckPoint extends Point{
  double radius;
  PathCheckPoint([double x=0.0, double y=0.0, this.radius=0.0]) : super(x, y);

}
class Path{
  List<PathCheckPoint> _path;
  List<Polygon> roadPolygons;
  bool circular;
  int roundsToFinish;
  int get length => _path.length;
  PathCheckPoint point(int index) => _path[index];
  Path(this._path, [this.circular = false, this.roundsToFinish = -1 /*-1 is infinite*/]){
    PathToPolygons pathToPolygons = new PathToPolygons();
    roadPolygons = pathToPolygons.createRoadPolygons(_path, circular);
  }
  bool onRoad(Point p){
    for(int i = 0; i< roadPolygons.length; i++){
      if(_inTriangle(p,roadPolygons[i])){
        return true;
      }
    }
    return false;
  }
  bool _inTriangle(Point P, Polygon p){
    var A = p.points[0];
    var B = p.points[1];
    var C = p.points[2];
    var Area = 0.5 *(-B.y*C.x + A.y*(-B.x + C.x) + A.x*(B.y - C.y) + B.x*C.y);
    var s = 1/(2*Area)*(A.y*C.x - A.x*C.y + (C.y - A.y)*P.x + (A.x - C.x)*P.y);
    var t = 1/(2*Area)*(A.x*B.y - A.y*B.x + (A.y - B.y)*P.x + (B.x - A.x)*P.y);
    return s > 0 && t > 0 && 1-s-t > 0;
  }
}