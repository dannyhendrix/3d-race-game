part of uihelper;

class UiPanelForm extends UiContainer {
  Element createElement() {
    return new FormElement();
  }
}