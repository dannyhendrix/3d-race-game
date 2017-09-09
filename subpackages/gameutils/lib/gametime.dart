library gameutils.gametime;

class GameTime 
{
  int ticker = 0;
  int sec = 0;
  int min = 0;
  int hour = 0;
  
  int fps;
  
  GameTime(this.fps);
  
  void tick()
  {
    ticker++;
    if(ticker < fps)
      return;
    _addSec();
    ticker = 0;
  }
  String _timeNotation(int x)
  {
    if(x > 9) return x.toString();
    return "0${x.toString()}";
  }
  String toString()
  {
    return "${_timeNotation(hour)}:${_timeNotation(min)}:${_timeNotation(sec)}";
  }
  
  void _addSec()
  {
    sec++;
    if(sec < 60)
      return;
    _addMin();
    sec = 0;
  }
  void _addMin()
  {
    min++;
    if(min < 60)
      return;
    _addHour();
    min = 0;
  }
  void _addHour()
  {
    hour++;
    if(hour > 12)
      print("Game hour is $hour .. get a life?");
  }
}
