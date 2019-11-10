part of uihelper;

class UiPanel extends UiContainer {
  UiPanel(ILifetime lifetime) : super(lifetime){
    element = lifetime.resolve<DivElement>();
  }
}