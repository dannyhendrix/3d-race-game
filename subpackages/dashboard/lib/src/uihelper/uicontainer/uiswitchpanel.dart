part of uihelper;

class UiSwitchPanel extends UiElement{
  Map<int, UiElement>  _contents = {};
  int current = -1;
  UiSwitchPanel(ILifetime lifetime) : super(lifetime){
    element = lifetime.resolve<DivElement>();
  }
  void showTab(int index){
    if(current != -1)
    {
      _contents[current].hide();
    }
    current = index;
    _contents[current].show();
  }
  void setTab(int id, UiElement content){
    content.hide();
    element.append(content.element);
    _contents[id] = content;
  }
}