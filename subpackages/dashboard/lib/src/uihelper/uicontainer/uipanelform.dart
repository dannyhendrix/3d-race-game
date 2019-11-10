part of uihelper;

class UiPanelForm extends UiContainer {
  UiPanelForm(ILifetime lifetime) : super(lifetime){
    element = lifetime.resolve<FormElement>();
  }
}