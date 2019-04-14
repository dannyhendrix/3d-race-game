import "dart:html";
import "package:dashboard/uihelper.dart";

void main(){

  var panelForm = UIHelper.createPanel("Inputform");
  var form = UIHelper.createForm();
  panelForm.append(form);
  form.append(UIHelper.createTextInput("Enter text","Voertaal"));
  form.append(UIHelper.createTextInput("Enter more text","Voertaal2"));
  form.append(UIHelper.createOptionSelect("Select something",["Chinees","Friet","Pannekoek"], 1));
  form.append(UIHelper.createRadioSelect("Select integer",["as","op","op",4,5], 2));
  form.append(UIHelper.createBoolInput("Selected",true));
  form.append(UIHelper.createBoolInput("Not selected",false));

  var panel = UIHelper.createPanel("Input");
  panel.append(UIHelper.createTextInput("Enter text","Voertaal"));
  panel.append(UIHelper.createOptionSelect("Select something",["Chinees","Friet","Pannekoek"], 1));
  panel.append(UIHelper.createRadioSelect("Select integer",[1,2,3,4,5], 2));
  panel.append(UIHelper.createIcon("settings"));
  panel.append(UIHelper.createButtonWithText("Settings"));
  panel.append(UIHelper.createButtonWithIcon("Settings"));
  panel.append(UIHelper.createButtonWithTextAndIcon("Settings", "Settings"));

  document.body.append(UIHelper.createTitle("Main menu"));
  document.body.append(panelForm);
  document.body.append(panel);
}