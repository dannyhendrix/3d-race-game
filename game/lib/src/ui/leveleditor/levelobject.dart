part of game.leveleditor;

typedef OnSelect(LevelObject o);
typedef OnMove(LevelObject o);

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