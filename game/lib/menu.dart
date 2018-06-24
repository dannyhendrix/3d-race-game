library game.menu;

import "dart:html";
import "dart:math" as Math;
import "dart:async";
import "dart:convert";

//import "package:dashboard/dashboard.dart";
import "package:dashboard/menu.dart";
import "package:gameutils/settings.dart";
import "package:gameutils/math.dart";
import "package:webgl/webgl.dart";
import "package:renderlayer/renderlayer.dart";

import "webgl_game.dart";
import "gamemode.dart";
import "definitions.dart";

part "src/ui/menu/gamemenuscreen.dart";
part "src/ui/menu/gamemenucontroller.dart";
part "src/ui/menu/menuscreens/mainmenu.dart";
part "src/ui/menu/menuscreens/creditsmenu.dart";
part "src/ui/menu/menuscreens/gameresultmenu.dart";
part "src/ui/menu/menuscreens/playgamemenu.dart";
part "src/ui/menu/menuscreens/controlsmenu.dart";
part "src/ui/menu/menuscreens/settingsmenu.dart";
part "src/ui/menu/menuscreens/settingsmenudebug.dart";
part "src/ui/menu/menuscreens/singleracemenu.dart";
part "src/ui/menu/menuscreens/profilemenu.dart";
part "src/ui/menu/enterkey.dart";
part "src/ui/menu/levelpreview.dart";
