import "package:preloader/preloader.dart";
import "package:logging/logging.dart";
import "package:micromachines/game.dart";
import "package:micromachines/webgl.dart";
import "package:renderlayer/renderlayer.dart";
import "package:gameutils/gameloop.dart";
import "package:gameutils/math.dart";
import "dart:html";
import "dart:math" as Math;
import "dart:web_gl";

Element el_Fps;
RenderLayer3d layer;
Render render;

void main()
{
  //logger
  Logger.root.level = Level.OFF;

  layer = new RenderLayer3d(500,500);
  el_Fps = new DivElement();
  print("Hi");

  document.body.append(layer.canvas);
  document.body.append(el_Fps);

  render = new Render(layer);

  el_Fps = new DivElement();

  // Start off the infinite animation loop
  tick(0);
}

/**
 * This is the infinite animation loop; we request that the web browser
 * call us back every time its ready for a new frame to be rendered. The [time]
 * parameter is an increasing value based on when the animation loop started.
 */
tick(time) {
  window.animationFrame.then(tick);
  frameCount(time);
  render.x += 0.01;
  render.y += 0.01;
  render.z += 0.01;
  render.drawScene(layer);
  //lesson.animate(time);
  //lesson.drawScene(canvas.width, canvas.height, canvas.width / canvas.height);
}

/// FPS meter - activated when the url parameter "fps" is included.
const num ALPHA_DECAY = 0.1;
const num INVERSE_ALPHA_DECAY = 1 - ALPHA_DECAY;
const SAMPLE_RATE_MS = 500;
const SAMPLE_FACTOR = 1000 ~/ SAMPLE_RATE_MS;
int frames = 0;
num lastSample = 0;
num averageFps = 1;

void frameCount(num now) {
  frames++;
  if ((now - lastSample) < SAMPLE_RATE_MS) return;
  averageFps = averageFps * ALPHA_DECAY + frames * INVERSE_ALPHA_DECAY * SAMPLE_FACTOR;
  el_Fps.text = averageFps.toStringAsFixed(2);
  frames = 0;
  lastSample = now;
}