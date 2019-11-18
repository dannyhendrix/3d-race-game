part of game.menu;

class SingleRaceMenu extends GameMenuScreen{
  GameInputSelectionVehicle _vehicleSelection;
  GameInputSelectionTrailer _trailerSelection;
  GameInputSelectionLevel _levelSelection;
  UiInputOptionRadio _in_laps;
  UiInputOptionRadio _in_oponents;
  UiPanel _panelLeft;
  UiPanel _panelRight;
  MenuButton _btnStart;


  SingleRaceMenu(ILifetime lifetime) : super(lifetime, GameMenuPage.SingleGame){
    _panelLeft = lifetime.resolve();
    _panelRight = lifetime.resolve();
    _in_oponents = lifetime.resolve();
    _in_laps = lifetime.resolve();
    _levelSelection = lifetime.resolve();
    _btnStart = lifetime.resolve();
    _vehicleSelection = lifetime.resolve();
    _trailerSelection = lifetime.resolve();

    showClose = false;
    title = "Single race";
  }

  @override
  void build(){
    super.build();

    _panelLeft.addStyle("leftPanel");
    _panelRight..addStyle("rightPanel");
    append(_panelLeft);
    append(_panelRight);

    _in_oponents..changeLabel("Oponents")..setOptions([0,1,2,3,4])..setValue(3);
    _in_laps..changeLabel("Laps")..setOptions([1,2,3,5,10])..setValue(2);
    _vehicleSelection..changeLabel("Vehicle");
    _trailerSelection..changeLabel("Trailer");

    _panelLeft.append(_levelSelection);

    _panelLeft.append(_in_laps);

    _panelRight.append(_vehicleSelection);
    _panelRight.append(_trailerSelection);
    _panelRight.append(_in_oponents);

    _btnStart..changeText("Start")..changeIcon("play_arrow")..setOnClick((){
        _menu.showMenu(new GameInputMenuStatus("Single race", createGameInput(), (GameOutput result){
          _menu.showMenu(new GameOutputMenuStatus("Race results", result));
      }));
    });
    append(_btnStart);

    _vehicleSelection.setValueIndex(0);
    _trailerSelection.setValueIndex(0);
    _levelSelection.setValueIndex(0);
  }

  GameInput createGameInput(){
    return _menu.gameBuilder.newGameRandomPlayers(_in_oponents.getValue(),VehicleType.values[_vehicleSelection.index], TrailerType.values[_trailerSelection.index],_levelSelection.getSelectedLevel(), _in_laps.getValue());
  }

}