library webgl_game;

import "dart:html";
import "dart:math" as Math;

import "package:renderlayer/renderlayer.dart";
import "package:preloader/preloader.dart";
import "package:gameutils/gameloop.dart";
import "package:gameutils/math.dart";
import "package:dashboard/uihelper.dart";
import "package:webgl/webgl.dart";

import 'game.dart';
import 'input.dart';
import 'definitions.dart';
import 'gameitem.dart';

part 'src/ui/webgl_game/glmodel_vehicle.dart';
part 'src/ui/webgl_game/glmodel_pickup.dart';
part 'src/ui/webgl_game/glmodel_caravan.dart';
part 'src/ui/webgl_game/glmodel_wall.dart';
part 'src/ui/webgl_game/glmodel_truck.dart';
part 'src/ui/webgl_game/glmodel_trucktrailer.dart';
part 'src/ui/webgl_game/glmodel_tree.dart';
part 'src/ui/webgl_game/glmodel_formula.dart';
part 'src/ui/webgl_game/hud.dart';
part 'src/ui/webgl_game/webgl_game.dart';
part 'src/ui/webgl_game/webgl_game3d.dart';

part 'src/ui/webgl_game/textures/texture_vehicle.dart';

//part "src/ui/generic_form/cloneobject.dart";
//part "src/ui/generic_form/leveleditorform.dart";
