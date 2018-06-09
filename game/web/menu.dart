import "dart:html";
import "dart:math" as Math;
import "dart:convert";
import "package:micromachines/menu.dart";
import "package:micromachines/ui.dart";

void main(){
  var settings = new GeneralSettings();
  settings.debug.v = true;
  var menu = new GameMenuController(settings);
  menu.init(true);
  menu.showMenu(menu.MENU_MAIN);
}