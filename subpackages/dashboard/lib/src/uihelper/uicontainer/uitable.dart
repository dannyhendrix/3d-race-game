part of uihelper;

class UiTable extends UiElement{
  TableElement _elTable;
  ElementFactory _elementFactory;

  UiTable(ILifetime lifetime) : super(lifetime){
    _elTable = lifetime.resolve();
    _elementFactory = lifetime.resolve();
    element = _elTable;
  }
  void addRow(List<UiElement> items){
    _addItemsToElement('td',items);
  }
  void addHeaderRow(List<UiElement> items){
    _addItemsToElement('th',items);
  }
  void _addItemsToElement(String el, List<UiElement> items){
    var tr = _elementFactory.createTag('tr');
    for(var item in items){
      var td = _elementFactory.createTag(el);
      tr.append(td);
      if(item != null) td.append(item.element);
    }
    _elTable.append(tr);
  }
}