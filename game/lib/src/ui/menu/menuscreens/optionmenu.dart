part of teamx.ui;

class OptionMenu extends TeamxMenuScreen
{
  bool showStoreIncookie = true;
  InputElement el_scale;

  Map<String, SettingInput> settingElementMapping = {};
  
  OptionMenu(TeamxMenuController m) : super(m, "Options");

  Element setupFields()
  {
    Element el = super.setupFields();
    el.append(_createInputScale());
    return el;
  }

  Element _createInputScale()
  {
    DivElement el = new DivElement();
    el.className = "setting setscale";
    Element el_title = new SpanElement();
    el_title.text = "Scale";
    el_title.className = "title";
    Element el_value = new SpanElement();
    el_value.className = "value";
    el_scale = new InputElement(type:"range");
    GameSettingWithAllowedValues cameraSetting = menu.settings.camerascale;
    int valueIndex = cameraSetting.allowedValues.indexOf(cameraSetting.v);
    if (valueIndex == -1) valueIndex = 0;
    int min = 0;
    int max = cameraSetting.allowedValues.length-1;
    el_scale.max = "$max";
    el_scale.min = "$min";
    el_scale.value = "$valueIndex";
    el_scale.onChange.listen((Event e)
    {
      int value = int.parse(el_scale.value);
      if(value > max)
        value = max;
      if(value < min)
        value = min;
      menu.settings.camerascale.v = cameraSetting.allowedValues[value];
    });
    el.append(el_title);
    el_value.append(el_scale);
    el.append(el_value);
    return el;
  }

  void storeSettings()
  {
    menu.settings.saveToCookie();
  }
  
  void loadSettings()
  {
    GameSettingWithAllowedValues cameraSetting = menu.settings.camerascale;
    int valueIndex = cameraSetting.allowedValues.indexOf(cameraSetting.v);
    if (valueIndex == -1) valueIndex = 0;
    el_scale.value = "$valueIndex";
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

