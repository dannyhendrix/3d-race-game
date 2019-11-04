part of game.leveleditor;

typedef OnSelect(LevelObject o);
typedef OnDelete(LevelObject o);
typedef OnPropertyChanged(LevelObject o);

class LevelObjectWall extends LevelObject{
  GameLevelWall gameObject;
  UiInputDouble input_x = new UiInputDouble("x");
  UiInputDouble input_y = new UiInputDouble("y");
  UiInputDouble input_w = new UiInputDouble("w");
  UiInputDouble input_h = new UiInputDouble("h");
  UiInputDouble input_r = new UiInputDouble("r");
  LevelObjectWall(LevelEditor editor, this.gameObject) : super(editor){
    className = "wall";
    properties = [input_x, input_y, input_w, input_h, input_r];
    input_x.onValueChange = (double value) { gameObject.x = value; onPropertyInputChange(); };
    input_y.onValueChange = (double value) { gameObject.y = value; onPropertyInputChange(); };
    input_w.onValueChange = (double value) { gameObject.w = value; onPropertyInputChange(); };
    input_h.onValueChange = (double value) { gameObject.h = value; onPropertyInputChange(); };
    input_r.onValueChange = (double value) { gameObject.r = value; onPropertyInputChange(); };
  }
  void updateProperties(){
    input_x.setValue(gameObject.x);
    input_y.setValue(gameObject.y);
    input_w.setValue(gameObject.w);
    input_h.setValue(gameObject.h);
    input_r.setValue(gameObject.r);
  }
  void updateElement(){
    double hw = gameObject.w/2;
    double hh = gameObject.h/2;
    element.style.top = "${(gameObject.y-hh)*scale}px";
    element.style.left = "${(gameObject.x-hw)*scale}px";
    element.style.width = "${gameObject.w*scale}px";
    element.style.height = "${gameObject.h*scale}px";
    element.style.transform = "rotate(${gameObject.r}rad)";
  }
  void onElementMove(double xOffset, double yOffset){
    gameObject.x += xOffset;
    gameObject.y += yOffset;
    onPropertyInputChange();
  }
  Element createControlsElement(){
    var el = super.createControlsElement();
    var table = new UiTable(6,4);
    el.append(table.element);

    var step = 10.0;
    var stepAngle = Math.pi/16;
    table.append(1,0,new UiButtonIcon("arrow_drop_up",(){gameObject.y -= step; onPropertyInputChange();}));
    table.append(1,2,new UiButtonIcon("arrow_drop_down",(){gameObject.y += step; onPropertyInputChange();}));
    table.append(0,1,new UiButtonIcon("arrow_left",(){gameObject.x -= step; onPropertyInputChange();}));
    table.append(2,1,new UiButtonIcon("arrow_right",(){gameObject.x += step; onPropertyInputChange();}));
    table.append(4,0,new UiButtonIcon("keyboard_arrow_up",(){gameObject.h -= step; onPropertyInputChange();}));
    table.append(4,2,new UiButtonIcon("keyboard_arrow_down",(){gameObject.h += step; onPropertyInputChange();}));
    table.append(3,1,new UiButtonIcon("keyboard_arrow_left",(){gameObject.w -= step; onPropertyInputChange();}));
    table.append(5,1,new UiButtonIcon("keyboard_arrow_right",(){gameObject.w += step; onPropertyInputChange();}));
    table.append(0,3,new UiButtonIcon("rotate_left",(){gameObject.r -= stepAngle; onPropertyInputChange();}));
    table.append(1,3,new UiButtonIcon("rotate_right",(){gameObject.r += stepAngle; onPropertyInputChange();}));
    return el;
  }
}
class LevelObjectStaticObject extends LevelObject{
  GameLevelStaticObject gameObject;
  UiInputDouble input_x = new UiInputDouble("x");
  UiInputDouble input_y = new UiInputDouble("y");
  UiInputDouble input_r = new UiInputDouble("r");
  UiInputInt input_id = new UiInputInt("id");
  LevelObjectStaticObject(LevelEditor editor, this.gameObject) : super(editor){
    className = "staticobject";
    properties = [input_x, input_y, input_r,input_id];
    input_x.onValueChange = (double value) { gameObject.x = value; onPropertyInputChange(); };
    input_y.onValueChange = (double value) { gameObject.y = value; onPropertyInputChange(); };
    input_r.onValueChange = (double value) { gameObject.r = value; onPropertyInputChange(); };
    input_id.onValueChange = (int value) { gameObject.id = value; onPropertyInputChange(); };
  }
  void updateProperties(){
    input_x.setValue(gameObject.x);
    input_y.setValue(gameObject.y);
    input_r.setValue(gameObject.r);
    input_id.setValue(gameObject.id);
  }
  void updateElement(){
    double w = 20.0;
    double h = 20.0;
    double hw = w/2;
    double hh = h/2;
    element.style.top = "${(gameObject.y-hh)*scale}px";
    element.style.left = "${(gameObject.x-hw)*scale}px";
    element.style.width = "${w*scale}px";
    element.style.height = "${h*scale}px";
    element.style.transform = "rotate(${gameObject.r}rad)";
  }
  void onElementMove(double xOffset, double yOffset){
    gameObject.x += xOffset;
    gameObject.y += yOffset;
    onPropertyInputChange();
  }
  Element createControlsElement(){
    var el = super.createControlsElement();
    var table = new UiTable(3,4);
    el.append(table.element);

    var step = 10.0;
    var stepAngle = Math.pi/16;
    table.append(1,0,new UiButtonIcon("arrow_drop_up",(){gameObject.y -= step; onPropertyInputChange();}));
    table.append(1,2,new UiButtonIcon("arrow_drop_down",(){gameObject.y += step; onPropertyInputChange();}));
    table.append(0,1,new UiButtonIcon("arrow_left",(){gameObject.x -= step; onPropertyInputChange();}));
    table.append(2,1,new UiButtonIcon("arrow_right",(){gameObject.x += step; onPropertyInputChange();}));
    table.append(0,3,new UiButtonIcon("rotate_left",(){gameObject.r -= stepAngle; onPropertyInputChange();}));
    table.append(1,3,new UiButtonIcon("rotate_right",(){gameObject.r += stepAngle; onPropertyInputChange();}));
    return el;
  }
}
class LevelObjectCheckpoint extends LevelObject{
  Element el_marker;
  GameLevelCheckPoint gameObject;
  UiInputDouble input_x = new UiInputDouble("x");
  UiInputDouble input_y = new UiInputDouble("y");
  UiInputDouble input_width = new UiInputDouble("width");
  UiInputDoubleSlider input_angle = new UiInputDoubleSlider("angle",0.0,Math.pi*2,32);
  UiInputDouble input_lengthBefore = new UiInputDouble("lengthBefore");
  UiInputDouble input_lengthAfter = new UiInputDouble("lengthAfter");
  LevelObjectCheckpoint(LevelEditor editor, this.gameObject) : super(editor){
    className = "checkpoint";
    properties = [input_x, input_y, input_width, input_angle, input_lengthBefore, input_lengthAfter];
    input_x.onValueChange = (double value) { gameObject.x = value; onPropertyInputChange(); };
    input_y.onValueChange = (double value) { gameObject.y = value; onPropertyInputChange(); };
    input_width.onValueChange = (double value) { gameObject.width = value; onPropertyInputChange(); };
    input_angle.onValueChange = (double value) { gameObject.angle = value; onPropertyInputChange(); };
    input_lengthBefore.onValueChange = (double value) { gameObject.lengthBefore = value; onPropertyInputChange(); };
    input_lengthAfter.onValueChange = (double value) { gameObject.lengthAfter = value; onPropertyInputChange(); };
  }
  void updateProperties(){
    input_x.setValue(gameObject.x);
    input_y.setValue(gameObject.y);
    input_width.setValue(gameObject.width);
    input_angle.setValue(gameObject.angle);
    input_lengthBefore.setValue(gameObject.lengthBefore);
    input_lengthAfter.setValue(gameObject.lengthAfter);
  }
  void updateElement(){
    double fullRadius = gameObject.width;
    element.style.top = "${(gameObject.y-gameObject.width/2)*scale}px";
    element.style.left = "${(gameObject.x-gameObject.width/2)*scale}px";
    element.style.width = "${fullRadius*scale}px";
    element.style.height = "${fullRadius*scale}px";
    element.style.borderRadius = "${fullRadius*scale}px";
    el_marker.style.top = "${(gameObject.width/2-20.0)*scale}px";
    el_marker.style.left = "${(gameObject.width/2-20.0)*scale}px";
    el_marker.style.width = "${40.0*scale}px";
    el_marker.style.height = "${40.0*scale}px";
  }
  void onElementMove(double xOffset, double yOffset){
    gameObject.x += xOffset;
    gameObject.y += yOffset;
    onPropertyInputChange();
  }
  Element createElement(){
    el_marker = new DivElement();
    el_marker.className = "marker";
    Element el = super.createElement();
    el.append(el_marker);
    return el;
  }
  Element createControlsElement(){
    var el = super.createControlsElement();
    var table = new UiTable(6,4);
    el.append(table.element);

    var step = 10.0;
    var stepAngle = Math.pi/16;
    table.append(1,0,new UiButtonIcon("arrow_drop_up",(){gameObject.y -= step; onPropertyInputChange();}));
    table.append(1,2,new UiButtonIcon("arrow_drop_down",(){gameObject.y += step; onPropertyInputChange();}));
    table.append(0,1,new UiButtonIcon("arrow_left",(){gameObject.x -= step; onPropertyInputChange();}));
    table.append(2,1,new UiButtonIcon("arrow_right",(){gameObject.x += step; onPropertyInputChange();}));
    table.append(3,0,new UiButtonIcon("expand_less",(){gameObject.lengthBefore -= step; gameObject.lengthAfter -= step; onPropertyInputChange();}));
    table.append(3,1,new UiButtonIcon("expand_more",(){gameObject.lengthBefore += step; gameObject.lengthAfter += step; onPropertyInputChange();}));
    table.append(4,0,new UiButtonIcon("unfold_less",(){gameObject.width -= step; onPropertyInputChange();}));
    table.append(4,1,new UiButtonIcon("unfold_more",(){gameObject.width += step; onPropertyInputChange();}));
    table.append(0,3,new UiButtonIcon("rotate_left",(){gameObject.angle -= stepAngle; onPropertyInputChange();}));
    table.append(1,3,new UiButtonIcon("rotate_right",(){gameObject.angle += stepAngle; onPropertyInputChange();}));
    table.append(2,3,new UiButtonIcon("rotate_90_degrees_ccw",(){ autoAngle(); onPropertyInputChange();}));
    return el;
  }

  void autoAngle(){
    var checkpoints = editor.gamelevel.path.checkpoints;
    if(checkpoints.length < 3) return;
    var index = checkpoints.indexOf(gameObject);
    GameLevelCheckPoint before, after;
    if(index == 0){
      before = checkpoints.last;
      after = checkpoints[index+1];
    }else if(index == checkpoints.length-1){
      before = checkpoints[index-1];
      after = checkpoints[0];
    }else{
      before = checkpoints[index-1];
      after = checkpoints[index+1];
    }
    var vbefore = new Vector(before.x, before.y);
    var vafter = new Vector(after.x, after.y);
    gameObject.angle = vbefore.angleWithThis(vafter);
  }
}
class LevelObject{
  LevelEditor editor;
  Element element;
  Element el_properties;
  Element el_controls;
  String className = "";
  int _mouseX;
  int _mouseY;
  bool _mouseDown = false;
  double scale = 0.5;
  List<UiInput> properties = [];

  LevelObject(this.editor);

  OnPropertyChanged onPropertyChanged = _onPropertyChangedDefault;
  OnSelect onSelect = _onSelectDefault;
  static void _onPropertyChangedDefault(LevelObject o){}
  static void _onSelectDefault(LevelObject o){}

  void onPropertyInputChange(){
    onPropertyChanged(this);
    updateElement();
    updateProperties();
  }

  void setScale(double value){
    scale = value;
    updateElement();
  }

  void updateProperties(){}
  void updateElement(){}
  void onElementMove(double xOffset, double yOffset){}

  Element createElement(){
    Element el = new DivElement();
    el.className = "levelobj $className";
    el.onMouseDown.listen(_onMouseDown);
    document.onMouseUp.listen(_onMouseUp);
    document.onMouseMove.listen(_onMouseMove);
    element = el;
    createPropertiesElement();
    createControlsElement();
    updateElement();
    updateProperties();
    return el;
  }
  Element createPropertiesElement(){
    Element el = new DivElement();
    for(var form in properties){
      el.append(form.element);
    }
    el_properties = el;
    return el;
  }
  Element createControlsElement(){
    Element el = new DivElement();
    el_controls = el;
    return el;
  }
  void onDeselect(){
    element.classes.remove("selected");
  }

  void _onMouseDown(MouseEvent e){
    e.preventDefault();
    _mouseX = e.page.x;
    _mouseY = e.page.y;
    _mouseDown = true;
    onSelect(this);
    element.classes.add("selected");
  }
  void _onMouseUp(MouseEvent e){
    if(!_mouseDown) return;
    e.preventDefault();
    _mouseX = e.page.x;
    _mouseY = e.page.y;
    _mouseDown = false;
  }
  void _onMouseMove(MouseEvent e){
    if(!_mouseDown) return;
    e.preventDefault();
    int mx = e.page.x;
    int my = e.page.y;
    int difX = mx-_mouseX;
    int difY = my-_mouseY;
    onElementMove(difX/scale,difY/scale);
    _mouseX = e.page.x;
    _mouseY = e.page.y;
  }
}
