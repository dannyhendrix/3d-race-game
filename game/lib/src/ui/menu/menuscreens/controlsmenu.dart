part of game.menu;

class ControlsMenu extends GameMenuScreen
{
  bool showStoreIncookie = true;
  Map<ControlType, Element> panels = {};
  Map<ControlType, Element> tabs = {};
  ControlType _currentControlType;
  EnterKey enterKey = new EnterKey();
  Map<int, Element> keyToElementMapping = {};

  ControlsMenu(GameMenuController m) : super(m, "Controls");

  Element setupFields()
  {
    Element el = super.setupFields();

    Element tabs = new DivElement();
    tabs.id = "menu_controls_tabs";
    //tabs.append(_createTab(ControlType.Keyboard,"keyboard"));
    tabs.append(_createTab(ControlType.KeyboardMouse,"keyboard"));
    tabs.append(_createTab(ControlType.Touch,"touch_app"));
    //tabs.append(_createTab(ControlType.TouchOrientation,"screen_rotation"));
    //tabs.append(_createTab(ControlType.All,"keyboard"));

    Element panels = new DivElement();
    panels.id = "menu_controls_panels";
    //panels.append(_createKeyboardControls());
    panels.append(_createKeyboardControls());
    panels.append(_createTouchControls());
    //panels.append(_createTouchOrientationControls());

    el.append(tabs);
    el.append(panels);
    el.append(enterKey.createEnterKeyScreen());
    return el;
  }

  Element _createTab(ControlType id, String icon)
  {
    Element el = new DivElement();
    el.className = "menu_controls_tab";
    for(String i in icon.split(" "))
    {
      Element iel = new SpanElement();
      iel.className = "material-icons";
      iel.text = i;
      el.append(iel);
    }
    el.onClick.listen((Event e){
      setToControlType(id);
    });
    tabs[id] = el;
    return el;
  }

  void setToControlType(ControlType controlType)
  {
    if(_currentControlType != null)
    {
      panels[_currentControlType].style.display = "none";
      tabs[_currentControlType].classes.remove("selected");
    }
    _currentControlType = controlType;
    panels[_currentControlType].style.display = "block";
    tabs[_currentControlType].classes.add("selected");
  }

  Element _createTabContext(ControlType id)
  {
    Element el = new DivElement();
    el.className = "menu_controls_tab_content";
    panels[id] = el;
    el.style.display = "none";
    return el;
  }

  Element _createTouchOrientationControls()
  {
    Element el = _createTabContext(ControlType.TouchOrientation);

    Element txt_touch = new SpanElement();
    txt_touch.text = "Use on-screen buttons to jump and shoot.";
    el.append(txt_touch);
    return el;
  }
  Element _createTouchControls()
  {
    Element el = _createTabContext(ControlType.Touch);
    el.text = "Use on-screen buttons to play.";
    return el;
  }
  Element _createKeyboardControls()
  {
    Element el = _createTabContext(ControlType.KeyboardMouse);
    //tabs
    Element el_tabs = new DivElement();
    Element el_tabs_content = new DivElement();
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
    addTab("Default",_createKeyboardControlsTable(InputController.defaultKeys, false), ControlKeyType.Default);
    addTab("Alternative",_createKeyboardControlsTable(InputController.alternativeKeys, false), ControlKeyType.Alternative);
    addTab("User defined",_createKeyboardControlsTable(menu.settings.client_keys.v, true), ControlKeyType.UserDefined);
    //el.append(_createKeyboardControlsTable(menu.settings.client_keys.v, true));
    el.append(el_tabs);
    el.append(el_tabs_content);
    return el;
  }
  Element _createKeyboardMouseControls()
  {
    Element el = _createTabContext(ControlType.KeyboardMouse);
    el.append(_createKeyboardControlsTable(menu.settings.client_keys.v, true));
    return el;
  }
  Element _createKeyboardControlsTable(Map<int, int> keyMapping, [bool editable = false])
  {
    TableElement ta = new TableElement();
    ta.className = "controls_menu_table";
    TableRowElement tr;
    var tdWrapperAppend = (String className, Element el) {
      TableCellElement td = new TableCellElement();
      td.className = className;
      td.append(el);
      tr.append(td);
    };
    var newTr = (){
      tr = new TableRowElement();
      ta.append(tr);
    };
    var addControl = (String description, String image, int key)
    {
      tdWrapperAppend("controls_image",_createControlImage(description, image));
      tdWrapperAppend("controls_keys",createEditKeyElement(key, keyMapping, editable));
    };
    newTr();
    addControl("walk_left", "Walk left",GameControls.CONTROL_LEFT);
    addControl("shoot_main", "Shoot main gun",GameControls.CONTROL_SHOOT_WEAPON_MAIN);
    newTr();
    addControl("walk_right", "Walk right",GameControls.CONTROL_RIGHT);
    addControl("shoot_sub", "Shoot secondary gun",GameControls.CONTROL_SHOOT_WEAPON_SUB);
    newTr();
    addControl("aim_up", "Aim up",GameControls.CONTROL_AIM_UP);
    addControl("throw", "Throw bomb",GameControls.CONTROL_THROW);
    newTr();
    addControl("aim_down", "Aim down",GameControls.CONTROL_AIM_DOWN);
    addControl("jump", "Jump",GameControls.CONTROL_JUMP);
    return ta;
  }
  Element _createControlImage([String className, String title])
  {
    Element img = new DivElement();
    if(className != null)
      img.className = "control_image $className";
    else
      img.className = "control_image";
    if(title != null)
      img.title = title;
    return img;
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
  Element createEditKeyElement(int controlkey, Map<int,int> keyMapping, [bool editable = false])
  {
    // <div><span>keys</span>+</div>
    DivElement el = new DivElement();
    SpanElement keysWrapper = new SpanElement();

    //add list of keys as elements
    keyMapping.forEach((int key, int value){
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
  void hide([int effect = 0])
  {
    menu.settings.client_controltype.v = _currentControlType;
    menu.settings.saveToCookie();
    super.hide(effect);
  }
  @override
  void show([int effect = 0])
  {
    setToControlType(menu.settings.client_controltype.v);
    super.show(effect);
  }
}

