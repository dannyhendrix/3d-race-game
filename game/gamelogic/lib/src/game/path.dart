part of game;

abstract class PathProgress {
  bool finished = false;
  double get progress;
  bool collect(CheckpointGameItem checkpoint);
}

class PathProgressScore implements PathProgress {
  bool finished = false;
  double get progress => 0.0;
  bool collect(CheckpointGameItem checkpoint) {
    return false;
  }
}

class PathProgressCheckpoint extends PathProgress {
  int round = 0;
  int _index = 0;
  int _totalCheckpoints = 0;
  int _totalRounds = 0;
  bool _circular = false;
  int _requiredCheckpoints = 0;
  int _collectedCheckpoints = 0;

  int get currentIndex => _index;
  double get _completedFactor => _collectedCheckpoints.toDouble() / _requiredCheckpoints.toDouble();
  double get progress => _completedFactor;

  PathProgressCheckpoint(this._totalCheckpoints, this._totalRounds, this._circular) {
    _requiredCheckpoints = _totalCheckpoints * _totalRounds + (_circular ? 1 : 0);
  }

  bool collect(CheckpointGameItem checkpoint) {
    if (finished) return false;
    var collected = _index == checkpoint.index;
    if (collected) _next();
    return collected;
  }

  void _next() {
    if (finished) return;
    _collectedCheckpoints++;
    if (_index == 0) {
      print("collect 0");
      round++;
      if (_totalRounds > -1 && round > _totalRounds) {
        finished = true;
        return;
      }
    }
    _index++;
    if (_index >= _totalCheckpoints) {
      _index = 0;
      if (!_circular) finished = true;
    }
  }
}

class TrackProgress {
  int _index = 0;
  int _totalCheckpoints = 0;
  TrackProgress(this._totalCheckpoints);
  int get currentIndex => _index;
  void next() {
    _index++;
    if (_index >= _totalCheckpoints) {
      _index = 0;
    }
  }
}
