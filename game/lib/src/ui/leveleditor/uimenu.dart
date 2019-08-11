part of game.leveleditor;

class UIMenu{
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
    el_legend.append(btn.createElement());
    el_legend.appendText(title);
    el_wrap.className = "menu";
    btn.setToggled(!expand);
    return el_wrap;
  }
  void append(Node el){
    el_content.append(el);
  }
}