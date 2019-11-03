part of game.menu;

class GameResultMenu extends GameMenuScreen{
  GameMenuController menu;
  TextureGenerator _textureGenerator;
  GameResultMenu(this.menu){
    _textureGenerator = new TextureGenerator(menu.resourceManager);
  }

  Element gameResultContent;

  /*
  1 | Player 1 | carImg
  2 | ..       | carImg
  3 | ..       | carImg
  4 | ..       | -
  . | ..       | -
   */
  Element setupFields()
  {
    Element el = super.setupFields();
    gameResultContent = new DivElement();
    gameResultContent.className = "gameResult";

    el.append(gameResultContent);

    //el.append(createOpenMenuButtonWithIcon(menu,"Continue","play_arrow",menu.MENU_MAIN));
    el.append(createOpenMenuButtonWithIcon(menu,"Main menu","menu",menu.MENU_MAIN).element);

    closebutton = false;
    backbutton = false;

    return el;
  }

  Element _createTopPlayer(GameSettingsPlayer playerSettings){
    PlayerProfile player = _getPlayerProfileFromId(playerSettings.playerId);
    DivElement el = new DivElement();
    el.className = "topplayer";
    ImageElement img = new ImageElement();
    img.src = _createPreviewFromModel(_getModelFromVehicleType(playerSettings.vehicle),colorMappingGl[player.theme.color1],colorMappingGl[player.theme.color2]);
    el.append(_createTableCellWrap(img,"image"));
    String className = "name";
    if(player.id == -1) className = "name highlight";
    el.append(_createTableCell(player.name,className));
    return el;
  }
  Element _createTableRow(int position, String playerName, [bool isHuman = false]){
    DivElement el = new DivElement();
    el.className = "gameResultRow";
    if(isHuman) el.className = "gameResultRow highlight";
    el.append(_createTableCell(position.toString(),"position"));
    el.append(_createTableCell(playerName,"name"));
    el.append(_createTableCell("","image"));
    return el;
  }
  Element _createTableCell(String text, String className){
    DivElement el = new DivElement();
    el.text = text;
    el.className = className;
    return el;
  }
  TableCellElement _createTableCellWrap(Element content, String className){
    TableCellElement el = new TableCellElement();
    el.append(content);
    el.className = className;
    return el;
  }

  void show(GameMenuStatus status)
  {
    if(status is GameOutputMenuStatus)
    {
      GameOutputMenuStatus resultStatus = status;
      _setGameResult(resultStatus.gameOutput);
    }
    super.show(status);
  }
  PlayerProfile _getPlayerProfileFromId(int id){
    if(id == -1) return new PlayerProfile(-1,menu.settings.user_name.v, new VehicleTheme.withColor(menu.settings.user_color1.v,menu.settings.user_color2.v));
    return menu.aiPlayerProfileDatabase.getPlayerById(id);
  }

  void _setGameResult(GameOutput gameresult){
    //gameResultContent.text = gameresult.toString();
    gameResultContent.children.clear();

    // 1-3
    Element el_topWrap = new DivElement();
    el_topWrap.className = "topplayers";
    int numberOfPlayers = gameresult.playerResults.length;
    Element el_player;
    if(numberOfPlayers > 0)
    {
      el_player = _createTopPlayer(gameresult.playerResults[0].player);
      el_player.classes.add("playerP1");
      el_topWrap.append(el_player);
      el_topWrap.append(_createTableCell("1", "podium podium1"));
    }
    if(numberOfPlayers > 1)
    {
      el_player = _createTopPlayer(gameresult.playerResults[1].player);
      el_player.classes.add("playerP2");
      el_topWrap.append(el_player);
      el_topWrap.append(_createTableCell("2","podium podium2"));
    }
    if(numberOfPlayers > 2)
    {
      el_player = _createTopPlayer(gameresult.playerResults[2].player);
      el_player.classes.add("playerP3");
      el_topWrap.append(el_player);
      el_topWrap.append(_createTableCell("3", "podium podium3"));
    }
    gameResultContent.append(el_topWrap);

    // 4-..
    DivElement el_remaining = new DivElement();
    for(int i = 3; i < gameresult.playerResults.length; i++){
      GamePlayerResult player = gameresult.playerResults[i];
      bool isHuman = player.player.playerId == -1;
      el_remaining.append(_createTableRow(player.position, player.player.name, isHuman));
    }
    gameResultContent.append(el_remaining);
  }

  dynamic _getModelFromVehicleType(VehicleType vehicleType){
    switch(vehicleType){
      case VehicleType.Car: return new GlModel_Vehicle();
      case VehicleType.Formula: return new GlModel_Formula();
      case VehicleType.Truck: return new GlModel_Truck();
      case VehicleType.Pickup: return new GlModel_Pickup();
    }
  }

  String _createPreviewFromModel(dynamic model, GlColor c1, GlColor c2){
    GlPreview preview = new GlPreview(150.0,100.0,(GlModelCollection modelCollection){
      model.loadModel(modelCollection);
      var instance = model
          .getModelInstance(modelCollection, c1, c2, new GlColor(0.7, 0.7, 0.9));

      return [instance];

    },menu.settings.client_renderType.v == GameRenderType.Textures);
    preview.ox = 0.0;
    preview.oy = 26.0;
    preview.oz = 240.0;
    preview.rx = 1.0;
    preview.ry = 2.6;
    preview.rz = 5.8;
    preview.lx = 0.3;
    preview.ly = 0.7;
    preview.lz = 0.1;
    preview.create();
    preview.layer.setTexture("car", _textureGenerator.CreateTexture(c1, c2,"textures/texture_vehicle1").canvas);
    preview.draw();
    return preview.layer.canvas.toDataUrl("image/png");
  }
}