part of game.leveleditor;

class LevelObjectCheckpoint extends LevelObject {
  LevelEditor _editor;
  ILifetime _lifetime;
  UiPanel _markerPanel;
  UiTable _controlsTable;
  GameLevelCheckPoint gameObject;
  UiInputDouble input_x;
  UiInputDouble input_y;
  UiInputDouble input_width;
  UiInputDoubleSlider input_angle;
  UiInputDouble input_lengthBefore;
  UiInputDouble input_lengthAfter;

  LevelObjectCheckpoint(ILifetime lifetime) : super(lifetime) {
    _lifetime = lifetime;
    _editor = lifetime.resolve();
    _controlsTable = lifetime.resolve();
    _markerPanel = lifetime.resolve();
    input_x = lifetime.resolve();
    input_y = lifetime.resolve();
    input_width = lifetime.resolve();
    input_angle = lifetime.resolve();
    input_lengthBefore = lifetime.resolve();
    input_lengthAfter = lifetime.resolve();
  }

  @override
  void build() {
    super.build();
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
    input_width
      ..changeLabel("width")
      ..onValueChange = (double value) {
        gameObject.width = value;
        onPropertyInputChange();
      };
    input_angle
      ..changeLabel("angle")
      ..setMin(0.0)
      ..setMax(pi * 2)
      ..setSteps(32)
      ..onValueChange = (double value) {
        gameObject.angle = value;
        onPropertyInputChange();
      };
    input_lengthBefore
      ..changeLabel("lengthBefore")
      ..onValueChange = (double value) {
        gameObject.lengthBefore = value;
        onPropertyInputChange();
      };
    input_lengthBefore
      ..changeLabel("lengthAfter")
      ..onValueChange = (double value) {
        gameObject.lengthAfter = value;
        onPropertyInputChange();
      };
    setProperties([input_x, input_y, input_width, input_angle, input_lengthBefore, input_lengthAfter]);
    buildControlsTable();
    setControls(_controlsTable);
    addStyle("checkpoint");
    _markerPanel.addStyle("marker");
    append(_markerPanel);
  }

  void updateProperties() {
    input_x.setValue(gameObject.x);
    input_y.setValue(gameObject.y);
    input_width.setValue(gameObject.width);
    input_angle.setValue(gameObject.angle);
    input_lengthBefore.setValue(gameObject.lengthBefore);
    input_lengthAfter.setValue(gameObject.lengthAfter);
  }

  void updateElement() {
    var fullRadius = gameObject.width;
    element.style.top = "${(gameObject.y - gameObject.width / 2) * scale}px";
    element.style.left = "${(gameObject.x - gameObject.width / 2) * scale}px";
    element.style.width = "${fullRadius * scale}px";
    element.style.height = "${fullRadius * scale}px";
    element.style.borderRadius = "${fullRadius * scale}px";
    _markerPanel.element.style.top = "${(gameObject.width / 2 - 20.0) * scale}px";
    _markerPanel.element.style.left = "${(gameObject.width / 2 - 20.0) * scale}px";
    _markerPanel.element.style.width = "${40.0 * scale}px";
    _markerPanel.element.style.height = "${40.0 * scale}px";
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
        _lifetime.resolve<UiButtonIcon>()
          ..changeIcon("expand_less")
          ..setOnClick(() {
            gameObject.lengthBefore -= step;
            gameObject.lengthAfter -= step;
            onPropertyInputChange();
          }),
        _lifetime.resolve<UiButtonIcon>()
          ..changeIcon("unfold_less")
          ..setOnClick(() {
            gameObject.width -= step;
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
          ..changeIcon("expand_more")
          ..setOnClick(() {
            gameObject.lengthBefore += step;
            gameObject.lengthAfter += step;
            onPropertyInputChange();
          }),
        _lifetime.resolve<UiButtonIcon>()
          ..changeIcon("unfold_more")
          ..setOnClick(() {
            gameObject.width += step;
            onPropertyInputChange();
          }),
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
            gameObject.angle -= stepAngle;
            onPropertyInputChange();
          }),
        _lifetime.resolve<UiButtonIcon>()
          ..changeIcon("rotate_right")
          ..setOnClick(() {
            gameObject.angle += stepAngle;
            onPropertyInputChange();
          }),
        _lifetime.resolve<UiButtonIcon>()
          ..changeIcon("rotate_90_degrees_ccw")
          ..setOnClick(() {
            autoAngle();
            onPropertyInputChange();
          }),
        null,
        null,
        null
      ]);
  }

  void autoAngle() {
    var checkpoints = _editor.gamelevel.path.checkpoints;
    if (checkpoints.length < 3) return;
    var index = checkpoints.indexOf(gameObject);
    GameLevelCheckPoint before, after;
    if (index == 0) {
      before = checkpoints.last;
      after = checkpoints[index + 1];
    } else if (index == checkpoints.length - 1) {
      before = checkpoints[index - 1];
      after = checkpoints[0];
    } else {
      before = checkpoints[index - 1];
      after = checkpoints[index + 1];
    }
    var vbefore = new Vector(before.x, before.y);
    var vafter = new Vector(after.x, after.y);
    gameObject.angle = vbefore.angleWithThis(vafter);
  }
}
