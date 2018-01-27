import "package:preloader/preloader.dart";
import "package:logging/logging.dart";
import "package:micromachines/game.dart";
import "package:micromachines/webgl_game.dart";
import "dart:html";

GameLevel createGameLevelTemp(){
  GameLevelLoader levelLoader = new GameLevelLoader();
  return levelLoader.loadLevelJson(leveljson);
}
GameSettings createGameSettingsTemp(){
  GameSettings settings = new GameSettings();
  settings.players = [
    new GameSettingsPlayer.asHumanPlayer("Player1",new VehicleTheme.withColor(VehicleThemeColor.Yellow,VehicleThemeColor.Blue),VehicleType.Car,TrailerType.Caravan),
    new GameSettingsPlayer.asAiPlayer("Tom",new VehicleTheme.withColor(VehicleThemeColor.Red,VehicleThemeColor.White),VehicleType.Car,TrailerType.Caravan),
    new GameSettingsPlayer.asAiPlayer("Jake", new VehicleTheme.withColor(VehicleThemeColor.Blue,VehicleThemeColor.Blue),VehicleType.Car,TrailerType.Caravan),
    new GameSettingsPlayer.asAiPlayer("Rose", new VehicleTheme.withColor(VehicleThemeColor.Pink,VehicleThemeColor.White),VehicleType.Car,TrailerType.Caravan),
    new GameSettingsPlayer.asAiPlayer("Marie", new VehicleTheme.withColor(VehicleThemeColor.Black,VehicleThemeColor.Green),VehicleType.Car,TrailerType.Caravan),
    new GameSettingsPlayer.asAiPlayer("Adam", new VehicleTheme.withColor(VehicleThemeColor.Orange,VehicleThemeColor.Orange),VehicleType.Car,TrailerType.Caravan),
  ];
  return settings;
}

void main()
{
  //logger
  Logger.root.level = Level.OFF;

  //String resPath = "http://dannyhendrix.com/teamx/v3/resources/";
  String resPath = "res/";
  ImageController.relativepath = resPath;
  JsonController.relativepath = resPath;

  print("Hi");

  var input = Input.createInput(GameSettings, (Input input){ });

  Element el_wrap = new DivElement();
  Element el_result = new DivElement();
  el_wrap.append(el_result);
  SelectElement el_displayType = createSelect(["2d","3d"]);
  el_wrap.append(createButton("start", (e){
    el_wrap.style.display = "none";
    WebglGame game = el_displayType.selectedIndex == 0 ? new WebglGame2d() : new WebglGame3d();
    Element element;
    game.onGameFinished = (result){
      element.remove();
      el_wrap.style.display = "block";
      el_result.text = result.toString();
      game = null;
    };
    GameSettings settings = input.createValue();
    settings.level = createGameLevelTemp();
    settings.level.path.laps = 1;
    element = game.initAndCreateDom(settings);
    document.body.append(element);
    document.body.append(createButton("Pause",(e)=>game.pause()));
    game.start();
  }));
  el_wrap.append(el_displayType);
  el_wrap.append(input.createElement("GameSettings", createGameSettingsTemp()));
  document.body.append(el_wrap);
}

ButtonElement createButton(String text, Function onClick){
  ButtonElement button = new ButtonElement();
  button.text = text;
  button.onClick.listen(onClick);
  return button;
}
SelectElement createSelect(List<String> options){
  SelectElement element = new SelectElement();
  for(String option in options){
    element.append(new OptionElement(data:option));
  }
  return element;
}