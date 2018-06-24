part of game.leveleditor;

class LevelObjectWrapper<T extends LevelObject>{
  Element el;
  List<T> levelObjects = [];
  void clearAll(){
    el.nodes.clear();
    levelObjects = [];
  }
  void addLevelObject(T o){
    levelObjects.add(o);
    el.append(o.createElement());
  }
  void removeLevelObject(T o){
    levelObjects.remove(o);
    o.element.remove();
  }
  Element createElement(){
    el = new DivElement();
    el.className = "levelObjectWrapper";
    return el;
  }
}
class LevelObjectMenu{
  Element element;
  Element el_menu;
  Element el_buttonDelete;
  LevelObject _currentLevelObject;
  OnDelete onLevelObjectDelete;

  Element createElement(){
    Element el = new DivElement();
    el_menu = new DivElement();
    el_buttonDelete = createButtonText("Delete",(Event e){
      if(_currentLevelObject == null) return;
      if(onLevelObjectDelete != null){
        onLevelObjectDelete(_currentLevelObject);
      }
      _currentLevelObject = null;
      el_menu.nodes.clear();
      showDelete(false);
    });
    element = el;
    el.append(el_menu);
    el.append(el_buttonDelete);

    showDelete(false);
    return el;
  }
  void onSelect(LevelObject o){
    el_menu.nodes.clear();
    el_menu.append(o.el_properties);
    _currentLevelObject = o;
    showDelete(true);
  }

  void showDelete(bool show){
    el_buttonDelete.style.display = show ? "" : "none";
  }

  Element createButtonText(String text, Function onClick) {
    DivElement btn = new DivElement();
    btn.className = "button";
    btn.onClick.listen((MouseEvent e){ e.preventDefault(); onClick(e); });
    btn.onTouchStart.listen((TouchEvent e){ e.preventDefault(); onClick(e); });
    btn.text = text;
    return btn;
  }
}