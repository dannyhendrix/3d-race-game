import "package:preloader/preloader.dart";
import "package:logging/logging.dart";
import "package:micromachines/game.dart";
import "package:micromachines/webgl.dart";
import "package:micromachines/webgl_game.dart";
import "package:renderlayer/renderlayer.dart";
import "package:gameutils/gameloop.dart";
import "package:gameutils/math.dart";
import "dart:html";
import "dart:math" as Math;
import "dart:web_gl";





void main()
{
  //logger
  Logger.root.level = Level.OFF;

  //String resPath = "http://dannyhendrix.com/teamx/v3/resources/";
  String resPath = "res/";
  ImageController.relativepath = resPath;
  JsonController.relativepath = resPath;

  print("Hi");

  var game = new WebglGame3d();
  var input = Input.createInput(GameSettings, (Input input){ });


  Element el_form = input.createElement("GameSettings", game.game.createGameSettingsTemp());
  document.body.append(el_form);

  el_form.append(createButton("start", (e){
    el_form.remove();
    GameSettings settings = input.createValue();
    settings.level = game.game.createGameLevelTemp();
    var element = game.initAndCreateDom(settings);
    document.body.append(element);
    document.body.append(createButton("Pause",(e)=>game.pause()));

    game.start();
  }));
}

ButtonElement createButton(String text, Function onClick){
  ButtonElement button = new ButtonElement();
  button.text = text;
  button.onClick.listen(onClick);
  return button;
}