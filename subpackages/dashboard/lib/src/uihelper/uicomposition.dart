part of uihelper;

class UiComposition implements IDependencyModule {
  @override
  void load(IDependencyBuilder builder) {
    builder.registerType((lifetime) => ElementFactory(), lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => SpanElement(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => ButtonElement(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => DivElement(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => InputElement(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => TextAreaElement(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => CheckboxInputElement(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => SelectElement(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => OptionElement(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => TableElement(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => FieldSetElement(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => LegendElement(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => FormElement(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => ImageElement(), lifeTimeScope: LifeTimeScope.PerUser);

    builder.registerType((lifetime) => UiIcon(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiButtonIcon(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiPanelTitled(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiPanelInline(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiRenderLayer(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiColumn(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiPanel(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiPanelForm(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiTabView(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiSwitchPanel(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiTable(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiButtonToggleIcon(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiButtonToggleIconText(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiButtonText(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiButtonIconText(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiText(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiTextHtml(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiTitle(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiInputLabel(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiInputDouble(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiInputDoubleSlider(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiInputInt(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiInputBool(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiInputBoolIcon(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiInputText(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiInputTextLarge(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiInputOption(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => UiInputOptionRadio(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
  }
}
