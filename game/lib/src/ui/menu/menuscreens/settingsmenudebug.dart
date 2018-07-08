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

  Map<String, InputForm> settingElementMapping = {};

  SettingsMenuDebug(this.menu);

  Element setupFields()
  {
    Element el = super.setupFields();
    Element form = UIHelper.createForm();
    for(GameSetting s in menu.settings.getMenuSettings())
      form.append(createSettingElement(s));
    form.append(UIHelper.createButtonWithText("Reset cookie", (Event e){
      menu.settings.emptyCookie();
    }));
    el.append(form);
    return el;
  }
  
  Element createSettingElement(GameSetting s)
  {


    if(s is GameSettingWithAllowedValues)
    {
      InputForm form = new InputFormOption(s.description,s.allowedValues);
      settingElementMapping[s.k] = form;
      return form.createElement();
    }
    else if(s is GameSettingWithEnum)
    {
      InputFormOption form = new InputFormOption(s.description,s.allowedValues);
      form.objectToString = s.convertTo;
      settingElementMapping[s.k] = form;
      return form.createElement();
    }
    else if(s.v is int)
    {
      InputForm form = new InputFormInt(s.description);
      settingElementMapping[s.k] = form;
      return form.createElement();
    }
    else if(s.v is double)
    {
      InputForm form = new InputFormDouble(s.description);
      settingElementMapping[s.k] = form;
      return form.createElement();
    }
    else if(s.v is bool)
    {
      InputForm form = new InputFormBool(s.description);
      settingElementMapping[s.k] = form;
      return form.createElement();
    }
    else
    {
      InputForm form =  new InputFormString(s.description);
      settingElementMapping[s.k] = form;
      return form.createElement();
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

