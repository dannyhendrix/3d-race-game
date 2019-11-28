part of game.menu;

class ControlsMenu extends GameMenuMainScreen
{
  Lifetime _lifetime;
  EnterKey _enterKey;
  UiTable _controlsTable;
  GameSettings _settings;
  Map<int, UiElement> _keyToElementMapping = {};

  ControlsMenu(ILifetime lifetime) : super(lifetime, GameMainMenuPage.Controls){
    _lifetime = lifetime;
    _enterKey = lifetime.resolve();
    _settings = lifetime.resolve();
  }

  @override
  void build(){
    super.build();
    setStyleId("controls");
    append(_enterKey);
  }

  @override
  void enterMenu(GameMenuStatus status){
    if(_controlsTable != null){
      _controlsTable.element.remove();
    }
    _controlsTable = _createKeyboardControlsTable(_settings.client_keys.v, true);
    append(_controlsTable);
    super.enterMenu(status);
  }

  @override
  void exitMenu(){
    _settings.saveToCookie();
    super.exitMenu();
  }

  UiElement _createKeyboardControlsTable(Map<int, Control> keyMapping, bool editable)
  {
    UiTable controlsTable = _lifetime.resolve();
    controlsTable.addStyle("controls_menu_table");
    _addControl(controlsTable,"Accelerate",Control.Accelerate,editable,keyMapping);
    _addControl(controlsTable,"Brake",Control.Brake,editable,keyMapping);
    _addControl(controlsTable,"Steer left",Control.SteerLeft,editable,keyMapping);
    _addControl(controlsTable,"Steer right",Control.SteerRight,editable,keyMapping);
    return controlsTable;
  }
  void _addControl(UiTable controlsTable, String description, Control key, bool editable, Map<int,Control> keyMapping)
  {
    controlsTable.addRow([
      _lifetime.resolve<UiText>()..addStyle("controls_label")..changeText(description),
      _createEditKeyElement(key, keyMapping, editable)..addStyle("controls_keys")
    ]);
  }
  UiElement _createKeyElement(int key, bool editable)
  {
    if(editable && _keyToElementMapping.containsKey(key))
      _keyToElementMapping[key].element.remove();
    UiButtonText el = _lifetime.resolve()
      ..changeText(KeycodeToString.translate(key))
      ..addStyle("control_key");
    el.setOnClick((){
      if(editable)
      {
          _settings.client_keys.v.remove(key);
          el.element.remove();
      }
    });
    _keyToElementMapping[key] = el;
    if(editable) el.addStyle("editable");
    return el;
  }
  UiElement _createEditKeyElement(Control controlkey, Map<int,Control> keyMapping, [bool editable = false])
  {
    UiPanel el = _lifetime.resolve();
    UiPanelInline keysWrapper = _lifetime.resolve();

    keyMapping.forEach((int key, Control value){
      if(value != controlkey)
        return;
      keysWrapper.append(_createKeyElement(key, editable));
    });

    el.append(keysWrapper);

    if(editable)
    {
      UiButtonText el_add = _lifetime.resolve()..changeText("+")..addStyle("control_key")..addStyle("control_key");

      el_add.setOnClick((){
        _enterKey.requestKey((int key)
        {
          keyMapping[key] = controlkey;
          keysWrapper.append(_createKeyElement(key, editable));
        },false); //TODO: setting to allow mouseInput
      });

      el.append(el_add);
    }

    return el;
  }
}

