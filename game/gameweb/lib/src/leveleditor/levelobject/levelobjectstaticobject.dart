part of game.leveleditor;

class LevelObjectStaticObject extends LevelObject {
  ILifetime _lifetime;
  GameLevelStaticObject gameObject;
  UiInputDouble input_x;
  UiInputDouble input_y;
  UiInputDouble input_r;
  UiInputInt input_id;
  UiTable _controlsTable;

  LevelObjectStaticObject(ILifetime lifetime) : super(lifetime) {
    _lifetime = lifetime;
    input_x = lifetime.resolve();
    input_y = lifetime.resolve();
    input_r = lifetime.resolve();
    input_id = lifetime.resolve();
    _controlsTable = lifetime.resolve();
  }
  @override
  void build() {
    super.build();
    addStyle("staticobject");
    input_x
      ..changeLabel("x")
      ..onValueChange = (double value) {
        gameObject.x = value;
        onPropertyInputChange();
      };
    input_y
      ..changeLabel("y")
      ..onValueChange = (double value) {
        gameObject.y = value;
        onPropertyInputChange();
      };
    input_r
      ..changeLabel("r")
      ..onValueChange = (double value) {
        gameObject.r = value;
        onPropertyInputChange();
      };
    input_id
      ..changeLabel("id")
      ..onValueChange = (int value) {
        gameObject.id = value;
        onPropertyInputChange();
      };
    setProperties([input_x, input_y, input_r, input_id]);
    buildControlsTable();
    setControls(_controlsTable);
  }

  void updateProperties() {
    input_x.setValue(gameObject.x);
    input_y.setValue(gameObject.y);
    input_r.setValue(gameObject.r);
    input_id.setValue(gameObject.id);
  }

  void updateElement() {
    double w = 20.0;
    double h = 20.0;
    double hw = w / 2;
    double hh = h / 2;
    element.style.top = "${(gameObject.y - hh) * scale}px";
    element.style.left = "${(gameObject.x - hw) * scale}px";
    element.style.width = "${w * scale}px";
    element.style.height = "${h * scale}px";
    element.style.transform = "rotate(${gameObject.r}rad)";
  }

  void onElementMove(double xOffset, double yOffset) {
    gameObject.x += xOffset;
    gameObject.y += yOffset;
    onPropertyInputChange();
  }

  void buildControlsTable() {
    const double step = 10.0;
    const double stepAngle = pi / 16;
    _controlsTable
      ..addRow([
        null,
        _lifetime.resolve<UiButtonIcon>()
          ..changeIcon("arrow_drop_up")
          ..setOnClick(() {
            gameObject.y -= step;
            onPropertyInputChange();
          }),
        null,
        null,
        null,
        null
      ])
      ..addRow([
        _lifetime.resolve<UiButtonIcon>()
          ..changeIcon("arrow_left")
          ..setOnClick(() {
            gameObject.x -= step;
            onPropertyInputChange();
          }),
        null,
        _lifetime.resolve<UiButtonIcon>()
          ..changeIcon("arrow_right")
          ..setOnClick(() {
            gameObject.x += step;
            onPropertyInputChange();
          }),
        null,
        null,
        null
      ])
      ..addRow([
        null,
        _lifetime.resolve<UiButtonIcon>()
          ..changeIcon("arrow_drop_down")
          ..setOnClick(() {
            gameObject.y += step;
            onPropertyInputChange();
          }),
        null,
        null,
        null,
        null
      ])
      ..addRow([
        _lifetime.resolve<UiButtonIcon>()
          ..changeIcon("rotate_left")
          ..setOnClick(() {
            gameObject.r -= stepAngle;
            onPropertyInputChange();
          }),
        _lifetime.resolve<UiButtonIcon>()
          ..changeIcon("rotate_right")
          ..setOnClick(() {
            gameObject.r += stepAngle;
            onPropertyInputChange();
          }),
        null,
        null,
        null,
        null
      ]);
  }
}
