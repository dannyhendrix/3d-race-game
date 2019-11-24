part of game.leveleditor;

class LevelObjectControlsMenu extends EditorMenu {
  UiPanel _controlsPanel;
  UiButtonIcon _buttonDelete;
  LevelObject _currentLevelObject;

  LevelObjectControlsMenu(ILifetime lifetime) : super(lifetime) {
    _controlsPanel = lifetime.resolve();
    _buttonDelete = lifetime.resolve();
  }

  @override
  void build() {
    super.build();
    _buttonDelete
      ..changeIcon("delete")
      ..setOnClick(() {
        if (_currentLevelObject == null) return;
        _editor.deleteLevelObject(_currentLevelObject);
      });
    changeTitle("Controls");
    addStyle("controls");
    append(_controlsPanel);
    append(_buttonDelete);
    showDelete(false);
  }

  @override
  void onSelectObject(LevelObject o) {
    _controlsPanel.clear();
    _controlsPanel.append(o._controlsPanel);
    _currentLevelObject = o;
    showDelete(true);
  }

  @override
  void onDeleteObject(LevelObject o) {
    if (o != _currentLevelObject) return;
    _currentLevelObject = null;
    _controlsPanel.clear();
    showDelete(false);
  }

  void showDelete(bool show) {
    if (show)
      _buttonDelete.show();
    else
      _buttonDelete.hide();
  }
}
