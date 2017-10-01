part of micromachines;

class PathProgress{
  int round = 0;
  Path path;
  bool finished = false;
  int _index = 0;

  PathCheckPoint get current => path.point(_index);
  double get completedFactor => _index.toDouble()/path.length.toDouble();

  PathProgress(this.path);

  void next(){
    if(_index == 0){
      round++;
      if(path.roundsToFinish > -1 && round >= path.roundsToFinish){
        finished = true;
        return;
      }
    }
    _index++;
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
  bool circular;
  int roundsToFinish;
  int get length => _path.length;
  PathCheckPoint point(int index) => _path[index];
  Path(this._path, [this.circular = false, this.roundsToFinish = -1]);//-1 inf
}