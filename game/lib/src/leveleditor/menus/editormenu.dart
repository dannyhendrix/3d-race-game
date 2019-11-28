part of game.leveleditor;

abstract class EditorMenu extends UiPanelTitled {
  LevelEditor _editor;
  EditorMenu(ILifetime lifetime) : super(lifetime);
  void setEditor(LevelEditor editor) => _editor = editor;
  void onGameLevelChange(GameLevel gamelevel) {}
  void onDeleteObject(LevelObject object) {}
  void onSelectObject(LevelObject object) {}
}
