part of gameutils.gameloop;

typedef void OnPlay();
typedef void OnStop();
typedef void OnUpdate(int now);

enum LoopTrigger {Stop, Start, Toggle}

abstract class IGameLoop{
	void setOnUpdate(OnUpdate action);
	void setOnPlay(OnPlay action);
	void setOnStop(OnStop action);
	void trigger([LoopTrigger loopTrigger]);
}

class GameLoop implements IGameLoop{
  //framerate
  int frames = 0;
  int lastTime;
  int time = 0;
  int fps = 0;
  int jstimer = -1;

  bool stopping = false;
  bool playing = false;

  OnUpdate update;
  OnPlay onPlay;
  OnStop onStop;

  void setOnUpdate(OnUpdate action) => update = action;
  void setOnPlay(OnPlay action) => onPlay = action;
  void setOnStop(OnStop action) => onStop = action;
  void trigger([LoopTrigger loopTrigger = LoopTrigger.Toggle]){
    switch(loopTrigger){
      case LoopTrigger.Start:
      _play();
      break;
      case LoopTrigger.Stop:
      _stop();
      break;
      case LoopTrigger.Toggle:
      if(playing) _stop(); 
      else _play();
      break;
    }
  }

  void _play(){
    stopping = false;
    if(playing)
    return;

    playing = true;
    if(jstimer == -1)
    jstimer = window.requestAnimationFrame(_loop);
    if(onPlay != null)
    onPlay();
  }

  void _stop(){
    stopping = true;
  }

  void _loop(num looptime){
    if(stopping == true){
      jstimer = -1;
      playing = false;
      if(onStop != null)
      onStop();
      return;
    }
    if(lastTime == null) lastTime = looptime.toInt();

    //framerate
    int now = looptime.toInt();//(new Date.now()).value;

    if(update != null) update(now);

    int delta = now-lastTime;
    lastTime = now;
    time += delta;
    frames++;
    if(time > 1000){
      fps = 1000*frames~/time;
      time = 0;
      frames = 0;
    }

    window.requestAnimationFrame(_loop);
    return;
  }
}