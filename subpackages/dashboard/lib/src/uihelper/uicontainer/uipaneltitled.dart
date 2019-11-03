part of uihelper;

class UiPanelTitled extends UiContainer{
  String title;
  Element el_content;

  UiPanelTitled(this.title);
  Element createElement([bool expand = true]){
    var el_wrap = new FieldSetElement();
    var el_legend = new LegendElement();
    el_content = new DivElement();
    el_wrap.append(el_legend);
    el_wrap.append(el_content);
    var btn = UiButtonToggleIcon("expand_less","expand_more",(toggled){
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