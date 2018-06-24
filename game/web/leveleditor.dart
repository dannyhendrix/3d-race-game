import "dart:html";
import "package:micromachines/leveleditor.dart";

void main(){
  var editor = new LevelEditor();
  document.body.append(editor.createElement());
}