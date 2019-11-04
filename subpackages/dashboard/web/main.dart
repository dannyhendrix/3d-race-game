import "dart:html";
import "package:dashboard/uihelper.dart";
import "package:dependencyinjection/dependencyinjection.dart";

void main(){
  var lifetime = DependencyBuilderFactory().createNew((builder){
    builder.registerModule(UiHelperComposition());
  });
  var panel = lifetime.resolve<UiPanelTitled>()
    ..changeTitle("Input")
    ..append(lifetime.resolve<UiButtonIcon>()..changeIcon("web"))
    ..append(lifetime.resolve<UiButtonText>()..changeText("web"))
    ..append(lifetime.resolve<UiButtonIconText>()..changeText("web")..changeIcon("web"))
    ..append(lifetime.resolve<UiInputDouble>()..changeLabel("Enter something")..setValue(5.8))
    ..append(lifetime.resolve<UiButtonIcon>(name:UiHelperComposition.BtnHighlight)..changeIcon("web"));
  document.body.append(panel.element);
}

class UiHelperComposition implements IDependencyModule{
  static const String BtnHighlight = "highlight";
  @override
  void load(IDependencyBuilder builder) {
    builder.registerType(() => UiIcon.fromInjection(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType(() => UiButtonIcon.fromInjection(), name:BtnHighlight, lifeTimeScope: LifeTimeScope.PerUser, initializeInstance: (btn){btn.addStyle("highlight");});
    builder.registerType(() => UiButtonIcon.fromInjection(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType(() => UiPanelTitled.fromInjection(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType(() => UiButtonToggleIcon.fromInjection(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType(() => UiButtonText.fromInjection(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType(() => UiButtonIconText.fromInjection(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType(() => SpanElement(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType(() => ButtonElement(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType(() => UiText.fromInjection(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType(() => UiInputLabel.fromInjection(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType(() => UiInputDouble.fromInjection(), lifeTimeScope: LifeTimeScope.PerUser);
  }
}