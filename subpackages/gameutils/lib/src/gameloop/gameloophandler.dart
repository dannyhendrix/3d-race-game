part of gameutils.gameloop;

/*
typedef void OnPlay();
typedef void OnStop();
typedef void OnUpdate(int now);
*/
class GameLoopState {
  int frames = 0;
  int lastTime;
  int time = 0;
  int fps = 0;
  int jstimer = -1;

  bool stopping = false;
  bool playing = false;

  OnUpdate onUpdate;
  OnPlay onPlay;
  OnStop onStop;
}

class GameLoopHandler {
  void toggle(GameLoopState gameloop) {
    if (gameloop.playing)
      stop(gameloop);
    else
      start(gameloop);
  }

  void start(GameLoopState gameloop) {
    gameloop.stopping = false;
    if (gameloop.playing) return;

    gameloop.playing = true;
    if (gameloop.jstimer == -1) _requestNextFrame(gameloop);
    gameloop.onPlay?.call();
  }

  void stop(GameLoopState gameloop) {
    gameloop.stopping = true;
  }

  void _loop(GameLoopState gameloop, num looptime) {
    if (gameloop.stopping == true) {
      gameloop.jstimer = -1;
      gameloop.playing = false;
      gameloop.onStop?.call();
      return;
    }
    if (gameloop.lastTime == null) gameloop.lastTime = looptime.toInt();

    //framerate
    int now = looptime.toInt(); //(new Date.now()).value;

    gameloop.onUpdate?.call(now);

    int delta = now - gameloop.lastTime;
    gameloop.lastTime = now;
    gameloop.time += delta;
    gameloop.frames++;
    if (gameloop.time > 1000) {
      gameloop.fps = 1000 * gameloop.frames ~/ gameloop.time;
      gameloop.time = 0;
      gameloop.frames = 0;
    }
    _requestNextFrame(gameloop);
    return;
  }

  void _requestNextFrame(GameLoopState gameloop) {
    gameloop.jstimer = window.requestAnimationFrame((num looptime) => _loop(gameloop, looptime));
  }
}
