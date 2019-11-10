import "dart:html";
import "package:dashboard/uihelper.dart";
import "package:dependencyinjection/dependencyinjection.dart";

void main(){
  var lifetime = DependencyBuilderFactory().createNew((builder){
    builder.registerModule(UiComposition());
  });

  document.body.append((lifetime.resolve<UiTitle>()..changeText("Dependency Injection")).element);
  document.body.append(createForm(lifetime).element);
  document.body.append(createTabs(lifetime).element);
  document.body.append(createTable(lifetime).element);
}

UiPanelTitled createForm(ILifetime lifetime){
  return lifetime.resolve<UiPanelTitled>()..changeTitle("Inputform")
    ..append(lifetime.resolve<UiPanelForm>()
      ..append(lifetime.resolve<UiInputText>()..changeLabel("Enter text")..setValue("Voertaal"))
      ..append(lifetime.resolve<UiInputTextLarge>()..changeLabel("Enter large text")..setValue("Voertaal2"))
      ..append(lifetime.resolve<UiInputInt>()..changeLabel("Enter double")..setValue(6))
      ..append(lifetime.resolve<UiInputDouble>()..changeLabel("Enter double")..setValue(0.5))
      ..append(lifetime.resolve<UiInputDoubleSlider>()..changeLabel("Enter double")..setValue(0.8))
      ..append(lifetime.resolve<UiInputOption>()..changeLabel("Select something")..setOptions(["Chinees","Friet","Pannekoek"])..setValue("Friet"))
      ..append(lifetime.resolve<UiInputOptionRadio>()..changeLabel("Select integer")..setOptions([1,2,3,4,5])..setValue("op"))
      ..append(lifetime.resolve<UiInputBool>()..changeLabel("Selected")..setValue(true))
      ..append(lifetime.resolve<UiInputBoolIcon>()..changeLabel("Not Selected")..setValue(false))
      ..append(lifetime.resolve<UiIcon>()..changeIcon("settings"))
      ..append(lifetime.resolve<UiButtonText>()..changeText("Settings"))
      ..append(lifetime.resolve<UiButtonIcon>()..changeIcon("settings"))
      ..append(lifetime.resolve<UiButtonIconText>()..changeIcon("settings"))
    );
}
UiTabView createTabs(ILifetime lifetime){
  UiTabView tabview = lifetime.resolve();
  tabview.setTab("Tab 1", 0, lifetime.resolve<UiText>()..changeText("Hoi"));
  tabview.setTab("Tab 2", 1, lifetime.resolve<UiText>()..changeText("Something else"));
  tabview.showTab(0);
  return tabview;
}
UiTable createTable(ILifetime lifetime){
  UiTable table = lifetime.resolve();
  table.addHeaderRow([
    lifetime.resolve<UiText>()..changeText("Header 1"),
    lifetime.resolve<UiText>()..changeText("Header 2"),
    lifetime.resolve<UiText>()..changeText("Header 3"),
  ]);
  table.addRow([
    lifetime.resolve<UiText>()..changeText("Item 1"),
    lifetime.resolve<UiText>()..changeText("Item 2"),
    lifetime.resolve<UiText>()..changeText("Item 3"),
  ]);
  table.addRow([
    lifetime.resolve<UiText>()..changeText("Item 1"),
    lifetime.resolve<UiText>()..changeText("Item 2"),
    lifetime.resolve<UiText>()..changeText("Item 3"),
  ]);
  return table;
}