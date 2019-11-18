part of uihelper;

class UiTabView extends UiElement{
  Map<int, UiButtonText>  _tabs = {};
  UiPanel _tabsContainer;
  UiSwitchPanel _contentContainer;
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
  void showTab(int index){
    if(_contentContainer.current != -1)
    {
      _tabs[_contentContainer.current].removeStyle("selected");
    }
    _contentContainer.showTab(index);
    _tabs[_contentContainer.current].addStyle("selected");
  }
  void setTab(String label, int id, UiElement content){
    _contentContainer.setTab(id,content);
    var btn = _lifetime.resolve<UiButtonText>();
    btn.changeText(label);
    btn.addStyle("tab");
    btn.setOnClick((){
      showTab(id);
    });
    _tabs[id] = btn;
    _tabsContainer.append(btn);
  }
}