part of game.leveleditor;

class LevelObjectWrapper<T extends LevelObject> extends UiElement{
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
  Element el_controls;
  UIButton el_buttonDelete;
  LevelObject _currentLevelObject;
  OnDelete onLevelObjectDelete;

  UiElement createElementControls(){
    Element el = new DivElement();
    el_controls = new DivElement();
    el_buttonDelete = new UIIconButton("delete",(){
      if(_currentLevelObject == null) return;
      if(onLevelObjectDelete != null){
        onLevelObjectDelete(_currentLevelObject);
      }
      _currentLevelObject = null;
      el_controls.nodes.clear();
      el_menu.nodes.clear();
      showDelete(false);
    });
    //element = el;
    el.append(el_controls);
    el.append(el_buttonDelete.element);

    showDelete(false);

    var uimenu = new UIMenu("Controls");
    el.className = "controls";
    uimenu.appendElement(el);
    return uimenu;
  }

  UiElement createElement(){
    Element el = new DivElement();
    el_menu = new DivElement();
    /*
    el_buttonDelete = new UIIconButton("delete",(){
      if(_currentLevelObject == null) return;
      if(onLevelObjectDelete != null){
        onLevelObjectDelete(_currentLevelObject);
      }
      _currentLevelObject = null;
      el_menu.nodes.clear();
      showDelete(false);
    }).createElement();*/
    element = el;
    el.append(el_menu);
    //el.append(el_buttonDelete);

    //showDelete(false);
    //return el;

    var uimenu = new UIMenu("Properties");
    uimenu.addStyle("properties");
    uimenu.appendElement(el);
    return uimenu;
  }
  void onSelect(LevelObject o){
    el_menu.nodes.clear();
    el_controls.nodes.clear();
    el_menu.append(o.el_properties);
    el_controls.append(o.el_controls);
    _currentLevelObject = o;
    showDelete(true);
  }

  void showDelete(bool show){
    if(show) el_buttonDelete.show();
    else el_buttonDelete.hide();
  }
}