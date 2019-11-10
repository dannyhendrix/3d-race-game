part of uihelper;

class UiPanelInline extends UiContainer {
  UiPanelInline(ILifetime lifetime) : super(lifetime){
    element = lifetime.resolve<SpanElement>();
  }
}