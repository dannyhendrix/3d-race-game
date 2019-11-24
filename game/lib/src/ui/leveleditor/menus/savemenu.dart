part of game.leveleditor;

class SaveMenu extends EditorMenu {
  UiInputTextLarge _inputContent;
  UiInputText _inputSet;
  UiInputText _inputLevel;
  UiButtonIcon _buttonSave;
  UiButtonIcon _buttonLoad;

  SaveMenu(ILifetime lifetime) : super(lifetime) {
    _inputContent = lifetime.resolve();
    _inputSet = lifetime.resolve();
    _inputLevel = lifetime.resolve();
    _buttonSave = lifetime.resolve();
    _buttonLoad = lifetime.resolve();
  }

  @override
  void build() {
    super.build();
    changeTitle("Load/Save from file");
    // text area
    _inputContent
      ..changeLabel("Content")
      ..onValueChange = (String val) {
        Map json = jsonDecode(_inputContent.getValue());
        _editor.loadFromJson(json);
      };
    append(_inputContent);

    // save/load
    _inputSet
      ..changeLabel("Set")
      ..setValue("race");
    _inputLevel
      ..changeLabel("Level")
      ..setValue("level1");
    append(_inputSet);
    append(_inputLevel);
    append(_buttonLoad);
    append(_buttonSave);

    _buttonSave
      ..changeIcon("cloud_upload")
      ..setOnClick(() {
        var data = _editor.saveToJson();
        HttpRequest.postFormData('http://localhost/0004-dart/MicroMachines/game/web/server/server.php', {"a": "save", "set": _inputSet.getValue(), "level": _inputLevel.getValue(), "data": data}).then((data) {
          print("Saved ok");
        });
      });

    _buttonLoad
      ..changeIcon("cloud_download")
      ..setOnClick(() {
        var levelset = _inputSet.getValue();
        var level = _inputLevel.getValue();
        var loader = new PreLoader(() {
          _editor.loadFromJson(JsonController.getJson("level/$levelset/$level"));
        });
        loader.loadJson("levels/$levelset/$level.json", "level/$levelset/$level");
        loader.start();
      });
  }

  @override
  void onGameLevelChange(GameLevel gamelevel) {
    _inputContent.setValue(_editor.saveToJson());
  }
}
