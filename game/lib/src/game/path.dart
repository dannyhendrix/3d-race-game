part of micromachines;

class PathProgress{
  int round = 0;
  Path path;
  bool finished = false;
  int _index = 0;

  Point get current => path.point(_index);
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

class Path{
  List<Point> _path;
  bool circular;
  int roundsToFinish;
  double pointRadius;
  int get length => _path.length;
  Point point(int index) => _path[index];
  Path(this._path, [this.circular = false, this.roundsToFinish = -1, this.pointRadius = 50.0]);//-1 inf
}