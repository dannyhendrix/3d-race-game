part of game.menu;

class ControlsMenu extends GameMenuScreen
{
  GameMenuController menu;
  bool showStoreIncookie = true;
  EnterKey enterKey = new EnterKey(false);
  Map<int, Element> keyToElementMapping = {};

  ControlsMenu(this.menu);

  Element setupFields()
  {
    Element el = super.setupFields();
    el.append(_createKeyboardControls());
    el.append(enterKey.createEnterKeyScreen());
    el.id = "controls";
    return el;
  }

  Element _createKeyboardControls()
  {
    Element el = new DivElement();
    //tabs
    Element el_tabs = new DivElement();
    el_tabs.className = "tabs";
    Element el_tabs_content = new DivElement();
    el_tabs_content.className = "tabs_content";
    Element el_current_tab;
    Element el_current_tab_content;
    var setCurrentTab = (Element newCurrent, Element newCurrentContent, [ControlKeyType keyType])
    {
      if(el_current_tab_content != null)
        el_current_tab_content.style.display = "none";
      el_current_tab_content = newCurrentContent;
      el_current_tab_content.style.display = "block";
      if(el_current_tab != null)
        el_current_tab.classes.remove("current");
      el_current_tab = newCurrent;
      el_current_tab.classes.add("current");
      if(keyType != null)
        menu.settings.client_controlkeytype.v = keyType;
    };
    /*
    var addTab = (String title, Element el_content, ControlKeyType keyType){
      Element el = new DivElement();
      el.text = title;
      el.className = "keys_tab";
      el_tabs.append(el);
      el_tabs_content.append(el_content);
      el_content.style.display = "none";
      el.onClick.listen((MouseEvent e){
        setCurrentTab(el, el_content, keyType);
      });
      if(menu.settings.client_controlkeytype.v == keyType)
        setCurrentTab(el, el_content);
    };
    addTab("Default",_createKeyboardControlsTable(menu.settings.getDefaultKeys(), false), ControlKeyType.Default);
    addTab("Alternative",_createKeyboardControlsTable(menu.settings.getAlternativeKeys(), false), ControlKeyType.Alternative);
    addTab("User defined",_createKeyboardControlsTable(menu.settings.client_keys.v, true), ControlKeyType.UserDefined);
    //el.append(_createKeyboardControlsTable(menu.settings.client_keys.v, true));
    el.append(el_tabs_content);
    el.append(el_tabs_content);
    */
    el.append(_createKeyboardControlsTable(menu.settings.client_keys.v, true));
    return el;
  }
  Element _createKeyboardControlsTable(Map<int, Control> keyMapping, [bool editable = false])
  {
    TableElement ta = new TableElement();
    ta.className = "controls_menu_table";
    TableRowElement tr;
    var tdWrapperAppend = (String className, Node el) {
      TableCellElement td = new TableCellElement();
      td.className = className;
      td.append(el);
      tr.append(td);
    };
    var thWrapperAppend = (String className, Node el) {
      Element td = new Element.th();
      td.className = className;
      td.append(el);
      tr.append(td);
    };
    var newTr = (){
      tr = new TableRowElement();
      ta.append(tr);
    };
    var addControl = (String description, Control key)
    {
      thWrapperAppend("controls_label",new Text(description));
      tdWrapperAppend("controls_keys",createEditKeyElement(key, keyMapping, editable));
    };
    newTr();
    addControl("Accelerate",Control.Accelerate);
    newTr();
    addControl("Brake",Control.Brake);
    newTr();
    addControl("Steer left",Control.SteerLeft);
    newTr();
    addControl("Steer right",Control.SteerRight);
    return ta;
  }
  Element createKeyElement(int key, bool editable)
  {
    if(editable && keyToElementMapping.containsKey(key))
      keyToElementMapping[key].remove();
    Element el = new DivElement();
    el.text = KeycodeToString.translate(key);
    el.className = editable ? "control_key editable" : "control_key";
    if(editable)
    {
      el.onClick.listen((MouseEvent e)
      {
        menu.settings.client_keys.v.remove(key);
        el.remove();
      });
      keyToElementMapping[key] = el;
    }
    return el;
  }
  Element createEditKeyElement(Control controlkey, Map<int,Control> keyMapping, [bool editable = false])
  {
    // <div><span>keys</span>+</div>
    DivElement el = new DivElement();
    SpanElement keysWrapper = new SpanElement();

    //add list of keys as elements
    keyMapping.forEach((int key, Control value){
      if(value != controlkey)
        return;
      keysWrapper.append(createKeyElement(key, editable));
    });

    el.append(keysWrapper);

    if(editable)
    {
      //add new key
      Element el_add = new DivElement();
      el_add.text = "+";
      el_add.className = "control_key add";

      el_add.onClick.listen((MouseEvent e)
      {
        e.stopPropagation();
        enterKey.requestKey((int key)
        {
          keyMapping[key] = controlkey;
          keysWrapper.append(createKeyElement(key, editable));
        });
      });
      el.append(el_add);
    }

    return el;
  }

  @override
  void hide()
  {
    menu.settings.saveToCookie();
    super.hide();
  }
}

