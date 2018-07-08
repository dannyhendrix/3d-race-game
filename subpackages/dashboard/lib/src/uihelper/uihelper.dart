part of uihelper;

class UIHelper{

  static Element createIcon(String icon){
    Element iel = new Element.tag("i");
    iel.className = "material-icons";
    iel.text = icon.toLowerCase();
    return iel;
  }
  static Element createButton([Function onClick = null]){
    ButtonElement btn = new ButtonElement();
    btn.onTouchStart.listen((TouchEvent e){
      e.preventDefault();
      if(onClick != null)onClick(e);
    });
    btn.onClick.listen((MouseEvent e){
      e.preventDefault();
      if(onClick != null)onClick(e);
    });
    return btn;
  }
  static Element createButtonWithIcon(String icon, [Function onClick = null]){
    ButtonElement btn = createButton(onClick);
    btn.append(createIcon(icon));
    return btn;
  }
  static Element createButtonWithText(String text, [Function onClick = null]){
    ButtonElement btn = createButton(onClick);
    Element eltxt = new SpanElement();
    eltxt.text = text;
    btn.append(eltxt);
    return btn;
  }
  static Element createButtonWithTextAndIcon(String text, String icon, [Function onClick = null]){
    ButtonElement btn = createButton(onClick);
    btn.append(createIcon(icon));
    Element eltxt = new SpanElement();
    eltxt.text = text;
    btn.append(eltxt);
    return btn;
  }
  static Element createOptionSelect(String label, List options, int selectedIndex, [OnValueChange<int> onChange = null]){
    InputFormOption input = new InputFormOption(label, options);
    Element el = input.createElement();
    input.setValue(selectedIndex);
    input.onValueChange = onChange;
    return el;
  }
  static Element createRadioSelect(String label, List options, int selectedIndex, [OnValueChange<int> onChange = null]){
    InputFormRadio input = new InputFormRadio(label,options);
    Element el = input.createElement();
    input.setValue(selectedIndex);
    input.onValueChange = onChange;
    return el;
  }
  static Element createTextInput(String label, String value, [OnValueChange<String> onChange = null]){
    InputFormString input = new InputFormString(label);
    Element el = input.createElement();
    input.setValue(value);
    input.onValueChange = onChange;
    return el;
  }
  static Element createBoolInput(String label, bool value, [OnValueChange<bool> onChange = null]){
    InputFormBool input = new InputFormBool(label);
    Element el = input.createElement();
    input.setValue(value);
    input.onValueChange = onChange;
    return el;
  }
  //TODO: boolean input/checkbox
  static Element createPanel(String title){
    Element el_wrap = new FieldSetElement();
    Element el_legend = new LegendElement();
    el_legend.text = title;
    el_wrap.append(el_legend);
    return el_wrap;
  }
  static Element createForm(){
    Element el = new FormElement();
    return el;
  }
  static Element createTitle(String text){
    Element el = new HeadingElement.h1();
    el.text = text;
    return el;
  }
}