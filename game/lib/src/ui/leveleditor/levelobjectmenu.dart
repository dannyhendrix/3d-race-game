part of game.leveleditor;

class LevelObjectWrapper<T extends LevelObject>{
  Element el;
  List<T> levelObjects = [];
  void clearAll(){
    el.nodes.clear();
    levelObjects = [];
  }
  void addLevelObject(T o){
    levelObjects.add(o);
    el.append(o.createElement());
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
}
/*
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
*/
/*
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
*/
class LevelObjectMenu{
  Element element;
  Element createElement(){
    Element el = new DivElement();
    element = el;
    return el;
  }
  void onSelect(LevelObject o){
    element.nodes.clear();
    element.append(o.el_properties);
  }
}