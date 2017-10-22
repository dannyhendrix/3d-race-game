part of micromachines;

typedef void onCountdownComplete();
class Countdown{
  int frameDelay;
  int count;
  bool complete = false;
  int _tick = 0;
  onCountdownComplete _onComplete;
  Countdown(this._onComplete,[this.frameDelay = 60, this.count = 3]);
  void start(){
    _tick = frameDelay;
  }
  void tick(){
    _tick--;
    if(_tick == 0){
      _tick = frameDelay;
      count--;
      if(count == 0){
        complete = true;
        _onComplete();
      }
    }
  }
}