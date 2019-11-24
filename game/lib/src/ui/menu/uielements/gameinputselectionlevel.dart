part of game.menu;

class LevelPreviewController {
  LevelPreview _preview;
  LevelManager _levelManager;
  Map<String, String> _typeToPreview = {};

  LevelPreviewController(ILifetime lifetime) {
    _levelManager = lifetime.resolve();
    _preview = lifetime.resolve();
  }

  void loadAll(List<String> options) {
    options.forEach(_loadLevel);
  }

  String getPreview(String level) {
    return _typeToPreview[level];
  }

  void _loadLevel(String level) {
    _typeToPreview[level] = _createPreviewFromModel(_levelManager.getLevel(level));
  }

  String _createPreviewFromModel(GameLevel level) {
    _preview.setSize(150, 100);
    _preview.clear();
    _preview.draw(level, "#666");
    return _preview.canvas.toDataUrl("image/png");
  }
}

class GameInputSelectionLevel extends UiInputOptionCycle<String> {
  ImageElement img_preview;
  GameSettings _settings;
  LevelPreviewController _previewController;

  GameInputSelectionLevel(ILifetime lifetime) : super(lifetime) {
    _settings = lifetime.resolve();
    _previewController = lifetime.resolve();
    img_preview = new ImageElement();
  }
  @override
  void build() {
    super.build();
    changeLabel("Track");
    addStyle("GameInputSelection");
    appendElementToContent(img_preview);
  }

  @override
  void setValue(String newValue) {
    super.setValue(newValue);
    img_preview.src = _previewController.getPreview(newValue);
  }

  @override
  void setOptions(List<String> options) {
    super.setOptions(options);
    _previewController.loadAll(options);
  }
}
