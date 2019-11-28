library game.leveleditor;

import "dart:html";
import "dart:convert";
import "dart:math";
import "package:gameutils/math.dart";
import "package:preloader/preloader.dart";
import "package:dashboard/uihelper.dart";
import "package:dependencyinjection/dependencyinjection.dart";
import "package:gamedefinitions/definitions.dart";


part "src/leveleditor/leveleditor.dart";
part "src/leveleditor/leveleditorcomposition.dart";
part "src/leveleditor/levelobject/levelobject.dart";
part "src/leveleditor/levelobject/levelobjectcheckpoint.dart";
part "src/leveleditor/levelobject/levelobjectstaticobject.dart";
part "src/leveleditor/levelobject/levelobjectwall.dart";
part "src/leveleditor/levelobjectwrapper.dart";
part "src/leveleditor/menus/clickaddmenu.dart";
part "src/leveleditor/menus/createmenu.dart";
part "src/leveleditor/menus/editormenu.dart";
part "src/leveleditor/menus/editormenucollection.dart";
part "src/leveleditor/menus/levelobjectcontrolsmenu.dart";
part "src/leveleditor/menus/levelobjectpropertiesmenu.dart";
part "src/leveleditor/menus/savemenu.dart";
part "src/leveleditor/preview.dart";
part "src/leveleditor/startingpositionspreview.dart";
