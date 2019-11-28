library game.menu;

import "dart:html";
import "dart:math";
import "dart:async";
import "dart:convert";
import "package:dashboard/menu.dart";
import "package:gameutils/settings.dart";
import "package:gameutils/math.dart";
import "package:webgl/webgl.dart";
import "package:dashboard/uihelper.dart";
import "package:dependencyinjection/dependencyinjection.dart";
import "package:gamedefinitions/definitions.dart";
import "package:gamemode/gamemode.dart";

import "webgl_game.dart";
import "resources.dart";
import "leveleditor.dart";

part "src/menu/gamemenucomposition.dart";
part "src/menu/gamemenucontroller.dart";
part "src/menu/gamemenuscreen.dart";
part "src/menu/menuscreens/controlsmenu.dart";
part "src/menu/menuscreens/creditsmenu.dart";
part "src/menu/menuscreens/gameresultmenu.dart";
part "src/menu/menuscreens/mainmenu.dart";
part "src/menu/menuscreens/playgamemenu.dart";
part "src/menu/menuscreens/profilemenu.dart";
part "src/menu/menuscreens/settingsmenu.dart";
part "src/menu/menuscreens/settingsmenudebug.dart";
part "src/menu/menuscreens/singleracemenu.dart";
part "src/menu/menuscreens/soccergamemenu.dart";
part "src/menu/uielements/colorselection.dart";
part "src/menu/uielements/enterkey.dart";
part "src/menu/uielements/gameinputselectionlevel.dart";
part "src/menu/uielements/gameinputselectionvehicle.dart";
part "src/menu/uielements/levelpreview.dart";
