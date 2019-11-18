import "dart:html";
import "package:dashboard/uihelper.dart";
import "package:dependencyinjection/dependencyinjection.dart";

void main(){
  var lifetime = DependencyBuilderFactory().createNew((builder){
    builder.registerModule(UiComposition());
    builder.registerType((lifetime) => new GameInputSelectionInt(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
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
      ..append(lifetime.resolve<GameInputSelectionInt>())
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

class GameInputSelectionInt extends GameInputSelection<int>{
  GameInputSelectionInt(ILifetime lifetime) : super(lifetime);

  getSelectedValue() => index;
}

abstract class GameInputSelection<T> extends UiPanel{
  UiButtonIcon _btn_next;
  UiButtonIcon _btn_prev;
  UiPanel el_content;
  int index = 0;
  int optionsLength = 5;

  GameInputSelection(ILifetime lifetime) : super(lifetime){
    _btn_next = lifetime.resolve();
    _btn_prev = lifetime.resolve();
    el_content = lifetime.resolve();
  }

  void setOptions(int options){
    optionsLength = options;
  }

  @override
  void build(){
    super.build();

    addStyle("GameInputSelection");
/*
    if(label.isNotEmpty){
      var el_label = new UiText(label);
      el_label.addStyle("label");
      element.append(el_label);
    }
*/
    _btn_prev..changeIcon("navigate_before")..addStyle("navigate")..setOnClick((){
      int oldIndex = index--;
      if(index < 0)
        index = optionsLength-1;
      onIndexChanged(oldIndex, index);
    });
    _btn_next..changeIcon("navigate_next")..addStyle("navigate")..setOnClick((){
      int oldIndex = index++;
      if(index >= optionsLength)
        index = 0;
      onIndexChanged(oldIndex, index);
    });
    el_content.addStyle("content");
    el_content.element.text = 0.toString();
    append(_btn_prev);
    append(el_content);
    append(_btn_next);
  }
  void onIndexChanged(int oldIndex, int newIndex){
    el_content.element.text = newIndex.toString();
  }

  T getSelectedValue();
}