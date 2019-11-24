library game.leveleditor;

import "dart:html";
import "dart:convert";
import "dart:math" as Math;

import "package:gameutils/math.dart";
import "package:preloader/preloader.dart";
import "package:dashboard/uihelper.dart";
import 'package:dependencyinjection/dependencyinjection.dart';

import "definitions.dart";

part "src/ui/leveleditor/leveleditor.dart";
part "src/ui/leveleditor/leveleditorcomposition.dart";
part "src/ui/leveleditor/preview.dart";
part "src/ui/leveleditor/startingpositionspreview.dart";
part "src/ui/leveleditor/levelobjectwrapper.dart";
part "src/ui/leveleditor/levelobject/levelobject.dart";
part "src/ui/leveleditor/levelobject/levelobjectcheckpoint.dart";
part "src/ui/leveleditor/levelobject/levelobjectstaticobject.dart";
part "src/ui/leveleditor/levelobject/levelobjectwall.dart";
part "src/ui/leveleditor/menus/clickaddmenu.dart";
part "src/ui/leveleditor/menus/createmenu.dart";
part "src/ui/leveleditor/menus/editormenu.dart";
part "src/ui/leveleditor/menus/savemenu.dart";
part "src/ui/leveleditor/menus/editormenucollection.dart";
part "src/ui/leveleditor/menus/levelobjectcontrolsmenu.dart";
part "src/ui/leveleditor/menus/levelobjectpropertiesmenu.dart";
