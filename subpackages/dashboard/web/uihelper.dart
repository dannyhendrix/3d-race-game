import "dart:html";
import "package:dashboard/uihelper.dart";

void main(){
  var panelForm = UiPanelTitled("Inputform");
  var form = UiPanelForm();
  panelForm.append(form);
  form.append(UiInputText("Enter text")..setValue("Voertaal"));
  form.append(UiInputText("Enter more text")..setValue("Voertaal2"));
  form.append(UiInputOption("Select something",["Chinees","Friet","Pannekoek"])..setValue("Friet"));
  form.append(UiInputOptionRadio("Select integer",["as","op","op",4,5])..setValue("op"));
  form.append(UiInputBool("Selected")..setValue(true));
  form.append(UiInputBoolIcon("Not selected")..setValue(true));

  var panel = UiPanelTitled("Input");
  form.append(UiInputText("Enter text")..setValue("Voertaal"));
  form.append(UiInputOption("Select something",["Chinees","Friet","Pannekoek"])..setValue("Friet"));
  form.append(UiInputOptionRadio("Select integer",[1,2,3,4,5])..setValue(2));
  panel.append(UiIcon("settings"));
  panel.append(UiButtonText("Settings",(){}));
  panel.append(UiButtonIcon("settings",(){}));
  panel.append(UiButtonIconText("Settings", "settings",(){}));

  //document.body.append(UIHelper.createTitle("Main menu"));
  document.body.append(panelForm.element);
  document.body.append(panel.element);
}