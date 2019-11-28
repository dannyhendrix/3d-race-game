part of game.menu;

class LevelEditorInGame extends UiPanel {
  LevelEditor _levelEditor;
  UiPanel _buttonPanel;
  UiButtonIconText _btnAccept;
  Function onAccept;
  Function onCancel;

  LevelEditorInGame(ILifetime lifetime) : super(lifetime) {
    _levelEditor = lifetime.resolve();
    _btnAccept = lifetime.resolve();
    _btnAccept = lifetime.resolve();
    _buttonPanel = lifetime.resolve();
  }

  @override
  void build() {
    super.build();
    _buttonPanel.addStyle("editorgamemenu");
    append(_levelEditor);
    append(_buttonPanel);
    _buttonPanel.append(_btnAccept);
    //_buttonPanel.append(_btnCancel);
    _btnAccept
      ..changeText("Done")
      ..changeIcon("done")
      ..addStyle("highlight")
      ..setOnClick(() => onAccept?.call());
  }
}

class SingleRaceMenu extends GameMenuScreen {
  GameSettings _settings;
  LevelManager _levelManager;
  GameInputSelectionVehicle _vehicleSelection;
  GameInputSelectionTrailer _trailerSelection;
  GameInputSelectionLevel _levelSelection;
  UiInputOptionRadio _in_laps;
  UiInputOptionRadio _in_oponents;
  UiPanel _panelEditorButton;
  UiPanel _panelLeft;
  UiPanel _panelRight;
  LevelEditorInGame _levelEditor;
  UiButtonText _btnEditor;
  String _editorLevelKey;
  MenuButton _btnStart;

  SingleRaceMenu(ILifetime lifetime) : super(lifetime, GameMenuPage.SingleGame) {
    _settings = lifetime.resolve();
    _levelManager = lifetime.resolve();
    _panelLeft = lifetime.resolve();
    _panelRight = lifetime.resolve();
    _panelEditorButton = lifetime.resolve();
    _in_oponents = lifetime.resolve();
    _in_laps = lifetime.resolve();
    _levelSelection = lifetime.resolve();
    _btnStart = lifetime.resolve();
    _btnEditor = lifetime.resolve();
    _vehicleSelection = lifetime.resolve();
    _trailerSelection = lifetime.resolve();
    _levelEditor = lifetime.resolve();

    showClose = false;
    title = "Single race";
  }

  @override
  void build() {
    super.build();

    _panelLeft.addStyle("leftPanel");
    _panelRight..addStyle("rightPanel");

    _in_oponents
      ..changeLabel("Oponents")
      ..setOptions([0, 1, 2, 3, 4])
      ..setValue(3);
    _in_laps
      ..changeLabel("Laps")
      ..setOptions([1, 2, 3, 5, 10])
      ..setValue(2);
    _vehicleSelection..changeLabel("Vehicle");
    _trailerSelection..changeLabel("Trailer");

    _btnStart
      ..changeText("Start")
      ..changeIcon("play_arrow")
      ..setOnClick(() {
        _menu.showMenu(new GameInputMenuStatus("Single race", createGameInput(), (GameOutput result) {
          _menu.showMenu(new GameOutputMenuStatus("Race results", result));
        }));
      });

    _vehicleSelection.setValue(VehicleType.Car);
    _trailerSelection.setValue(TrailerType.None);
    _levelSelection.setOptions(_levelManager.getLevelKeys().toList());
    _levelSelection.setValue(_levelManager.getLevelKeys().first);

    _btnEditor
      ..changeText("Open editor")
      ..setOnClick(() {
        _editorLevelKey = _levelSelection.getValue();
        _levelEditor._levelEditor.load(_levelManager.getLevel(_editorLevelKey));

        _editorLevelKey = "_custom/${DateTime.now().microsecondsSinceEpoch}";

        _levelEditor.show();
      });

    _levelEditor.onAccept = () {
      _levelManager.loadLevel(_editorLevelKey, _levelEditor._levelEditor.gamelevel);
      _levelSelection.setOptions(_levelManager.getLevelKeys().toList());
      _levelSelection.setValue(_editorLevelKey);
      _levelEditor.hide();
    };
    _levelEditor.hide();

    _panelLeft.append(_levelSelection);
    _panelEditorButton.append(_btnEditor);
    if (_settings.leveleditor_enabled.v) _panelLeft.append(_panelEditorButton);
    _panelLeft.append(_in_laps);

    _panelRight.append(_vehicleSelection);
    _panelRight.append(_trailerSelection);
    _panelRight.append(_in_oponents);

    append(_panelLeft);
    append(_panelRight);
    append(_btnStart);
    append(_levelEditor);
  }

  @override
  void enterMenu(GameMenuStatus status) {
    super.enterMenu(status);
    var current = _levelSelection.getValue();
    _levelSelection.setOptions(_levelManager.getLevelKeys().toList());
    _levelSelection.setValue(current);
  }

  GameInput createGameInput() {
    return _menu.gameBuilder.newGameRandomPlayers(_in_oponents.getValue(), VehicleType.values[_vehicleSelection.index], TrailerType.values[_trailerSelection.index], _levelManager.getLevel(_levelSelection.getValue()), _in_laps.getValue());
  }
}
