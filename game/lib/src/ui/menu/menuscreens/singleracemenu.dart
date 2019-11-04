part of game.menu;

class SingleRaceMenu extends GameMenuScreen{
  GameMenuController menu;
  GameInputSelectionVehicle _vehicleSelection;
  GameInputSelectionTrailer _trailerSelection;
  GameInputSelectionLevel _levelSelection;
  UiInputOptionRadio _in_laps;
  UiInputOptionRadio _in_oponents;
  UiInputTextLarge in_levelJson;

  SingleRaceMenu(this.menu){
  }

  UiContainer setupFields()
  {
    closebutton = false;

    var el = super.setupFields();
    var el_left = new UiPanel();
    var el_right = new UiPanel();
    el_left.addStyle("leftPanel");
    el_right..addStyle("rightPanel");
    el.append(el_left);
    el.append(el_right);


    _vehicleSelection = new GameInputSelectionVehicle();
    _trailerSelection = new GameInputSelectionTrailer();
    _levelSelection = new GameInputSelectionLevel(menu.levelManager);

    _in_oponents = new UiInputOptionRadio("Oponents", [0,1,2,3,4]);
    _in_oponents.setValue(3);

    _in_laps = new UiInputOptionRadio("Laps",[1,2,3,5,10]);
    _in_laps.setValue(2);

    el_left.append(_levelSelection.setupFieldsForLevels(_createLevelJsonInput(),menu.settings.levels_allowJsonInput.v));

    el_left.append(_in_laps);

    el_right.append(_vehicleSelection.setupFieldsForVehicles());
    el_right.append(_trailerSelection.setupFieldsForTrailers());
    el_right.append(_in_oponents);

    el.append(createMenuButtonWithIcon("Start","play_arrow",(){
      menu.showMenu(new GameInputMenuStatus("Single race", createGameInput(), (GameOutput result){
        menu.showMenu(new GameOutputMenuStatus("Race results", result));
      }));
    }));

    _vehicleSelection.onIndexChanged(-1, 0);
    _trailerSelection.onIndexChanged(-1, 0);
    _levelSelection.onIndexChanged(-1, 0);

    return el;
  }

  UiElement _createLevelJsonInput(){
    var el = new UiPanel();
    in_levelJson = new UiInputTextLarge("");
    in_levelJson.addStyle("leveljson");
    AnchorElement el_editorLink = new AnchorElement();
    el_editorLink.href = menu.settings.editor_location.v;
    el_editorLink.className = "button";
    el_editorLink.text = "Open level editor";
    el_editorLink.target = "_blank";
    el.append(in_levelJson);
    el.appendElement(new BRElement());
    el.appendElement(el_editorLink);
    return el;
  }

  GameInput createGameInput(){
    var levelLoader = new GameLevelLoader();
    var level = (in_levelJson != null && in_levelJson.getValue().isNotEmpty) ? levelLoader.loadLevelJson(jsonDecode(in_levelJson.getValue())) : menu.levelManager.getLevel(_levelSelection.getSelectedValue());
    return menu.gameBuilder.newGameRandomPlayers(_in_oponents.getValue(),VehicleType.values[_vehicleSelection.index], TrailerType.values[_trailerSelection.index],level, _in_laps.getValue());
  }
}