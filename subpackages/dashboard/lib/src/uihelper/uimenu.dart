part of uihelper;

class UIMenu extends UiElement{
  String title;
  Element el_content;

  UIMenu(this.title){}
  Element createElement([bool expand = true]){
    Element el_wrap = new FieldSetElement();
    Element el_legend = new LegendElement();
    el_content = new DivElement();
    el_wrap.append(el_legend);
    el_wrap.append(el_content);
    var btn = UIToggleIconButton("expand_less","expand_more",(toggled){
      el_content.style.display = toggled ? "none" : "block";
    });
    el_legend.append(btn.element);
    el_legend.appendText(title);
    el_wrap.className = "menu";
    btn.setToggled(!expand);
    return el_wrap;
  }
  void append(UiElement el){
    el_content.append(el.element);
  }
  void appendElement(Element el){
    el_content.append(el);
  }
}

class UIColumn extends UiElement{
  Element el_content;
  Element createElement(){
    el_content = new SpanElement();
    el_content.className = "column";
    return el_content;
  }
  void append(UiElement el){
    el_content.append(el.element);
  }
  void appendElement(Element el){
    el_content.append(el);
  }
}