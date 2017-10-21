import "package:preloader/preloader.dart";
import "package:logging/logging.dart";
import "package:micromachines/game.dart";
import "package:micromachines/webgl.dart";
import "package:micromachines/webgl_game.dart";
import "package:renderlayer/renderlayer.dart";
import "package:gameutils/gameloop.dart";
import "package:gameutils/math.dart";
import "dart:html";
import "dart:math" as Math;
import "dart:web_gl";

Element el_Fps;
Game game;

GlRenderLayer layer;
List<GlModelInstanceCollection> modelInstances = [];
GlCameraDistanseToTarget camera;
double cameraZOffset = 1800.0;
double cameraZRotation = -1.0;
Map<Player,PlayerStats> playerElements;
Element el_rounds;
Element el_countdown;


Map<VehicleThemeColor, String> colorMappingCss = {
  VehicleThemeColor.Black   : "#333",
  VehicleThemeColor.White   : "#FFF",
  VehicleThemeColor.Gray    : "#999",
  VehicleThemeColor.Red     : "#F00",
  VehicleThemeColor.Green   : "#0F0",
  VehicleThemeColor.Blue    : "#00F",
  VehicleThemeColor.Yellow  : "#FF0",
  VehicleThemeColor.Orange  : "#F80",
  VehicleThemeColor.Pink    : "#F4F",
};

class GlModelInstanceFromVehicle extends GlModelInstanceCollection{
  GameObject gameObject;
  GlModelInstanceFromVehicle(this.gameObject, GlModelInstanceCollection model):super([]){
    this.modelInstances = model.modelInstances;
  }
  GlMatrix CreateTransformMatrix(){
    GlMatrix m = GlMatrix.translationMatrix(gameObject.position.x,0.0,gameObject.position.y);
    m = m.rotateY(-gameObject.r);
    return m;
  }
}
class GlModelInstanceFromGameObject extends GlModelInstanceCollection{
  GameObject gameObject;
  GlModelInstanceFromGameObject(this.gameObject, GlModelInstanceCollection model):super(model.modelInstances);
  GlMatrix CreateTransformMatrix(){
    GlMatrix m = GlMatrix.translationMatrix(gameObject.position.x,0.0,gameObject.position.y);
    m = m.rotateY(-gameObject.r);
    return m;
  }
}
class GlModelInstanceCheckpoint extends GlModelInstanceCollection{
  Game game;
  double get x => game.humanPlayer.pathProgress.current.x;
  double get z => game.humanPlayer.pathProgress.current.y;
  double get ry => 0.0;
  GlModelInstanceCheckpoint(this.game, GlModelInstanceCollection model):super(model.modelInstances);
  GlMatrix CreateTransformMatrix(){
    GlMatrix m = GlMatrix.translationMatrix(game.humanPlayer.pathProgress.current.x,0.0,game.humanPlayer.pathProgress.current.y);
    return m;
  }
}

void main()
{
  //logger
  Logger.root.level = Level.OFF;

  double windowW = 800.0;
  double windowH = 500.0;
  layer = new GlRenderLayer.withSize(windowW.toInt(),windowH.toInt());
  el_Fps = new DivElement();
  el_rounds = new DivElement();
  el_rounds.className = "rounds";
  el_countdown = new DivElement();
  el_countdown.className = "countdown";
  document.body.append(layer.canvas);
  document.body.append(el_Fps);
  print("Hi");

  // Tell WebGL how to convert from clip space to pixels
  layer.ctx.viewport(0, 0, layer.canvas.width, layer.canvas.height);

  //3 set view perspective
  camera = new GlCameraDistanseToTarget();
  camera.setPerspective(aspect:windowW / windowH, fieldOfViewRadians: 0.5, zFar: 4000.0);
  /*
  camera.y = 800.0;
  camera.x = 100.0;
  camera.z = -100.0;
  */

  game = new Game();
  game.init();

  //create UI
  Element el_hud = new DivElement();
  el_hud.className = "hud";
  Element el_playersWrapper = new DivElement();
  el_playersWrapper.className = "players";
  playerElements = {};
  for(Player p in game.players){
    var stats = new PlayerStats(p);
    el_playersWrapper.append(stats.element);
    playerElements[p] = stats;
  }
  el_hud.append(el_playersWrapper);
  el_hud.append(el_rounds);
  el_hud.append(el_countdown);
  document.body.append(el_hud);

  game.start();

  Map<VehicleThemeColor, GlColor> colorMapping = {
    VehicleThemeColor.Black : new GlColor(0.2,0.2,0.2),
    VehicleThemeColor.White : new GlColor(1.0,1.0,1.0),
    VehicleThemeColor.Gray : new GlColor(0.7,0.7,0.7),
    VehicleThemeColor.Red : new GlColor(1.0,0.0,0.0),
    VehicleThemeColor.Green : new GlColor(0.0,1.0,0.0),
    VehicleThemeColor.Blue : new GlColor(0.0,0.0,1.0),
    VehicleThemeColor.Yellow : new GlColor(1.0,1.0,0.0),
    VehicleThemeColor.Orange : new GlColor(1.0,0.5,0.0),
    VehicleThemeColor.Pink : new GlColor(1.0,0.3,1.0),
  };

//units/actual
  //4 4 8
  GlModelCollection modelCollection = new GlModelCollection(layer);
  GlModel_Vehicle vehicleModel = new GlModel_Vehicle();
  vehicleModel.loadModel(modelCollection);
  //createVehicleModel().modelInstances.forEach((GlModelInstance model) => modelInstances.add(model));
  GlColor colorWindows = new GlColor(0.2,0.2,0.2);
  //create all buffer
  for(GameObject o in game.gameobjects){
    if(o is Vehicle){
      Vehicle v = o;
      modelInstances.add(new GlModelInstanceFromVehicle(o, vehicleModel.getModelInstance(modelCollection, colorMapping[v.player.theme.color1], colorMapping[v.player.theme.color2], colorWindows)));
    }else{
      double h = o is Wall ? 150.0 : 80.0;
      GlModelBuffer cube = new GlCube.fromTopCenter(0.0,(h/2),0.0,o.w,h,o.h).createBuffers(layer);
      modelInstances.add(new GlModelInstanceFromGameObject(o, new GlModelInstanceCollection([new GlModelInstance(cube, new GlColor(1.0,1.0,1.0))])));
    }
  }

  //GlModel worldModel = new GlAreaModel([new GlRectangle.withWD(0.0,0.0,0.0,1500.0,800.0,false)]);
  var triangles = game.path.roadPolygons.map((Polygon p)=>new GlTriangle(p.points.map((Point2d p)=>new GlPoint(p.x,0.0,p.y)).toList(growable: false))).toList(growable: false);
  GlModel roadModel = new GlAreaModel(triangles);
  GlModelBuffer road = roadModel.createBuffers(layer);
  modelInstances.add(new GlModelInstanceCollection([new GlModelInstance(road, new GlColor(0.3,0.3,0.3))]));

  GlModelBuffer cube = new GlCube.fromTopCenter(0.0,0.0,0.0,30.0,30.0,30.0).createBuffers(layer);
  modelInstances.add(new GlModelInstanceCheckpoint(game, new GlModelInstanceCollection([new GlModelInstance(cube, new GlColor(1.0,1.0,0.0))])));

  // Start off the infinite animation loop
  tick(0);

  var handleKey = (KeyboardEvent e)
  {
    //if(!gameloop.playing || gameloop.stopping)
      //return;
    int key = e.keyCode;
    bool down = e.type == "keydown";//event.KEYDOWN
    Control control;
    if(key == 38)//up
      game.humanPlayer.onControl(Control.Accelerate,down);
    else if(key == 40)//down
      game.humanPlayer.onControl(Control.Brake,down);
    else if(key == 37)//left
      game.humanPlayer.onControl(Control.SteerLeft,down);
    else if(key == 39)//right
      game.humanPlayer.onControl(Control.SteerRight,down);
/*
    else if(key == 87)//w
      game.players[1].onControl(Control.Accelerate,down);
    else if(key == 83)//s
      game.players[1].onControl(Control.Brake,down);
    else if(key == 65)//a
      game.players[1].onControl(Control.SteerLeft,down);
    else if(key == 68)//d
      game.players[1].onControl(Control.SteerRight,down);*/
    else return;

    e.preventDefault();
  };

  document.onKeyDown.listen(handleKey);
  document.onKeyUp.listen(handleKey);
}
/**
 * This is the infinite animation loop; we request that the web browser
 * call us back every time its ready for a new frame to be rendered. The [time]
 * parameter is an increasing value based on when the animation loop started.
 */
tick(time) {
  window.animationFrame.then(tick);
  frameCount(time);

  game.update();
  if(game.countdown.complete){
    if(el_countdown != null){
      el_countdown.remove();
      el_countdown = null;
    }
  }else{
    el_countdown.text = "${game.countdown.count}";
  }

  layer.clearForNextFrame();

  camera.setCameraAngleAndOffset(new GlVector(game.humanPlayer.vehicle.position.x,0.0,game.humanPlayer.vehicle.position.y),rx:cameraZRotation,offsetZ:cameraZOffset);
  /*
  camera.tx = game.players[0].vehicle.position.x;
  camera.x = game.players[0].vehicle.position.x;
  camera.tz = game.players[0].vehicle.position.y;
  camera.z = game.players[0].vehicle.position.y-300.0;
*/
  var viewProjectionMatrix = camera.cameraMatrix;//perspective*viewMatrix;


  // Draw a F at the origin
  var worldMatrix = GlMatrix.rotationYMatrix(0.0);

  // Multiply the matrices.
  var worldViewProjectionMatrix = viewProjectionMatrix * worldMatrix;


  //2 call draw method with buffer
  for(GlModelInstanceCollection m in modelInstances){
    GlMatrix objPerspective = worldViewProjectionMatrix*m.CreateTransformMatrix();
    for(GlModelInstance mi in m.modelInstances){
      layer.setWorld(worldMatrix,objPerspective*mi.CreateTransformMatrix(), new GlVector(-1.0,0.8,0.6),0.4);
      layer.drawModel(mi);
    }
  }
  //b.pathProgress.progress.compareTo(a.pathProgress.progress));

  int h = 24;
  int y = 0;
  int pos = 1;
  for(Player p in game.players){
    //str += "${p.name} ${p.pathProgress.round} ${p.pathProgress.completedFactor} ${p.pathProgress.progress}<br/>";
    playerElements[p].setPosition(pos++);
    playerElements[p].element.style.top = "${y}px";
    y+=h;
  }
  el_rounds.text = "${game.humanPlayer.pathProgress.round}";
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






abstract class InputWithValue<T>{
  Element element;
  T getValue();
  void setValue(T v);
}

Element createButton(String labelText, Function onClick){
  var btn = new ButtonElement();
  btn.text = labelText;
  btn.onClick.listen(onClick);
  return btn;
}

class InputWithDoubleValue extends InputWithValue<double>{
  InputElement _inputElement;
  SpanElement _readValue;

  void setValue(double v){
    _readValue.text = v.toString();
  }
  double getValue(){
    return double.parse(_inputElement.value);
  }

  InputWithDoubleValue(double value, String labelText, Function onChange){
    element = new DivElement();
    _readValue = new SpanElement();
    _inputElement = new InputElement();
    _inputElement.onChange.listen(onChange);
    _inputElement.value = value.toString();
    var label = new SpanElement();
    label.text = labelText;
    label.style.width = "300px";
    label.style.display = "inline-block";
    element.append(label);
    element.append(_readValue);
    element.append(_inputElement);
  }
}

class PlayerStats{
  Element element;
  Element el_position;
  Player player;
  PlayerStats(this.player){
    element = _createElement();
  }
  void setPosition(int position){
    el_position.text = "$position";
  }
  Element _createElement(){
    DivElement el = new DivElement();
    if(player is HumanPlayer)
      el.className = "humanplayer player";
    else
      el.className = "player";
    Element el_name = new DivElement();
    el_position = new DivElement();
    el_position.className = "position";
    el_name.className = "playername";
    el_name.text = player.name;
    Element el_color = new DivElement();
    el_color.className = "color";
    Element el_color1 = new DivElement();
    el_color1.className = "color1";
    el_color1.style.background = "${colorMappingCss[player.theme.color1]}";
    Element el_color2 = new DivElement();
    el_color2.className = "color2";
    el_color2.style.background = "${colorMappingCss[player.theme.color2]}";
    el_color.append(el_color1);
    el_color.append(el_color2);
    el.append(el_position);
    el.append(el_color);
    el.append(el_name);
    return el;
  }
}