part of game.menu;

class SoccerGameMenu extends GameMenuScreen{
  GameMenuController menu;
  GameInputSelectionVehicle _vehicleSelection;
  GameInputSelectionTrailer _trailerSelection;
  GameInputSelectionLevel _levelSelection;
  InputFormRadio _in_scorelimit;
  InputFormRadio _in_teams;
  InputFormRadio _in_playersperteam;
  TextAreaElement in_levelJson;

  SoccerGameMenu(this.menu){
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

    _in_teams = new InputFormRadio("Teams", [2,3,4,5,6]);
    var el_teams = _in_teams.createElement();
    _in_teams.setValueIndex(0);
    _in_playersperteam = new InputFormRadio("Players per team", [1,2,3,4,10,20]);
    var el_playersperteam = _in_playersperteam.createElement();
    _in_playersperteam.setValueIndex(1);

    _in_scorelimit = new InputFormRadio("Score limit",[3,5,10]);
    Element el_scoreLimit = _in_scorelimit.createElement();
    _in_scorelimit.setValueIndex(1);

    el_left.append(_levelSelection.setupFieldsForLevels(_createLevelJsonInput(),menu.settings.levels_allowJsonInput.v));
    el_left.append(el_scoreLimit);

    el_right.append(_vehicleSelection.setupFieldsForVehicles());
    el_right.append(_trailerSelection.setupFieldsForTrailers());
    el_right.append(el_teams);
    el_right.append(el_playersperteam);

    el.append(createMenuButtonWithIcon("Start","play_arrow",(Event e){
      menu.showMenu(new GameInputMenuStatus("Soccer", createGameInput(), (GameOutput result){
        menu.showMenu(new GameOutputMenuStatus("Race results", result));
      }));
    }));

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
    return menu.gameBuilder.newSoccerGame(_in_teams.getValue(),_in_playersperteam.getValue(),VehicleType.values[_vehicleSelection.index], TrailerType.values[_trailerSelection.index],level, _in_scorelimit.getValue());
  }
}