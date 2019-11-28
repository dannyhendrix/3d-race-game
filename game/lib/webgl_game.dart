library webgl_game;

import "dart:html";
import "dart:math";
import "package:gameutils/gameloop.dart";
import "package:gameutils/math.dart";
import "package:dashboard/uihelper.dart";
import "package:webgl/webgl.dart";
import "package:dependencyinjection/dependencyinjection.dart";

import "game.dart";
import "input.dart";
import "definitions.dart";
import "gameitem.dart";
import "resources.dart";

part "src/webgl_game/glmodel_caravan.dart";
part "src/webgl_game/glmodel_formula.dart";
part "src/webgl_game/glmodel_pickup.dart";
part "src/webgl_game/glmodel_tree.dart";
part "src/webgl_game/glmodel_truck.dart";
part "src/webgl_game/glmodel_trucktrailer.dart";
part "src/webgl_game/glmodel_vehicle.dart";
part "src/webgl_game/glmodel_wall.dart";
part "src/webgl_game/hud.dart";
part "src/webgl_game/texturegenerator.dart";
part "src/webgl_game/webgl_game.dart";
part "src/webgl_game/webgl_game3d.dart";
