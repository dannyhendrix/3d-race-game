part of uihelper;

class UiTabView extends UiElement{
  Map<int, UiElement>  _menus;
  int _current = -1;
  UiTabView(this._menus);
  Element createElement()
  {
    var el = new DivElement();
    for(int k = 0; k < _menus.length; k++)
    {
      el.append(_menus[k].element);
      _menus[k].hide();
    }
    return el;
  }
  void showTab(int index){
    if(_current != -1)
    {
      _menus[_current].hide();
    }
    _current = index;
    _menus[_current].show();
  }
}