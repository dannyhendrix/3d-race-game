import "dart:html";
import "dart:math" as Math;
import "dart:convert";
import "package:micromachines/definitions.dart";
import "package:micromachines/menu.dart";
import "package:micromachines/gamemode.dart";
import "package:micromachines/game.dart";
import "package:dependencyinjection/dependencyinjection.dart";
import "package:dashboard/uihelper.dart";


bool isMobile()
{
  String userAgent = window.navigator.userAgent;
  List<String> mobiledevices = ["Android", "webOS", "iPhone", "iPad", "iPod", "BlackBerry", "Windows Phone"];

  for(String s in mobiledevices)
    if(userAgent.contains(s))
      return true;
  return false;
}
GameSettings buildSettings(){
  var settings = new GameSettings();
  settings.debug.v = window.location.href.endsWith("ihaveseenthesourcecode");
  settings.levels_allowJsonInput.v = settings.debug.v;
  settings.client_showUIControls.v = isMobile();
  return settings;
}

void main(){
  var lifetime = DependencyBuilderFactory().createNew((builder){
    builder.registerModule(UiComposition());
    builder.registerModule(GameComposition());
    builder.registerModule(GameMenuComposition());
    builder.registerModule(GameModeComposition());
    builder.registerInstance(buildSettings());
  });

  GameLoader loader = lifetime.resolve();
  loader.preLoad((){
    GameMenuController menu = lifetime.resolve();
    menu.showMenu(menu.MENU_MAIN);
    document.body.querySelector("#loading").remove();
    document.body.append(menu.element);
  });
}

