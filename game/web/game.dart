import "dart:html";
import "dart:math" as Math;
import "dart:convert";
import "package:micromachines/definitions.dart";
import "package:micromachines/menu.dart";

void main(){
  var settings = new GameSettings();
  settings.debug.v = window.location.href.endsWith("iveseenthesourcecode");
  settings.levels_allowJsonInput.v = settings.debug.v;
  var menu = new GameMenuController(settings);
  menu.init(true);
  menu.showMenu(menu.MENU_MAIN);
}