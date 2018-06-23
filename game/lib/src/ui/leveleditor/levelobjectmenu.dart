part of game.leveleditor;

class LevelObjectWrapper<T extends LevelObject>{
  Element el;
  List<T> levelObjects = [];
  void clearAll(){
    el.nodes.clear();
    levelObjects = [];
  }
  void addLevelObject(T o, OnSelect onSelect, OnMove onMove){
    levelObjects.add(o);
    o.onMove = onMove;
    o.onSelect = onSelect;
    el.append(o.createElement());
    o.update();
  }
  void removeLevelObject(T o){
    levelObjects.remove(o);
    o.element.remove();
  }
  Element createElement(){
    el = new DivElement();
    el.className = "levelObjectWrapper";
    return el;
  }
  void addToGameLevel(GameLevel level){}
  void loadFromGameLevel(GameLevel level, OnSelect onSelect, OnMove onMove){}
  void addNew(OnSelect onSelect, OnMove onMove, double x, double y){}
}
class LevelObjectWrapperWalls extends LevelObjectWrapper<LevelObjectWall>{
  void addNew(OnSelect onSelect, OnMove onMove, double x, double y){
    var newObj = new LevelObjectWall(new GameLevelWall(x,y,0.0,20.0,20.0,20.0));
    addLevelObject(newObj, onSelect, onMove);
  }
  void addToGameLevel(GameLevel level){
    level.walls.clear();
    for(var o in levelObjects){
      level.walls.add(o.createGameObject());
    }
  }
  void loadFromGameLevel(GameLevel level, OnSelect onSelect, OnMove onMove){
    clearAll();
    for(var o in level.walls){
      addLevelObject(new LevelObjectWall(o), onSelect, onMove);
    }
  }
}
class LevelObjectWrapperStaticObjects extends LevelObjectWrapper<LevelObjectStaticObject>{
  void addNew(OnSelect onSelect, OnMove onMove, double x, double y){
    var newObj = new LevelObjectStaticObject(new GameLevelStaticObject(0,x,y,0.0));
    addLevelObject(newObj, onSelect, onMove);
  }
  void addToGameLevel(GameLevel level){
    level.staticobjects.clear();
    for(var o in levelObjects){
      level.staticobjects.add(o.createGameObject());
    }
  }
  void loadFromGameLevel(GameLevel level, OnSelect onSelect, OnMove onMove){
    clearAll();
    for(var o in level.staticobjects){
      addLevelObject(new LevelObjectStaticObject(o), onSelect, onMove);
    }
  }
}
class LevelObjectWrapperCheckpoints extends LevelObjectWrapper<LevelObjectCheckPoint>{
  void addNew(OnSelect onSelect, OnMove onMove, double x, double y){
    var newObj = new LevelObjectCheckPoint(new GameLevelCheckPoint(x,y,100.0));
    addLevelObject(newObj, onSelect, onMove);
  }
  void addToGameLevel(GameLevel level){
    level.path.checkpoints.clear();
    for(var o in levelObjects){
      level.path.checkpoints.add(o.createGameObject());
    }
  }
  void loadFromGameLevel(GameLevel level, OnSelect onSelect, OnMove onMove){
    clearAll();
    for(var o in level.path.checkpoints){
      addLevelObject(new LevelObjectCheckPoint(o), onSelect, onMove);
    }
  }
}

class InputWrapper{
  Element el;
  InputElement el_in;

  Element createElement(String label, Function onChange){
    el_in = createInput(onChange);
    el = _wrapWithLabel(label, el_in);
    return el;
  }

  Element _wrapWithLabel(String label, Element element){
    DivElement el = new DivElement();
    Element el_label = new SpanElement();
    el_label.text = label;
    el.append(el_label);
    el.append(element);
    return el;
  }
  InputElement createInput(Function onChange){
    InputElement el = new InputElement();
    el.type = "number";
    el.onChange.listen(onChange);
    return el;
  }
  void showHideElement(bool show){
    el.style.display = show ? "block" : "none";
  }
}
class InputSliderWrapper extends InputWrapper{
  double min;
  double max;
  double step;
  InputSliderWrapper(this.min, this.max, this.step);
  InputElement createInput(Function onChange){
    RangeInputElement el = new RangeInputElement();
    el.onChange.listen(onChange);
    el.min = min.toString();
    el.max = max.toString();
    el.step = step.toString();
    return el;
  }
}

class LevelObjectMenu{
  InputWrapper el_x;
  InputWrapper el_y;
  InputWrapper el_r;
  InputWrapper el_w;
  InputWrapper el_h;
  LevelObject _currentObj;
  Element createElement(){
    Element el = new DivElement();
    el_x = new InputWrapper();
    el_y = new InputWrapper();
    el_r = new InputSliderWrapper(0.0,2*3.14, 0.2);
    el_w = new InputWrapper();
    el_h = new InputWrapper();
    el.append(el_x.createElement("x",_onInputChange));
    el.append(el_y.createElement("y",_onInputChange));
    el.append(el_w.createElement("w",_onInputChange));
    el.append(el_h.createElement("h",_onInputChange));
    el.append(el_r.createElement("r",_onInputChange));

    return el;
  }

  void _showLevelObject(LevelObject o){
    el_x.showHideElement(o.canMoveX);
    el_y.showHideElement(o.canMoveY);
    el_r.showHideElement(o.canRotate);
    el_w.showHideElement(o.canResizeW);
    el_h.showHideElement(o.canResizeH);
    el_x.el_in.value = o.x.toString();
    el_y.el_in.value = o.y.toString();
    el_r.el_in.value = o.r.toString();
    el_w.el_in.value = o.w.toString();
    el_h.el_in.value = o.h.toString();
  }

  void _onInputChange(Event e){
    if(_currentObj == null) return;
    _currentObj.x = double.parse(el_x.el_in.value);
    _currentObj.y = double.parse(el_y.el_in.value);
    _currentObj.r = double.parse(el_r.el_in.value);
    _currentObj.w = double.parse(el_w.el_in.value);
    _currentObj.h = double.parse(el_h.el_in.value);
    _currentObj.update();
  }

  Element _wrapWithLabel(String label, Element element){
    DivElement el = new DivElement();
    Element el_label = new SpanElement();
    el_label.text = label;
    el.append(el_label);
    el.append(element);
    return el;
  }

  void onSelect(LevelObject o){
    _currentObj = o;
    _showLevelObject(o);
  }
  void onMove(LevelObject o){
    _currentObj = o;
    _showLevelObject(o);
  }
}