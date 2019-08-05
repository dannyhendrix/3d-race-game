part of game.leveleditor;

typedef OnSelect(LevelObject o);
typedef OnDelete(LevelObject o);
typedef OnPropertyChanged(LevelObject o);
/*
class LevelObjectCheckPoint extends LevelObjectCircle{
  LevelObjectCheckPoint(GameLevelCheckPoint value){
    x = value.x;
    y = value.z;
    w = value.radius*2;
    className = "checkpoint";
  }

  GameLevelCheckPoint createGameObject(){
    return new GameLevelCheckPoint(x,y,(w/2).toDouble());
  }
}
class LevelObjectWall extends LevelObject{
  LevelObjectWall(GameLevelWall value){
    x = value.x;
    y = value.z;
    w = value.w;
    h = value.d;
    r = value.r;
    className = "wall";
  }

  GameLevelWall createGameObject(){
    return new GameLevelWall(x,y,r,w,h,100.0);
  }
}
class LevelObjectStaticObject extends LevelObject{
  LevelObjectStaticObject(GameLevelStaticObject value){
    x = value.x;
    y = value.z;
    r = value.r;
    w = 20.0;
    h = 20.0;
    className = "staticobject";
  }

  GameLevelStaticObject createGameObject(){
    return new GameLevelStaticObject(1, x,y, r);
  }
}

class LevelObjectCircle extends LevelObject{
  LevelObjectCircle(){
    canResizeH = false;
    canRotate = false;
  }
  void update(){
    h = w;
    super.update();
    element.style.borderRadius = "${w}px";
  }
}
*/
/*
class LevelObjectXYWHR extends LevelObject
{
  InputFormDouble input_x = new InputFormDouble("x");
  InputFormDouble input_y = new InputFormDouble("y");
  InputFormDouble input_w = new InputFormDouble("w");
  InputFormDouble input_h = new InputFormDouble("h");
  InputFormDouble input_r = new InputFormDouble("r");

  LevelObjectXYR()
  {
    properties = [input_x, input_y, input_w, input_h, input_r];
  }

  void onPropertyInputChange(InputForm form)
  {
    super.onPropertyInputChange(form);
  }

  void updateElement()
  {
    double hw = input_w.getValue() / 2;
    double hh = input_h.getValue() / 2;
    element.style.top = "${(input_y.getValue() - hh) * _scale}px";
    element.style.left = "${(input_x.getValue() - hw) * _scale}px";
    element.style.width = "${input_w.getValue() * _scale}px";
    element.style.height = "${input_h.getValue() * _scale}px";
    element.style.transform = "rotate(${input_r.getValue()}rad)";
  }

  void onElementMove(double xOffset, double yOffset)
  {
    input_x.setValue(input_x.getValue() + xOffset / _scale);
    input_y.setValue(input_y.getValue() + yOffset / _scale);
  }
}
*/
class LevelObjectWall extends LevelObject{
  GameLevelWall gameObject;
  InputFormDouble input_x = new InputFormDouble("x");
  InputFormDouble input_y = new InputFormDouble("y");
  InputFormDouble input_w = new InputFormDouble("w");
  InputFormDouble input_h = new InputFormDouble("h");
  InputFormDouble input_r = new InputFormDouble("r");
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
}
class LevelObjectStaticObject extends LevelObject{
  GameLevelStaticObject gameObject;
  InputFormDouble input_x = new InputFormDouble("x");
  InputFormDouble input_y = new InputFormDouble("y");
  InputFormDouble input_r = new InputFormDouble("r");
  InputFormInt input_id = new InputFormInt("id");
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
}
class LevelObjectCheckpoint extends LevelObject{
  Element el_marker;
  GameLevelCheckPoint gameObject;
  InputFormDouble input_x = new InputFormDouble("x");
  InputFormDouble input_y = new InputFormDouble("y");
  InputFormDouble input_width = new InputFormDouble("width");
  InputFormDoubleSlider input_angle = new InputFormDoubleSlider("angle",0.0,Math.pi*2,32);
  InputFormDouble input_lengthBefore = new InputFormDouble("lengthBefore");
  InputFormDouble input_lengthAfter = new InputFormDouble("lengthAfter");
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
  Element createPropertiesElement(){
    var el = super.createPropertiesElement();
    el.append(new UITextButton("AutoAngle",(e){
      _autoAngle();
    }).createElement());
    return el;
  }
  void _autoAngle(){
    var checkpoints = editor.gamelevel.path.checkpoints;
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
    onPropertyInputChange();
  }
}
class LevelObject{
  LevelEditor editor;
  Element element;
  Element el_properties;
  String className = "";
  int _mouseX;
  int _mouseY;
  bool _mouseDown = false;
  double scale = 0.5;
  List<InputForm> properties = [];

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
    updateElement();
    updateProperties();
    return el;
  }
  Element createPropertiesElement(){
    Element el = new DivElement();
    for(InputForm form in properties){
      el.append(form.createElement());
    }
    el_properties = el;
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
/*
class LevelObject{
  double x = 0.0; double y = 0.0; double w = 10.0; double h = 10.0; double r = 0.0;
  bool canResizeW = true;
  bool canResizeH = true;
  bool canMoveX = true;
  bool canMoveY = true;
  bool canRotate = true;
  String className = "";

  Element element;
  int _mouseX;
  int _mouseY;
  bool _mouseDown = false;
  double _scale = 0.5;

  OnSelect onSelect = _onSelectDefault;
  OnMove onMove = _onMoveDefault;

  static void _onMoveDefault(LevelObject o){}
  static void _onSelectDefault(LevelObject o){}

  Element createElement(){
    Element el = new DivElement();
    el.className = "levelobj $className";
    el.onMouseDown.listen(_onMouseDown);
    document.onMouseUp.listen(_onMouseUp);
    document.onMouseMove.listen(_onMouseMove);
    element = el;
    return el;
  }
  void setScale(double scale){
    _scale = scale;
    update();
  }
  void update(){
    double hw = w/2;
    double hh = h/2;
    element.style.top = "${(y-hh)*_scale}px";
    element.style.left = "${(x-hw)*_scale}px";
    element.style.width = "${w*_scale}px";
    element.style.height = "${h*_scale}px";
    element.style.transform = "rotate(${r}rad)";
  }

  void _onMouseDown(MouseEvent e){
    e.preventDefault();
    _mouseX = e.page.x;
    _mouseY = e.page.y;
    _mouseDown = true;
    onSelect(this);
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
    x += difX/_scale;
    y += difY/_scale;
    update();
    _mouseX = e.page.x;
    _mouseY = e.page.y;
    onMove(this);
  }
}
*/