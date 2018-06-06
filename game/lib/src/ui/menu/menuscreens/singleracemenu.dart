part of game.menu;

class SingleRaceMenu extends GameMenuScreen{
  GameBuilder _gameBuilder;
  GameInputSelection _vehicleSelection;
  GameInputSelection _trailerSelection;
  GameInputSelection _levelSelection;
  InputElement _in_laps;
  InputElement _in_oponents;

  SingleRaceMenu(GameMenuController m) : super(m, "Single Race"){
    _gameBuilder = new GameBuilder(menu.settings);
  }

  Element setupFields()
  {
    closebutton = false;

    Element el = super.setupFields();

    _vehicleSelection = new GameInputSelectionVehicle();
    _trailerSelection = new GameInputSelectionTrailer();
    _levelSelection = new GameInputSelection(1);

    el.append(_vehicleSelection.element);
    el.append(_trailerSelection.element);
    el.append(_levelSelection.element);

    _in_laps = new InputElement();
    _in_laps.type = "number";
    _in_laps.value = "3";
    el.appendText("Laps:");
    el.append(_in_laps);
    _in_oponents = new InputElement();
    _in_oponents.type = "number";
    _in_oponents.value = "3";
    el.appendText("Oponents:");
    el.append(_in_oponents);

    el.append(createMenuButtonWithIcon("Start","play_arrow",(Event e){
      menu.showPlayGameMenu(createGameInput());
    }));

    return el;
  }

  GameInput createGameInput(){
    return _gameBuilder.newGameRandomPlayers(int.parse(_in_oponents.value),VehicleType.values[_vehicleSelection.index], TrailerType.values[_trailerSelection.index],"", int.parse(_in_laps.value));
  }
}

class GameInputSelectionVehicle extends GameInputSelection{
  GameInputSelectionVehicle() : super(VehicleType.values.length);

  void onIndexChanged(int oldIndex, int newIndex){
    el_content.text = VehicleType.values[newIndex].toString();
  }
}
class GameInputSelectionTrailer extends GameInputSelection{
  GameInputSelectionTrailer() : super(TrailerType.values.length);

  void onIndexChanged(int oldIndex, int newIndex){
    el_content.text = TrailerType.values[newIndex].toString();
  }
}
class GameInputSelection{
  Element _btn_next;
  Element _btn_prev;
  Element el_content;
  int index = 0;
  int _optionsLength = 0;
  Element element;

  GameInputSelection(this._optionsLength){
    element = new DivElement();
    element.className = "GameInputSelection";
    _btn_prev = createButtonWithIcon("navigate_before", (Event e){
      int oldIndex = index--;
      if(index < 0)
        index = _optionsLength-1;
      onIndexChanged(oldIndex, index);
    });
    _btn_next = createButtonWithIcon("navigate_next", (Event e){
      int oldIndex = index++;
      if(index >= _optionsLength)
        index = 0;
      onIndexChanged(oldIndex, index);
    });
    el_content = new DivElement();
    el_content.className = "content";

    element.append(_btn_prev);
    element.append(el_content);
    element.append(_btn_next);
    onIndexChanged(-1,index);
  }
  void onIndexChanged(int oldIndex, int newIndex){
    el_content.text = newIndex.toString();
  }
  Element createButtonWithIcon(String icon, Function onClick)
  {
    DivElement btn = new DivElement();
    btn.onClick.listen((MouseEvent e){ e.preventDefault(); onClick(e); });
    btn.onTouchStart.listen((TouchEvent e){ e.preventDefault(); onClick(e); });
    btn.append(createIcon(icon));
    return btn;
  }
  Element createIcon(String icon)
  {
    Element iel = new Element.tag("i");
    iel.className = "material-icons";
    iel.text = icon.toLowerCase();
    return iel;
  }
}