part of game.leveleditor;

class LevelObjectPropertiesMenu extends EditorMenu {
  LevelObject _currentLevelObject;
  LevelObjectPropertiesMenu(ILifetime lifetime) : super(lifetime) {}

  @override
  void build() {
    super.build();
    changeTitle("Properties");
    addStyle("properties");
  }

  @override
  void onSelectObject(LevelObject o) {
    clear();
    append(o._propertiesPanel);
    _currentLevelObject = o;
  }

  @override
  void onDeleteObject(LevelObject o) {
    if (o != _currentLevelObject) return;
    _currentLevelObject = null;
    clear();
  }
}
