import "dart:html";
import "package:gamedefinitions/definitions.dart";
import "package:gameweb/menu.dart";
import "package:gameweb/leveleditor.dart";
import "package:gamemode/gamemode.dart";
import "package:gamelogic/game.dart";
import "package:dependencyinjection/dependencyinjection.dart";
import "package:dashboard/uihelper.dart";

bool isMobile() {
  String userAgent = window.navigator.userAgent;
  List<String> mobiledevices = ["Android", "webOS", "iPhone", "iPad", "iPod", "BlackBerry", "Windows Phone"];

  for (String s in mobiledevices) if (userAgent.contains(s)) return true;
  return false;
}

GameSettings buildSettings() {
  var settings = new GameSettings();
  settings.debug.v = window.location.href.endsWith("ihaveseenthesourcecode");
  settings.client_showUIControls.v = isMobile();
  return settings;
}

void main() {
  var lifetime = DependencyBuilderFactory().createNew((builder) {
    var settings = buildSettings();
    builder.registerModule(UiComposition());
    builder.registerModule(GameComposition());
    builder.registerModule(GameMenuComposition());
    builder.registerModule(GameModeComposition());
    builder.registerModule(LevelEditorComposition(settings));
    builder.registerInstance(settings);
  });

  GameLoader loader = lifetime.resolve();
  loader.preLoad(() {
    GameMenuController menu = lifetime.resolve();
    menu.showMenu(menu.MENU_MAIN);
    document.body.querySelector("#loading").remove();
    document.body.append(menu.element);
    if (window.location.href.endsWith("debugcollisions")) {
      GameBuilder gameBuilder = lifetime.resolve();
      LevelManager levelManager = lifetime.resolve();
      GameSettings settings = lifetime.resolve();
      settings.debug.v = true;
      settings.client_displayType.v = GameDisplayType.Webgl2d;
      var input = gameBuilder.newGameRandomPlayers(0, VehicleType.Car, TrailerType.None, levelManager.getLevel("levels/race/level1"), 1);
      input.startCountdown = 0;
      menu.showMenu(new GameInputMenuStatus("Random race", input, (GameOutput result) {
        menu.showMenu(new GameOutputMenuStatus("Race results", result));
      }));
    }
  });
}
