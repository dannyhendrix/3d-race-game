import "dart:html";
import "package:dependencyinjection/dependencyinjection.dart";
import "package:gameweb/leveleditor.dart";
import "package:gamedefinitions/definitions.dart";
import "package:dashboard/uihelper.dart";

/*
void main(){
  var editor = new LevelEditor();
  document.body.append(editor.createElement());
  //editor.loadFromJson(LevelManager.leveljson);
}
*/
GameSettings buildSettings() {
  var settings = new GameSettings();
  settings.debug.v = window.location.href.endsWith("ihaveseenthesourcecode");
  return settings;
}

void main() {
  print("hoi");
  var lifetime = DependencyBuilderFactory().createNew((builder) {
    var settings = buildSettings();
    builder.registerInstance(settings);
    builder.registerModule(UiComposition());
    builder.registerModule(LevelEditorComposition(settings));
  });

  LevelEditor editor = lifetime.resolve();
  document.body.append(editor.element);
}
