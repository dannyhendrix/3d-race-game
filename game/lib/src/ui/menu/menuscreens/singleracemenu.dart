part of game.menu;

class SingleRaceMenu extends GameMenuScreen{
  GameMenuController menu;
  GameInputSelectionVehicle _vehicleSelection;
  GameInputSelectionTrailer _trailerSelection;
  GameInputSelectionLevel _levelSelection;
  UiInputOptionRadio _in_laps;
  UiInputOptionRadio _in_oponents;
  TextAreaElement in_levelJson;

  SingleRaceMenu(this.menu){
  }

  Element setupFields()
  {
    closebutton = false;

    Element el = super.setupFields();
    Element el_left = new DivElement();
    Element el_right = new DivElement();
    el_left.className = "leftPanel";
    el_right.className = "rightPanel";
    el.append(el_left);
    el.append(el_right);


    _vehicleSelection = new GameInputSelectionVehicle();
    _trailerSelection = new GameInputSelectionTrailer();
    _levelSelection = new GameInputSelectionLevel(menu.levelManager);

    _in_oponents = new UiInputOptionRadio("Oponents", [0,1,2,3,4]);
    Element el_oponents = _in_oponents.element;
    _in_oponents.setValue(3);

    _in_laps = new UiInputOptionRadio("Laps",[1,2,3,5,10]);
    Element el_laps = _in_laps.element;
    _in_laps.setValue(2);

    el_left.append(_levelSelection.setupFieldsForLevels(_createLevelJsonInput(),menu.settings.levels_allowJsonInput.v));

    el_left.append(el_laps);

    el_right.append(_vehicleSelection.setupFieldsForVehicles());
    el_right.append(_trailerSelection.setupFieldsForTrailers());
    el_right.append(el_oponents);

    el.append(createMenuButtonWithIcon("Start","play_arrow",(){
      menu.showMenu(new GameInputMenuStatus("Single race", createGameInput(), (GameOutput result){
        menu.showMenu(new GameOutputMenuStatus("Race results", result));
      }));
    }).element);

    _vehicleSelection.onIndexChanged(-1, 0);
    _trailerSelection.onIndexChanged(-1, 0);
    _levelSelection.onIndexChanged(-1, 0);

    return el;
  }

  Element _createLevelJsonInput(){
    Element el = new DivElement();
    in_levelJson = new TextAreaElement();
    in_levelJson.className = "leveljson";
    AnchorElement el_editorLink = new AnchorElement();
    el_editorLink.href = menu.settings.editor_location.v;
    el_editorLink.className = "button";
    el_editorLink.text = "Open level editor";
    el_editorLink.target = "_blank";
    el.append(in_levelJson);
    el.append(new BRElement());
    el.append(el_editorLink);
    return el;
  }

  GameInput createGameInput(){
    var levelLoader = new GameLevelLoader();
    var level = (in_levelJson != null && in_levelJson.value.isNotEmpty) ? levelLoader.loadLevelJson(jsonDecode(in_levelJson.value)) : menu.levelManager.getLevel(_levelSelection.getSelectedValue());
    return menu.gameBuilder.newGameRandomPlayers(_in_oponents.getValue(),VehicleType.values[_vehicleSelection.index], TrailerType.values[_trailerSelection.index],level, _in_laps.getValue());
  }
}