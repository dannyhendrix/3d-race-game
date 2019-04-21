part of micromachines;

abstract class PathProgress{
  bool finished = false;
  double get progress;
  void collect(CheckpointGameItem checkpoint);
}

class PathProgressScore implements PathProgress{
  bool finished = false;
  double get progress => 0.0;
  void collect(CheckpointGameItem checkpoint){}
}

class PathProgressCheckpoint extends PathProgress{
  int round = 0;
  int _index = 0;
  int _roundCompleted = 0;
  int _totalCheckpoints = 0;
  int _totalRounds = 0;
  bool _circular = false;

  int get currentIndex => _index;
  double get completedFactor => _roundCompleted.toDouble()/_totalCheckpoints.toDouble();
  double get progress => round*1.0 + completedFactor;

  PathProgressCheckpoint(this._totalCheckpoints, this._totalRounds, this._circular);

  void collect(CheckpointGameItem checkpoint){
    if(_index == checkpoint.index) _next();
  }

  void _next(){
    if(finished) return;
    if(_index == 0){
      round++;
      _roundCompleted = 0;
      if(_totalRounds > -1 && round > _totalRounds){
        finished = true;
        return;
      }
    }
    _index++;
    _roundCompleted++;
    if(_index >= _totalCheckpoints){
      _index = 0;
      if(!_circular) finished = true;
    }
  }
}