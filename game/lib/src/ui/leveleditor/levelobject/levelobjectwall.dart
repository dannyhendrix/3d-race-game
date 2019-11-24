part of game.leveleditor;

class LevelObjectWall extends LevelObject {
  ILifetime _lifetime;
  GameLevelWall gameObject;
  UiInputDouble input_x;
  UiInputDouble input_y;
  UiInputDouble input_w;
  UiInputDouble input_h;
  UiInputDouble input_r;
  UiTable _controlsTable;

  LevelObjectWall(ILifetime lifetime) : super(lifetime) {
    _lifetime = lifetime;
    input_x = lifetime.resolve();
    input_y = lifetime.resolve();
    input_w = lifetime.resolve();
    input_h = lifetime.resolve();
    input_r = lifetime.resolve();
    _controlsTable = lifetime.resolve();
  }
  @override
  void build() {
    super.build();
    addStyle("wall");
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
    input_w
      ..changeLabel("w")
      ..onValueChange = (double value) {
        gameObject.w = value;
        onPropertyInputChange();
      };
    input_h
      ..changeLabel("h")
      ..onValueChange = (double value) {
        gameObject.h = value;
        onPropertyInputChange();
      };
    input_r
      ..changeLabel("r")
      ..onValueChange = (double value) {
        gameObject.r = value;
        onPropertyInputChange();
      };
    setProperties([input_x, input_y, input_w, input_h, input_r]);
    buildControlsTable();
    setControls(_controlsTable);
  }

  void updateProperties() {
    input_x.setValue(gameObject.x);
    input_y.setValue(gameObject.y);
    input_w.setValue(gameObject.w);
    input_h.setValue(gameObject.h);
    input_r.setValue(gameObject.r);
  }

  void updateElement() {
    double hw = gameObject.w / 2;
    double hh = gameObject.h / 2;
    element.style.top = "${(gameObject.y - hh) * scale}px";
    element.style.left = "${(gameObject.x - hw) * scale}px";
    element.style.width = "${gameObject.w * scale}px";
    element.style.height = "${gameObject.h * scale}px";
    element.style.transform = "rotate(${gameObject.r}rad)";
  }

  void onElementMove(double xOffset, double yOffset) {
    gameObject.x += xOffset;
    gameObject.y += yOffset;
    onPropertyInputChange();
  }

  void buildControlsTable() {
    const double step = 10.0;
    const double stepAngle = Math.pi / 16;
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
        _lifetime.resolve<UiButtonIcon>()
          ..changeIcon("keyboard_arrow_up")
          ..setOnClick(() {
            gameObject.h -= step;
            onPropertyInputChange();
          }),
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
        _lifetime.resolve<UiButtonIcon>()
          ..changeIcon("keyboard_arrow_left")
          ..setOnClick(() {
            gameObject.w -= step;
            onPropertyInputChange();
          }),
        null,
        _lifetime.resolve<UiButtonIcon>()
          ..changeIcon("keyboard_arrow_right")
          ..setOnClick(() {
            gameObject.w += step;
            onPropertyInputChange();
          })
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
        _lifetime.resolve<UiButtonIcon>()
          ..changeIcon("keyboard_arrow_down")
          ..setOnClick(() {
            gameObject.h += step;
            onPropertyInputChange();
          }),
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
