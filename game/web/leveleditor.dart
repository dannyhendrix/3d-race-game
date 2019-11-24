import "dart:html";
import "package:dependencyinjection/dependencyinjection.dart";
import "package:micromachines/leveleditor.dart";
import "package:dashboard/uihelper.dart";

/*
void main(){
  var editor = new LevelEditor();
  document.body.append(editor.createElement());
  //editor.loadFromJson(LevelManager.leveljson);
}
*/
void main() {
  print("hoi");
  var lifetime = DependencyBuilderFactory().createNew((builder) {
    builder.registerModule(UiComposition());
    builder.registerModule(LevelEditorComposition());
  });

  LevelEditor editor = lifetime.resolve();
  document.body.append(editor.element);
}
