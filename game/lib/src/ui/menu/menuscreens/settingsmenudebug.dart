part of game.menu;

typedef T GetValueFromInput<T>();
typedef void SetValueToInput<T>(T val);
/*
class SettingInput<T>
{
  GetValueFromInput<T> getter;
  SetValueToInput<T> setter;
  bool changed = false;
  SettingInput(this.getter, this.setter);
}
*/
class SettingsMenuDebug extends GameMenuScreen
{
  GameMenuController menu;
  bool showStoreIncookie = true;

  Map<String, UiInput> settingElementMapping = {};

  SettingsMenuDebug(this.menu);

  Element setupFields()
  {
    Element el = super.setupFields();
    var form = UiPanelForm();
    for(GameSetting s in menu.settings.getMenuSettings())
      form.append(createSettingElement(s));
    form.append(UITextButton("Reset cookie", (){
      menu.settings.emptyCookie();
    }));
    el.append(form.element);
    return el;
  }
  
  UiElement createSettingElement(GameSetting s)
  {
    if(s is GameSettingWithAllowedValues)
    {
      var form = new UiInputOption(s.description,s.allowedValues);
      settingElementMapping[s.k] = form;
      return form;
    }
    else if(s is GameSettingWithEnum)
    {
      var form = new UiInputOption(s.description,s.allowedValues);
      form.objectToString = s.convertTo;
      settingElementMapping[s.k] = form;
      return form;
    }
    else if(s.v is int)
    {
      var form = new UiInputInt(s.description);
      settingElementMapping[s.k] = form;
      return form;
    }
    else if(s.v is double)
    {
      var form = new UiInputDouble(s.description);
      settingElementMapping[s.k] = form;
      return form;
    }
    else if(s.v is bool)
    {
      var form = new UiInputBoolIcon(s.description);
      settingElementMapping[s.k] = form;
      return form;
    }
    else
    {
      var form =  new UiInputText(s.description);
      settingElementMapping[s.k] = form;
      return form;
    }
  }
  
  void storeSettings()
  {
    for(GameSetting s in menu.settings.getMenuSettings())
    {
      var gs = settingElementMapping[s.k];
      s.v = gs.getValue();
    }
    menu.settings.saveToCookie();
  }
  
  void loadSettings()
  {
    for(GameSetting s in menu.settings.getMenuSettings())
      settingElementMapping[s.k].setValue(s.v);
  }
  
  void hide()
  {
    storeSettings();
    super.hide();
  }
  
  void show(GameMenuStatus status)
  {
    loadSettings();
    super.show(status);
  }
}

