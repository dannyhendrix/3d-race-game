import "dart:html";
import "dart:math" as Math;
import "dart:convert";
import "package:micromachines/definitions.dart";
import "package:micromachines/menu.dart";


bool isMobile()
{
  String userAgent = window.navigator.userAgent;
  List<String> mobiledevices = ["Android", "webOS", "iPhone", "iPad", "iPod", "BlackBerry", "Windows Phone"];

  for(String s in mobiledevices)
    if(userAgent.contains(s))
      return true;
  return false;
}

void main(){
  var settings = new GameSettings();
  settings.debug.v = window.location.href.endsWith("ihaveseenthesourcecode");
  settings.levels_allowJsonInput.v = settings.debug.v;
  settings.client_showUIControls.v = isMobile();
  var menu = new GameMenuController(settings);
  menu.preLoad((){
    menu.init(false);
    menu.showMenu(menu.MENU_MAIN);
    document.body.querySelector("#loading").remove();
    document.body.append(menu.element.element);
  });
}