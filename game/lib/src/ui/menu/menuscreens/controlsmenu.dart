part of game.menu;

class ControlsMenu extends GameMenuScreen
{
  GameMenuController menu;
  bool showStoreIncookie = true;
  EnterKey enterKey = new EnterKey(false);
  Map<int, UiElement> keyToElementMapping = {};

  ControlsMenu(this.menu);

  UiContainer setupFields()
  {
    var el = super.setupFields();
    el.append(_createKeyboardControls());
    el.append(enterKey.createEnterKeyScreen());
    el.element.id = "controls";
    return el;
  }

  UiElement _createKeyboardControls()
  {
    var el = new UiPanel();
    /*
    //tabs
    var el_tabs = new UiPanel();
    el_tabs.addStyle("tabs");
    var el_tabs_content = new UiPanel();
    el_tabs_content.className = "tabs_content";

    UiElement el_current_tab;
    UiElement el_current_tab_content;

    var setCurrentTab = (UiElement newCurrent, UiElement newCurrentContent, [ControlKeyType keyType])
    {
      if(el_current_tab_content != null)
        el_current_tab_content.hide();
      el_current_tab_content = newCurrentContent;
      el_current_tab_content.show();
      if(el_current_tab != null)
        el_current_tab.removeStyle("current");
      el_current_tab = newCurrent;
      el_current_tab.addStyle("current");
      if(keyType != null)
        menu.settings.client_controlkeytype.v = keyType;
    };*/
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
  UiElement _createKeyboardControlsTable(Map<int, Control> keyMapping, [bool editable = false])
  {
    var ta = new UiTable(2,4);
    ta.addStyle("controls_menu_table");




    /*
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
    */
    var addControl = (String description, Control key, int row)
    {
      ta.append(0, row, UiText(description)..addStyle("controls_label"));
      ta.append(1, row, createEditKeyElement(key, keyMapping, editable)..addStyle("controls_keys"));
    };
    addControl("Accelerate",Control.Accelerate,0);
    addControl("Brake",Control.Brake,1);
    addControl("Steer left",Control.SteerLeft,2);
    addControl("Steer right",Control.SteerRight,3);
    return ta;
  }
  UiElement createKeyElement(int key, bool editable)
  {
    if(editable && keyToElementMapping.containsKey(key))
      keyToElementMapping[key].element.remove();
    UiButtonText el;
    el = new UiButtonText(KeycodeToString.translate(key),(){
      if(editable)
      {
          menu.settings.client_keys.v.remove(key);
          el.element.remove();
      }
    });
    keyToElementMapping[key] = el;
    el.addStyle("control_key");
    if(editable) el.addStyle("editable");

    return el;
  }
  UiElement createEditKeyElement(Control controlkey, Map<int,Control> keyMapping, [bool editable = false])
  {
    // <div><span>keys</span>+</div>
    var el = new UiPanel();
    var keysWrapper = new UiPanelInline();

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
      var el_add = new UiButtonText("+",(){
        enterKey.requestKey((int key)
        {
          keyMapping[key] = controlkey;
          keysWrapper.append(createKeyElement(key, editable));
        });
      });
      el_add.addStyle("control_key");
      el_add.addStyle("add");

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

