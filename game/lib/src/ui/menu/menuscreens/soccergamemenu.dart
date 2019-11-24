part of game.menu;

class SoccerGameMenu extends GameMenuScreen {
  LevelManager _levelManager;
  GameInputSelectionVehicle _vehicleSelection;
  GameInputSelectionTrailer _trailerSelection;
  GameInputSelectionLevel _levelSelection;
  UiInputOptionRadio _in_scorelimit;
  UiInputOptionRadio _in_teams;
  UiInputOptionRadio _in_playersperteam;
  UiPanel _panelLeft;
  UiPanel _panelRight;
  MenuButton _btnStart;

  SoccerGameMenu(ILifetime lifetime) : super(lifetime, GameMenuPage.Soccer) {
    _levelManager = lifetime.resolve();
    _panelLeft = lifetime.resolve();
    _panelRight = lifetime.resolve();
    _in_scorelimit = lifetime.resolve();
    _in_teams = lifetime.resolve();
    _in_playersperteam = lifetime.resolve();
    _levelSelection = lifetime.resolve();
    _btnStart = lifetime.resolve();
    _vehicleSelection = lifetime.resolve();
    _trailerSelection = lifetime.resolve();

    showClose = false;
    title = "Single race";
  }

  @override
  void build() {
    super.build();

    _panelLeft.addStyle("leftPanel");
    _panelRight..addStyle("rightPanel");
    append(_panelLeft);
    append(_panelRight);

    _in_teams
      ..changeLabel("Teams")
      ..setOptions([2, 3, 4, 5, 6])
      ..setValue(2);
    _in_playersperteam
      ..changeLabel("Players per team")
      ..setOptions([1, 2, 3, 4, 10, 20])
      ..setValue(2);
    _in_scorelimit
      ..changeLabel("Score limit")
      ..setOptions([3, 5, 10])
      ..setValue(5);
    _vehicleSelection..changeLabel("Vehicle");
    _trailerSelection..changeLabel("Trailer");

    _panelLeft.append(_levelSelection);

    _panelLeft.append(_in_scorelimit);

    _panelRight.append(_vehicleSelection);
    _panelRight.append(_trailerSelection);
    _panelRight.append(_in_teams);
    _panelRight.append(_in_playersperteam);

    _btnStart
      ..changeText("Start")
      ..changeIcon("play_arrow")
      ..setOnClick(() {
        _menu.showMenu(new GameInputMenuStatus("Soccer", createGameInput(), (GameOutput result) {
          _menu.showMenu(new GameOutputMenuStatus("Soccer results", result));
        }));
      });
    append(_btnStart);

    _vehicleSelection.setValue(VehicleType.Car);
    _trailerSelection.setValue(TrailerType.None);
  }

  GameInput createGameInput() {
    return _menu.gameBuilder.newSoccerGame(_in_teams.getValue(), _in_playersperteam.getValue(), VehicleType.values[_vehicleSelection.index], TrailerType.values[_trailerSelection.index], _levelManager.getLevel(_levelSelection.getValue()), _in_scorelimit.getValue());
  }
}
