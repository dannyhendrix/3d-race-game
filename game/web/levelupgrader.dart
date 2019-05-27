import "dart:html";
import "dart:convert";
import "package:micromachines/definitions.dart";
import "package:micromachines/gamemode.dart";

void main(){
  var el_txt_in = new TextAreaElement();
  var el_txt_out = new TextAreaElement();
  var upgrader = new GameLevelUpgrader();
  document.body.append(createTitle("Input"));
  document.body.append(el_txt_in);
  document.body.append(createButton("Upgrade",(){
    var json = jsonDecode(el_txt_in.value);
    try{
      var upgraded = upgrader.upgrade(json);
      el_txt_out.value = jsonEncode(upgraded);
    } catch(exception, stackTrace) {
      el_txt_out.value = "${exception}\n${stackTrace}";
    }
  }));
  document.body.append(createTitle("Output"));
  document.body.append(el_txt_out);

  el_txt_in.value = jsonEncode(new LevelManager().leveljson);//'{"version":"0.0","d":0.5}';
}
Element createButton(String text, Function onClick){
  var element = new ButtonElement();
  element.text = text;
  element.onClick.listen((Event e){
    onClick();
  });
  return element;
}
Element createTitle(String label){
  Element el = new HeadingElement.h2();
  el.text = label;
  return el;
}