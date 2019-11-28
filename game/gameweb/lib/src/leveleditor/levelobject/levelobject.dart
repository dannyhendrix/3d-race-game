part of game.leveleditor;

typedef OnSelect(LevelObject o);
typedef OnDelete(LevelObject o);
typedef OnPropertyChanged(LevelObject o);

abstract class LevelObject extends UiPanel {
  UiPanel _propertiesPanel;
  UiPanel _controlsPanel;
  int _mouseX;
  int _mouseY;
  bool _mouseDown = false;
  double scale = 0.5;

  OnPropertyChanged onPropertyChanged = _onPropertyChangedDefault;
  OnSelect onSelect = _onSelectDefault;

  LevelObject(ILifetime lifetime) : super(lifetime) {
    _propertiesPanel = lifetime.resolve();
    _controlsPanel = lifetime.resolve();
  }
  static void _onPropertyChangedDefault(LevelObject o) {}
  static void _onSelectDefault(LevelObject o) {}

  void onPropertyInputChange() {
    onPropertyChanged(this);
    updateElement();
    updateProperties();
  }

  void setScale(double value) {
    scale = value;
    updateElement();
  }

  void updateProperties() {}
  void updateElement() {}
  void onElementMove(double xOffset, double yOffset) {}

  @override
  void build() {
    super.build();
    addStyle("levelobj");
    element.onMouseDown.listen(_onMouseDown);
    document.onMouseUp.listen(_onMouseUp);
    document.onMouseMove.listen(_onMouseMove);
  }

  void setProperties(List<UiInput> properties) {
    for (var form in properties) {
      _propertiesPanel.appendElement(form.element);
    }
  }

  void setControls(UiElement element) {
    _controlsPanel.append(element);
  }

  void onDeselect() {
    removeStyle("selected");
  }

  void _onMouseDown(MouseEvent e) {
    e.preventDefault();
    _mouseX = e.page.x;
    _mouseY = e.page.y;
    _mouseDown = true;
    onSelect(this);
    addStyle("selected");
  }

  void _onMouseUp(MouseEvent e) {
    if (!_mouseDown) return;
    e.preventDefault();
    _mouseX = e.page.x;
    _mouseY = e.page.y;
    _mouseDown = false;
  }

  void _onMouseMove(MouseEvent e) {
    if (!_mouseDown) return;
    e.preventDefault();
    int mx = e.page.x;
    int my = e.page.y;
    int difX = mx - _mouseX;
    int difY = my - _mouseY;
    onElementMove(difX / scale, difY / scale);
    _mouseX = e.page.x;
    _mouseY = e.page.y;
  }
}
