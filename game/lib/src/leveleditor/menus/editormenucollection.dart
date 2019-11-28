part of game.leveleditor;

class EditorMenuCollection {
  List<EditorMenu> _menus = [];
  EditorMenuCollection(ILifetime lifetime) {
    var menus = lifetime.resolveList<EditorMenu>();
    for (var menu in menus) {
      _menus.add(menu);
    }
  }
  void setEditor(LevelEditor editor) => _menus.forEach((a) => a.setEditor(editor));
  void onGameLevelChange(GameLevel gamelevel) => _menus.forEach((a) => a.onGameLevelChange(gamelevel));
  void onDeleteObject(LevelObject object) => _menus.forEach((a) => a.onDeleteObject(object));
  void onSelectObject(LevelObject object) => _menus.forEach((a) => a.onSelectObject(object));
  void appendAllTo(UiContainer container) => _menus.forEach((a) => container.append(a));
}
