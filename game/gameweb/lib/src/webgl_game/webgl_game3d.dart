part of webgl_game;

/**
 * Flow:
 * create game
 * create gameUI
 * UI form -> select game settings
 * UI form -> start race
 * game.initSession
 * gameUI.createDOM
 * game.startsession
 * gameUI.start
 */
/*
abstract class WebglGame{
  Element initAndCreateDom();
  void start(GameSettings settings);
  void pause([bool forceStart = null]);
}
*/
class WebglGame3d extends WebglGame {
  ILifetime _lifetime;
  Game game;
  GameState gameState;
  GameLoop _gameloop;
  bool _enableTextures = true;
  ResourceManager _resourceManager;
  TextureGenerator textureGenerator;

  double lightx = 0.0;
  double lighty = 0.5;
  double lightz = -1.0;

  GlRenderLayer layer;
  List<GlModelInstanceCollection> modelInstances = [];
  GlCameraFollowTarget camera;
  Map<Player, PlayerStats> playerElements;

  Element el_Fps;
  Element el_rounds;
  Element el_countdown;

  //WebglGame3d(GameSettings settings, this._resourceManager, [this._enableTextures = true]){
  WebglGame3d(ILifetime lifetime) {
    _lifetime = lifetime;
    game = lifetime.resolve();
    _resourceManager = lifetime.resolve();
    _gameloop = new GameLoop();
    textureGenerator = lifetime.resolve();
    _gameloop.setOnUpdate(_loop);
    gameState = game.state;
  }
  /*
  Element createControls(){
    Element el = new DivElement();
    el.id = "controlswrapper";

    var el_left = new UiPanel();
    el_left.addStyle("left");
    var el_right = new UiPanel();
    el_right.addStyle("right");

    el.append(el_left.element);
    el.append(el_right.element);

    el_left.append(createControlButton("keyboard_arrow_left",Control.SteerLeft));
    el_left.append(createControlButton("keyboard_arrow_right",Control.SteerRight));
    el_right.append(createControlButton("keyboard_arrow_up",Control.Accelerate));
    el_right.append(createControlButton("keyboard_arrow_down",Control.Brake));
    return el;
  }
  UiElement createControlButton(String icon, Control control){
    var el = new UiButtonIcon(icon, (){});
    el.element.onMouseDown.listen((Event e){onControl(control, true);});
    el.element.onTouchStart.listen((Event e){onControl(control, true);});
    el.element.onMouseUp.listen((Event e){onControl(control, false);});
    el.element.onTouchEnd.listen((Event e){onControl(control, false);});
    return el;
  }
   */
  @override
  Element initAndCreateDom(GameInput input, GameSettings settings) {
    game.initSession(input);
    double windowW = 800.0;
    double windowH = 500.0;
    layer = new GlRenderLayer.withSize(windowW.toInt(), windowH.toInt(), false, _enableTextures);
    el_Fps = new DivElement();
    el_rounds = new DivElement();
    el_rounds.className = "rounds";
    el_countdown = new DivElement();
    el_countdown.className = "countdown";

    //set textures
    layer.setTexture("car", _resourceManager.getTexture("textures/texture_vehicle"));
    layer.setTexture("tree", _resourceManager.getTexture("textures/texture_tree"));
    layer.setTexture("road", _resourceManager.getTexture("textures/texture_road"));
    layer.setTexture("wall", _resourceManager.getTexture("textures/texture_wall"), true);
    layer.setTexture("caravan", _resourceManager.getTexture("textures/texture_caravan"));

    for (var player in gameState.playersHuman) {
      if (player.vehicle is Car) {
        layer.setTexture("car${player.player.playerId}", textureGenerator.CreateTexture(colorMappingGl[player.theme.color1], colorMappingGl[player.theme.color2], "textures/texture_vehicle1").canvas);
      }
    }

    for (var player in gameState.playersCpu) {
      if (player.vehicle is Car) {
        layer.setTexture("car${player.player.playerId}", textureGenerator.CreateTexture(colorMappingGl[player.theme.color1], colorMappingGl[player.theme.color2], "textures/texture_vehicle1").canvas);
      }
    }

    //create UI
    Element el_hud = new DivElement();
    el_hud.className = "hud";
    Element el_playersWrapper = new DivElement();
    el_playersWrapper.className = "players";
    playerElements = {};
    for (Player p in gameState.playersHuman) {
      var stats = new PlayerStats(p);
      el_playersWrapper.append(stats.element);
      playerElements[p] = stats;
    }
    for (Player p in gameState.playersCpu) {
      var stats = new PlayerStats(p);
      el_playersWrapper.append(stats.element);
      playerElements[p] = stats;
    }
    el_hud.append(el_playersWrapper);
    el_hud.append(el_rounds);
    el_hud.append(el_countdown);

    // Tell WebGL how to convert from clip space to pixels
    layer.ctx.viewport(0, 0, layer.canvas.width, layer.canvas.height);

    //3 set view perspective
    if (settings.client_cameraType.v == GameCameraType.VehicleView)
      camera = new GlCameraFollowTargetClose(800.0, 0.6);
    else
      camera = new GlCameraFollowTargetBirdView(1000, 1.0);
    camera.setPerspective(aspect: windowW / windowH, fieldOfViewRadians: 0.5, zFar: 4000.0);

    //create all models
    modelInstances = _createModels();

    DivElement element = new DivElement();
    element.append(layer.canvas);
    element.append(el_hud);
    element.append(el_Fps);

    InputController inputController = new InputController(settings);
    _registerControls(inputController);
    //if(settings.client_showUIControls.v) element.append(createControls());
    return element;
  }

  @override
  bool onControl(Control control, bool active) {
    if (!_gameloop.playing || _gameloop.stopping) return false;
    game.onControl(gameState.humanPlayer, control, active);
    return true;
  }

  @override
  void pause() {
    _gameloop.trigger(LoopTrigger.Toggle);
  }

  @override
  void stop() {
    _gameloop.trigger(LoopTrigger.Stop);
  }

  @override
  void start() {
    game.startSession();
    _gameloop.trigger(LoopTrigger.Start);
  }

  void _loop(int now) {
    game.step();
    if (gameState.countdown.complete) {
      if (el_countdown != null) {
        el_countdown.style.display = "none";
        //el_countdown = null;
      }
    } else {
      el_countdown.text = "${gameState.countdown.count}";
    }
    if (game.state.state == GameStatus.Finished) {
      _gameloop.trigger(LoopTrigger.Stop);
      el_countdown.style.display = "block";
      el_countdown.text = "Finished";
      if (onGameFinished != null) onGameFinished(game.createGameResult());
      return;
    }
    layer.clearForNextFrame();
    camera.setCameraAngleAndOffset(new GlVector(gameState.humanPlayer.vehicle.position.x, 0.0, gameState.humanPlayer.vehicle.position.y), gameState.humanPlayer.vehicle.r);

    GlMatrix viewProjectionMatrix = camera.cameraMatrix; //perspective*viewMatrix;
    GlMatrix worldMatrix = GlMatrix.rotationYMatrix(0.0);
    GlMatrix worldViewProjectionMatrix = worldMatrix.clone().multThis(viewProjectionMatrix);

    //2 call draw method with buffer
    for (GlModelInstanceCollection m in modelInstances) {
      GlMatrix objPerspective = worldViewProjectionMatrix.clone().multThis(m.CreateTransformMatrix());
      //if(m is GlModelInstanceFromCheckpoint) (m as GlModelInstanceFromCheckpoint).update();
      for (GlModelInstance mi in m.modelInstances) {
        var mimatrix = objPerspective.clone().multThis(mi.CreateTransformMatrix());
        layer.setWorld(worldMatrix, mimatrix, new GlVector(lightx, lighty, lightz), 0.3);
        layer.drawModel(mi);
      }
    }
    int h = 24;
    int y = 0;
    int pos = 1;
    for (Player p in gameState.playerRanking) {
      playerElements[p].setPosition(pos++);
      playerElements[p].element.style.top = "${y}px";
      y += h;
    }
    var progress = gameState.humanPlayer.pathProgress;
    if (progress is PathProgressCheckpoint) el_rounds.text = "${progress.round}";
  }

  List<GlModelInstanceCollection> _createModels() {
    //TODO: why load all the models? (why load truck if we only have cars?)
    GlModelCollection modelCollection = new GlModelCollectionBuffer(layer);
    GlModel_Vehicle vehicleModel = new GlModel_Vehicle();
    GlModel_Formula formulaModel = new GlModel_Formula();
    GlModel_Pickup pickupModel = new GlModel_Pickup();
    GlModel_Truck truckModel = new GlModel_Truck();
    GlModel_TruckTrailer truckTrailerModel = new GlModel_TruckTrailer();
    GlModel_Caravan caravanModel = new GlModel_Caravan();
    GlModel_Wall wallModel = new GlModel_Wall();
    GlModel_Tree treeModel = new GlModel_Tree();
    vehicleModel.loadModel(modelCollection);
    formulaModel.loadModel(modelCollection);
    pickupModel.loadModel(modelCollection);
    truckModel.loadModel(modelCollection);
    truckTrailerModel.loadModel(modelCollection);
    caravanModel.loadModel(modelCollection);
    wallModel.loadModel(modelCollection);
    treeModel.loadModel(modelCollection);

    List<GlModelInstanceCollection> modelInstances = [];

    //createVehicleModel().modelInstances.forEach((GlModelInstance model) => modelInstances.add(model));
    //GlColor colorWindows = new GlColor(0.2,0.2,0.2);
    GlColor colorWindows = new GlColor(0.3, 0.3, 0.3);

    //create all buffer
    for (var o in gameState.trees) modelInstances.add(new GlModelInstanceFromModelStatic(o.position.x, 0.0, o.position.y, 0.0, -o.r, 0.0, treeModel.getModelInstance(modelCollection)));
    for (var o in gameState.walls) modelInstances.add(new GlModelInstanceFromModelStatic(o.position.x, 0.0, o.position.y, 0.0, -o.r, 0.0, wallModel.getModelInstance(modelCollection, o.w, 150.0, o.h)));
    for (var o in gameState.checkpointPosts) {
      var colorPoles = new GlColor(0.6, 0.6, 0.6);
      modelInstances.add(new GlModelInstanceFromModelStatic(o.position.x, 0.0, o.position.y, 0.0, -o.r, 0.0, wallModel.getModelInstance(modelCollection, 8.0, 150.0, 8.0, colorPoles)));
    }
    for (var o in gameState.checkpoints) {
      CheckpointGameItem c = o;
      var color = new GlColor(1.0, 0.5, 0.0);
      modelInstances.add(new GlModelInstanceFromCheckpoint(gameState, c, o.position.x, 150.0 - 60.0, o.position.y, 0.0, -o.r, 0.0, wallModel.getModelInstance(modelCollection, 4.0, 60.0, c.width, color)));
    }
    for (var o in gameState.vehicles) {
      if (o is Car) {
        Vehicle v = o;
        modelInstances.add(new GlModelInstanceFromModel(o, vehicleModel.getModelInstance(modelCollection, colorMappingGl[v.player.theme.color1], colorMappingGl[v.player.theme.color2], colorWindows, "car${v.player.player.playerId}")));
      } else if (o is FormulaCar) {
        Vehicle v = o;
        modelInstances.add(new GlModelInstanceFromModel(o, formulaModel.getModelInstance(modelCollection, colorMappingGl[v.player.theme.color1], colorMappingGl[v.player.theme.color2], colorWindows)));
      } else if (o is PickupCar) {
        Vehicle v = o;
        modelInstances.add(new GlModelInstanceFromModel(o, pickupModel.getModelInstance(modelCollection, colorMappingGl[v.player.theme.color1], colorMappingGl[v.player.theme.color2], colorWindows)));
      } else if (o is Truck) {
        Vehicle v = o;
        modelInstances.add(new GlModelInstanceFromModel(o, truckModel.getModelInstance(modelCollection, colorMappingGl[v.player.theme.color1], colorMappingGl[v.player.theme.color2], colorWindows)));
      }
    }
    for (var o in gameState.trailers) {
      if (o is Caravan) {
        Trailer t = o;
        modelInstances.add(new GlModelInstanceFromModel(o, caravanModel.getModelInstance(modelCollection, colorMappingGl[t.vehicle.player.theme.color1], colorMappingGl[t.vehicle.player.theme.color2], colorWindows)));
      } else if (o is TruckTrailer) {
        Trailer t = o;
        modelInstances.add(new GlModelInstanceFromModel(o, truckTrailerModel.getModelInstance(modelCollection, colorMappingGl[t.vehicle.player.theme.color1], colorMappingGl[t.vehicle.player.theme.color2], colorWindows)));
      }
    }

    //GlModel worldModel = new GlAreaModel([new GlRectangle.withWD(0.0,0.0,0.0,1500.0,800.0,false)]);
    var triangles = gameState.level.roadPolygons.map((Polygon p) => new GlTriangle(p.points.map((var p) => new GlPoint(p.x, 0.0, p.y, p.x, -p.y)).toList(growable: false))).toList(growable: false);
    GlModel roadModel = new GlAreaModel(triangles);
    GlModelBuffer road = roadModel.createBuffers(layer);
    modelInstances.add(new GlModelInstanceCollection([new GlModelInstance(road, new GlColor(0.3, 0.3, 0.3), null, "road")]));

    GlModelBuffer cube = new GlCube.fromTopCenter(0.0, 0.0, 0.0, 30.0, 30.0, 30.0).createBuffers(layer);
    if (gameState.gamelevelType == GameLevelType.Checkpoint) {
      /*
      modelInstances.add(new GlModelInstanceCheckpoint(game.humanPlayer
          .pathProgress as PathProgressCheckpoint, new GlModelInstanceCollection([
        new GlModelInstance(cube, new GlColor(1.0, 1.0, 0.0))])));*/
    }
    return modelInstances;
  }
}

class GlModelInstanceFromModelStatic extends GlModelInstanceCollection {
  GlMatrix _transform;
  GlModelInstanceFromModelStatic(double x, double y, double z, double rx, double ry, double rz, GlModelInstanceCollection model) : super([]) {
    this.modelInstances = model.modelInstances;
    _transform = GlMatrix.translationMatrix(x, y, z).rotateXThis(rx).rotateYThis(ry).rotateZThis(rz);
  }
  GlMatrix CreateTransformMatrix() {
    return _transform;
  }
}

class GlModelInstanceFromCheckpoint extends GlModelInstanceCollection {
  GlMatrix _transform;
  CheckpointGameItem _checkpoint;
  GameState _game;
  int checkpointTicker = 0;
  GlModelInstanceFromCheckpoint(this._game, this._checkpoint, double x, double y, double z, double rx, double ry, double rz, GlModelInstanceCollection model) : super([]) {
    this.modelInstances = model.modelInstances;
    _transform = GlMatrix.translationMatrix(x, y, z).rotateXThis(rx).rotateYThis(ry).rotateZThis(rz);
  }
  GlMatrix CreateTransformMatrix() {
    var isCurrent = (_checkpoint.index == (_game.humanPlayer.pathProgress as PathProgressCheckpoint).currentIndex);
    if (!isCurrent) return _transform;

    checkpointTicker++;
    //showBlank = (checkpointTicker < 20);
    if (checkpointTicker == 40) {
      checkpointTicker = 0;
    }

    return _transform.clone().scaleThis(1.0 + (checkpointTicker / 10), 1.0, 1.0);
  }
  /*
  void update(){
    var isCurrent = (_checkpoint.index == (_game.humanPlayer.pathProgress as PathProgressCheckpoint).currentIndex);
    var showBlank = false;
    if(isCurrent){
      checkpointTicker++;
      //showBlank = (checkpointTicker < 20);
      if(checkpointTicker == 40){
        checkpointTicker = 0;
      }
    }
    modelInstances.first.color = !showBlank ? new GlColor(1.0, 0.5, 0.0) : new GlColor(0.8, 0.8, 0.8);
  }
  */
}

class GlModelInstanceFromModel extends GlModelInstanceCollection {
  GameItem gameObject;
  GlModelInstanceFromModel(this.gameObject, GlModelInstanceCollection model) : super([]) {
    this.modelInstances = model.modelInstances;
  }
  GlMatrix CreateTransformMatrix() {
    GlMatrix m = GlMatrix.translationMatrix(gameObject.position.x, 0.0, gameObject.position.y);
    m.rotateYThis(-gameObject.r);
    return m;
  }
}

class GlModelInstanceFromGameObject extends GlModelInstanceCollection {
  GameItem gameObject;
  GlModelInstanceFromGameObject(this.gameObject, GlModelInstanceCollection model) : super(model.modelInstances);
  GlMatrix CreateTransformMatrix() {
    GlMatrix m = GlMatrix.translationMatrix(gameObject.position.x, 0.0, gameObject.position.y);
    m.rotateYThis(-gameObject.r);
    return m;
  }
}
/*
class GlModelInstanceCheckpoint extends GlModelInstanceCollection{
  PathProgressCheckpoint pathProgress;
  double get x => pathProgress.current.x;
  double get z => pathProgress.current.y;
  double get ry => 0.0;
  GlModelInstanceCheckpoint(this.pathProgress, GlModelInstanceCollection model):super(model.modelInstances);
  GlMatrix CreateTransformMatrix(){
    GlMatrix m = GlMatrix.translationMatrix(pathProgress.current.x,0.0,pathProgress.current.y);
    return m;
  }
}*/
