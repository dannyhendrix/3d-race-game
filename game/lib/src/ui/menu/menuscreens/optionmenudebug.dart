part of game.menu;

typedef T GetValueFromInput<T>();
typedef void SetValueToInput<T>(T val);

class SettingInput<T>
{
  GetValueFromInput<T> getter;
  SetValueToInput<T> setter;
  bool changed = false;
  SettingInput(this.getter, this.setter);
}

class OptionMenuDebug extends GameMenuScreen
{
  GameMenuController menu;
  bool showStoreIncookie = true;

  Map<String, SettingInput> settingElementMapping = {};
  
  OptionMenuDebug(this.menu) : super("Options");

  Element setupFields()
  {
    Element el = super.setupFields();
    for(GameSetting s in menu.settings.getMenuSettings())
      el.append(createSettingElement(s));
    el.append(createMenuButton("Reset cookie", (Event e){
      menu.settings.emptyCookie();
    }));
    return el;
  }
  
  Element createSettingElement(GameSetting s)
  {
    DivElement el = new DivElement();
    el.className = "setting";
    Element el_title = new SpanElement();
    el_title.className = "title";
    el_title.text = s.description;
    Element el_value = new SpanElement();
    el_value.className = "value";

    if(s is GameSettingWithAllowedValues)
    {
      SelectElement iel = new SelectElement();
      for(var a in s.allowedValues)
      {
       OptionElement o = new OptionElement(data: a.toString());
       iel.append(o);
      }
      settingElementMapping[s.k] = new SettingInput((){
        return s.allowedValues[iel.selectedIndex];
      }, (var v){
        int index = 0;
        for(var a in s.allowedValues)
         iel.options[index++].selected = a == v;
      });
      iel.onChange.listen((Event e){
        settingElementMapping[s.k].changed = true;
      });
      el_value.append(iel);
    }
    else if(s is GameSettingWithEnum)
    {
      SelectElement iel = new SelectElement();
      for(var a in s.allowedValues)
      {
       OptionElement o = new OptionElement(data: s.convertTo(a));
       iel.append(o);
      }
      settingElementMapping[s.k] = new SettingInput((){
        return s.allowedValues[iel.selectedIndex];
      }, (var v){
        int index = 0;
        for(var a in s.allowedValues)
         iel.options[index++].selected = a == v;
      });
      iel.onChange.listen((Event e){
        settingElementMapping[s.k].changed = true;
      });
      el_value.append(iel);
    }
    else if(s.v is int)
    {
      InputElement iel = new InputElement(type: "number");
      settingElementMapping[s.k] = new SettingInput<int>((){
        return int.parse(iel.value);
      },(int v){
        iel.value = v.toString();
      });
      iel.onChange.listen((Event e){
        settingElementMapping[s.k].changed = true;
      });
      el_value.append(iel);
    }
    else if(s.v is double)
    {
      InputElement iel = new InputElement(type: "number");
      settingElementMapping[s.k] = new SettingInput<double>((){
        return double.parse(iel.value);
      },(double v){
        iel.value = v.toString();
      });
      iel.onChange.listen((Event e){
        settingElementMapping[s.k].changed = true;
      });
      el_value.append(iel);
    }
    else if(s.v is bool)
    {
      CheckboxInputElement iel = new CheckboxInputElement();
      settingElementMapping[s.k] = new SettingInput((){
        return iel.checked;
      },(var v){
        iel.checked = s.v;
      });
      iel.onChange.listen((Event e){
        settingElementMapping[s.k].changed = true;
      });
      el_value.append(iel);
    }
    else
    {
      InputElement iel = new InputElement(type: "text");
      //iel.value = s.v.toString();
      settingElementMapping[s.k] = new SettingInput((){
        return iel.value;
      },(var v){
        iel.value = v.toString();
      });
      iel.onChange.listen((Event e){
        settingElementMapping[s.k].changed = true;
      });
      el_value.append(iel);
    }
    
    el.append(el_title);
    el.append(el_value);
    return el;
  }
  
  void storeSettings()
  {
    for(GameSetting s in menu.settings.getMenuSettings())
    {
      SettingInput gs = settingElementMapping[s.k];
      if(gs.changed)
      {
        s.v = gs.getter();
        gs.changed = false;
      }
    }
    menu.settings.saveToCookie();
  }
  
  void loadSettings()
  {
    for(GameSetting s in menu.settings.getMenuSettings())
      settingElementMapping[s.k].setter(s.v);
  }
  
  void hide([int effect = 0])
  {
    storeSettings();
    super.hide(effect);
  }
  
  void show([int effect = 0])
  {
    loadSettings();
    super.show(effect);
  }
}

