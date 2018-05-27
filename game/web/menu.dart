import "dart:html";
import "dart:math" as Math;
import "dart:convert";
import "package:micromachines/menu.dart";

void main(){
  var menu = new GameMenuController();
  menu.init(true);
  menu.showMenu(menu.MENU_MAIN);
}