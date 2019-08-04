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
class WebglGame3d extends WebglGame{
  Game game;
  GameLoop _gameloop;

  GlRenderLayer layer;
  List<GlModelInstanceCollection> modelInstances = [];
  GlCameraFollowTarget camera;
  Map<Player,PlayerStats> playerElements;

  Element el_Fps;
  Element el_rounds;
  Element el_countdown;

  WebglGame3d(GameSettings settings){
    game = new Game(settings);
    _gameloop = new GameLoop(_loop);
  }
  Element createControls(){
    Element el = new DivElement();
    el.id = "controlswrapper";

    Element el_left = new DivElement();
    el_left.className = "left";
    Element el_right = new DivElement();
    el_right.className = "right";

    el.append(el_left);
    el.append(el_right);

    el_left.append(createControlButton("keyboard_arrow_left",Control.SteerLeft));
    el_left.append(createControlButton("keyboard_arrow_right",Control.SteerRight));
    el_right.append(createControlButton("keyboard_arrow_up",Control.Accelerate));
    el_right.append(createControlButton("keyboard_arrow_down",Control.Brake));
    return el;
  }
  Element createControlButton(String icon, Control control){
    ButtonElement el = new ButtonElement();
    el.append(UIHelper.createIcon(icon));
    el.onMouseDown.listen((Event e){onControl(control, true);});
    el.onTouchStart.listen((Event e){onControl(control, true);});
    el.onMouseUp.listen((Event e){onControl(control, false);});
    el.onTouchEnd.listen((Event e){onControl(control, false);});
    return el;
  }
  @override
  Element initAndCreateDom(GameInput input, GameSettings settings) {
    game.initSession(input);
    double windowW = 800.0;
    double windowH = 500.0;
    layer = new GlRenderLayer.withSize(windowW.toInt(),windowH.toInt());
    el_Fps = new DivElement();
    el_rounds = new DivElement();
    el_rounds.className = "rounds";
    el_countdown = new DivElement();
    el_countdown.className = "countdown";

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

    // Tell WebGL how to convert from clip space to pixels
    layer.ctx.viewport(0, 0, layer.canvas.width, layer.canvas.height);

    //3 set view perspective
    if(settings.client_cameraType.v == GameCameraType.VehicleView) camera = new GlCameraFollowTargetClose(800.0,0.6);
    else camera = new GlCameraFollowTargetBirdView(1800,1.0);
    camera.setPerspective(aspect:windowW / windowH, fieldOfViewRadians: 0.5, zFar: 4000.0);

    //create all models
    modelInstances = _createModels();

    DivElement element = new DivElement();
    element.append(layer.canvas);
    element.append(el_hud);
    element.append(el_Fps);

    InputController inputController = new InputController(settings);
    _registerControls(inputController);
    if(settings.client_showUIControls.v) element.append(createControls());
    return element;
  }

  @override
  bool onControl(Control control, bool active){
    if(!_gameloop.playing || _gameloop.stopping)
      return false;
    game.humanPlayer.onControl(control,active);
    return true;
  }

  @override
  void pause([bool forceStart = null]){
    _gameloop.pause(forceStart);
  }
  @override
  void stop(){
    _gameloop.stop();
  }

  @override
  void start(){
    game.startSession();
    _gameloop.play();
  }

  void _loop(int now){
    game.step();
    if(game.countdown.complete){
      if(el_countdown != null){
        el_countdown.style.display = "none";
        //el_countdown = null;
      }
    }else{
      el_countdown.text = "${game.countdown.count}";
    }
    if(game.state == GameState.Finished){
      _gameloop.stop();
      el_countdown.style.display = "block";
      el_countdown.text = "Finished";
      if(onGameFinished != null) onGameFinished(game.createGameResult());
      return;
    }

    layer.clearForNextFrame();
    camera.setCameraAngleAndOffset(new GlVector(game.humanPlayer.vehicle.position.x,0.0,game.humanPlayer.vehicle.position.y),game.humanPlayer.vehicle.r);

    GlMatrix viewProjectionMatrix = camera.cameraMatrix;//perspective*viewMatrix;
    GlMatrix worldMatrix = GlMatrix.rotationYMatrix(0.0);
    GlMatrix worldViewProjectionMatrix = worldMatrix.clone().multThis(viewProjectionMatrix);

    //2 call draw method with buffer
    for(GlModelInstanceCollection m in modelInstances){
      GlMatrix objPerspective = worldViewProjectionMatrix.clone().multThis(m.CreateTransformMatrix());
      if(m is GlModelInstanceFromCheckpoint) (m as GlModelInstanceFromCheckpoint).update();
      for(GlModelInstance mi in m.modelInstances){
        layer.setWorld(worldMatrix,objPerspective.clone().multThis(mi.CreateTransformMatrix()), new GlVector(-1.0,0.8,0.6),0.4);
        layer.drawModel(mi);
      }
    }
    int h = 24;
    int y = 0;
    int pos = 1;
    for(Player p in game.players){
      playerElements[p].setPosition(pos++);
      playerElements[p].element.style.top = "${y}px";
      y+=h;
    }
    //TODO: print current round
    //el_rounds.text = "${game.humanPlayer.pathProgress.round}";
  }

  List<GlModelInstanceCollection> _createModels(){
    //TODO: why load all the models? (why load truck if we only have cars?)
    GlModelCollection modelCollection = new GlModelCollection(layer);
    GlModel_Vehicle vehicleModel = new GlModel_Vehicle();
    GlModel_Formula formulaModel = new GlModel_Formula();
    GlModel_Truck truckModel = new GlModel_Truck();
    GlModel_TruckTrailer truckTrailerModel = new GlModel_TruckTrailer();
    GlModel_Caravan caravanModel = new GlModel_Caravan();
    GlModel_Wall wallModel = new GlModel_Wall();
    GlModel_Tree treeModel = new GlModel_Tree();
    vehicleModel.loadModel(modelCollection);
    formulaModel.loadModel(modelCollection);
    truckModel.loadModel(modelCollection);
    truckTrailerModel.loadModel(modelCollection);
    caravanModel.loadModel(modelCollection);
    wallModel.loadModel(modelCollection);
    treeModel.loadModel(modelCollection);

    List<GlModelInstanceCollection> modelInstances = [];

    //createVehicleModel().modelInstances.forEach((GlModelInstance model) => modelInstances.add(model));
    GlColor colorWindows = new GlColor(0.2,0.2,0.2);
    //create all buffer
    for(var o in game.gameobjects){
      if(o is Car)
      {
        print("car model");
        Vehicle v = o;
        modelInstances.add(new GlModelInstanceFromModel(o, vehicleModel
            .getModelInstance(modelCollection, colorMappingGl[v.player.theme
            .color1], colorMappingGl[v.player.theme.color2], colorWindows)));
      }else if(o is FormulaCar){
        print("formula model");
        Vehicle v = o;
        modelInstances.add(new GlModelInstanceFromModel(o, formulaModel
            .getModelInstance(modelCollection, colorMappingGl[v.player.theme
            .color1], colorMappingGl[v.player.theme.color2], colorWindows)));
      }else if(o is Truck){
        Vehicle v = o;
        modelInstances.add(new GlModelInstanceFromModel(o, truckModel
            .getModelInstance(modelCollection, colorMappingGl[v.player.theme
            .color1], colorMappingGl[v.player.theme.color2], colorWindows)));

      }else if(o is Caravan){
        Trailer t = o;
        modelInstances.add(new GlModelInstanceFromModel(o, caravanModel
            .getModelInstance(modelCollection, colorMappingGl[t.vehicle.player.theme.color1], colorMappingGl[t.vehicle.player.theme.color2], colorWindows)));
      }else if(o is TruckTrailer){
        Trailer t = o;
        modelInstances.add(new GlModelInstanceFromModel(o, truckTrailerModel
            .getModelInstance(modelCollection, colorMappingGl[t.vehicle.player.theme.color1], colorMappingGl[t.vehicle.player.theme.color2], colorWindows)));

      }else if(o is Wall){
        modelInstances.add(new GlModelInstanceFromModelStatic(o.position.x,0.0,o.position.y, 0.0,-o.r,0.0, wallModel
            .getModelInstance(modelCollection, o.w, 150.0, o.h)));
      }else if(o is Tree){
        modelInstances.add(new GlModelInstanceFromModelStatic(o.position.x,0.0,o.position.y, 0.0,-o.r,0.0, treeModel
            .getModelInstance(modelCollection)));
      }else if(o is CheckpointGatePost){
        var colorPoles = new GlColor(0.6, 0.6, 0.6);
        modelInstances.add(new GlModelInstanceFromModelStatic(o.position.x, 0.0, o.position.y, 0.0, -o
            .r, 0.0, wallModel
            .getModelInstance(modelCollection, 8.0, 150.0, 8.0, colorPoles)));

      }else if(o is CheckpointGameItem){

        CheckpointGameItem c = o;
        //if(c.isGate)
        {
          var color = (c.index == (game.humanPlayer.pathProgress as PathProgressCheckpoint).currentIndex) ? new GlColor(1.0, 0.5, 0.0) : new GlColor(0.8, 0.8, 0.8);
          var colorPoles = new GlColor(0.6, 0.6, 0.6);
          //List<Polygon> absoluteCollisionFields = o.getAbsoluteCollisionFields();
          //var wallLeftPosition = absoluteCollisionFields[0].center;
          //var wallRightPosition = absoluteCollisionFields[1].center;
          /*modelInstances.add(new GlModelInstanceFromModelStatic(wallLeftPosition.x, 0.0, wallLeftPosition.y, 0.0, -o
              .r, 0.0, wallModel
              .getModelInstance(modelCollection, o.wallW, 150.0, o.wallH, colorPoles)));
          modelInstances.add(new GlModelInstanceFromModelStatic(wallRightPosition.x, 0.0, wallRightPosition.y, 0.0, -o
              .r, 0.0, wallModel
              .getModelInstance(modelCollection, o.wallW, 150.0, o.wallH, colorPoles)));*/
          modelInstances.add(new GlModelInstanceFromCheckpoint(game, c, o.position.x, 150.0-60.0, o.position.y, 0.0, -o
              .r, 0.0, wallModel
              .getModelInstance(modelCollection, 4.0, 60.0,c.radius*2,  color)));
        }
        /*
      }else{
        double h = 80.0;
        GlModelBuffer cube = new GlCube.fromTopCenter(0.0,(h/2),0.0,o.w,h,o.h).createBuffers(layer);
        modelInstances.add(new GlModelInstanceFromGameObject(o, new GlModelInstanceCollection([new GlModelInstance(cube, new GlColor(1.0,1.0,1.0))])));*/
      }else if(o is Ball){
        //GlModelBuffer cube = new GlCube.fromTopCenter(0.0,0.0,0.0,30.0,30.0,30.0).createBuffers(layer);
        //modelInstances.add(new GlModelInstanceFromGameObject(o, new GlModelInstanceCollection([new GlModelInstance(cube, new GlColor(1.0,1.0,0.0))])));
        var color = new GlColor(1.0,1.0,0.0);
        modelInstances.add(new GlModelInstanceFromModel(o, caravanModel
            .getModelInstance(modelCollection, color, color, colorWindows)));

      }
    }

    //GlModel worldModel = new GlAreaModel([new GlRectangle.withWD(0.0,0.0,0.0,1500.0,800.0,false)]);
    var triangles = game.level.roadPolygons.map((Polygon p)=>new GlTriangle(p.points.map((var p)=>new GlPoint(p.x,0.0,p.y)).toList(growable: false))).toList(growable: false);
    GlModel roadModel = new GlAreaModel(triangles);
    GlModelBuffer road = roadModel.createBuffers(layer);
    modelInstances.add(new GlModelInstanceCollection([new GlModelInstance(road, new GlColor(0.3,0.3,0.3))]));

    GlModelBuffer cube = new GlCube.fromTopCenter(0.0,0.0,0.0,30.0,30.0,30.0).createBuffers(layer);
    if(game.gamelevelType == GameLevelType.Checkpoint)
    {
      /*
      modelInstances.add(new GlModelInstanceCheckpoint(game.humanPlayer
          .pathProgress as PathProgressCheckpoint, new GlModelInstanceCollection([
        new GlModelInstance(cube, new GlColor(1.0, 1.0, 0.0))])));*/
    }
    return modelInstances;
  }
}


class GlModelInstanceFromModelStatic extends GlModelInstanceCollection{
  GlMatrix _transform;
  GlModelInstanceFromModelStatic(double x, double y, double z, double rx, double ry, double rz, GlModelInstanceCollection model):super([]){
    this.modelInstances = model.modelInstances;
    _transform = GlMatrix.translationMatrix(x,y,z).rotateXThis(rx).rotateYThis(ry).rotateZThis(rz);
  }
  GlMatrix CreateTransformMatrix(){
    return _transform;
  }
}
class GlModelInstanceFromCheckpoint extends GlModelInstanceCollection{
  GlMatrix _transform;
  CheckpointGameItem _checkpoint;
  Game _game;
  GlModelInstanceFromCheckpoint(this._game, this._checkpoint, double x, double y, double z, double rx, double ry, double rz, GlModelInstanceCollection model):super([]){
    this.modelInstances = model.modelInstances;
    _transform = GlMatrix.translationMatrix(x,y,z).rotateXThis(rx).rotateYThis(ry).rotateZThis(rz);
  }
  GlMatrix CreateTransformMatrix(){
    return _transform;
  }
  void update(){
    modelInstances.first.color = (_checkpoint.index == (_game.humanPlayer.pathProgress as PathProgressCheckpoint).currentIndex) ? new GlColor(1.0, 0.5, 0.0) : new GlColor(0.8, 0.8, 0.8);
  }
}
class GlModelInstanceFromModel extends GlModelInstanceCollection{
  GameItem gameObject;
  GlModelInstanceFromModel(this.gameObject, GlModelInstanceCollection model):super([]){
    this.modelInstances = model.modelInstances;
  }
  GlMatrix CreateTransformMatrix(){
    GlMatrix m = GlMatrix.translationMatrix(gameObject.position.x,0.0,gameObject.position.y);
    m.rotateYThis(-gameObject.r);
    return m;
  }
}
class GlModelInstanceFromGameObject extends GlModelInstanceCollection{
  GameItem gameObject;
  GlModelInstanceFromGameObject(this.gameObject, GlModelInstanceCollection model):super(model.modelInstances);
  GlMatrix CreateTransformMatrix(){
    GlMatrix m = GlMatrix.translationMatrix(gameObject.position.x,0.0,gameObject.position.y);
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