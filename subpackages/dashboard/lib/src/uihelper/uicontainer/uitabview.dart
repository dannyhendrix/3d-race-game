part of uihelper;

class UiTabView extends UiElement{
  Map<int, UiElement>  _contents = {};
  Map<int, UiButtonText>  _tabs = {};
  int _current = -1;
  UiPanel _tabsContainer;
  UiPanel _contentContainer;
  ILifetime _lifetime;
  UiTabView(ILifetime lifetime) : super(lifetime){
    _lifetime = lifetime;
    _tabsContainer = lifetime.resolve();
    _contentContainer = lifetime.resolve();
    element = lifetime.resolve<DivElement>();
  }
  @override
  void build(){
    element.append(_tabsContainer.element);
    element.append(_contentContainer.element);
    element.classes.add("tabs");
    _tabsContainer.addStyle("tabs_navigation");
    _contentContainer.addStyle("tabs_content");
  }
  void setShowLabels(bool showLabels){
    _tabsContainer.display(showLabels);
  }
  void showTab(int index){
    if(_current != -1)
    {
      _contents[_current].hide();
      _tabs[_current].removeStyle("selected");
    }
    _current = index;
    _contents[_current].show();
    _tabs[_current].addStyle("selected");
  }
  void setTab(String label, int id, UiElement content){
    content.hide();
    _contentContainer.append(content);
    var btn = _lifetime.resolve<UiButtonText>();
    btn.changeText(label);
    btn.addStyle("tab");
    btn.setOnClick((){
      showTab(id);
    });
    _tabsContainer.append(btn);
    _contents[id] = content;
    _tabs[id] = btn;
  }
}