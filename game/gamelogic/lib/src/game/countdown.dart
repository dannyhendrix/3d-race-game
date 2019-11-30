part of game;

typedef void onCountdownComplete();

class Countdown {
  int frameDelay;
  int count;
  bool complete = false;
  int _tick = 0;
  onCountdownComplete _onComplete;
  Countdown(this._onComplete, [this.frameDelay = 60, this.count = 3]);
  void start() {
    _tick = frameDelay;
    if (count == 0) _tick = 0;
  }

  void tick() {
    _tick--;
    if (_tick <= 0) {
      _tick = frameDelay;
      count--;
      if (count <= 0) {
        complete = true;
        _onComplete();
      }
    }
  }
}

class Counter {
  int frameDelay;
  int count;
  bool complete = false;
  int tick = 0;
  onCountdownComplete onComplete;
  Counter(this.onComplete, [this.frameDelay = 60, this.count = 3]);
}

class CountdownHandler {
  void start(Counter counter) {
    counter.tick = counter.frameDelay;
  }

  void tick(Counter counter) {
    counter.tick--;
    if (counter.tick == 0) {
      counter.tick = counter.frameDelay;
      counter.count--;
      if (counter.count == 0) {
        counter.complete = true;
        counter.onComplete();
      }
    }
  }
}
