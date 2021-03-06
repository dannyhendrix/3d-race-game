part of uihelper;

class UiPanelTitled extends UiContainer {
  UiPanel el_content;
  UiButtonToggleIconText btn_expand;

  DivElement _el_wrap;
  UiPanel _el_legend;

  UiPanelTitled(ILifetime lifetime) : super(lifetime) {
    btn_expand = lifetime.resolve();
    _el_wrap = lifetime.resolve();
    _el_legend = lifetime.resolve();
    el_content = lifetime.resolve();
    element = _el_wrap;
  }

  @override
  void build() {
    super.build();
    btn_expand.changeIconToggle("expand_less", "expand_more");
    btn_expand.setOnClick(_onBtnExpand);
    _el_wrap.append(_el_legend.element);
    _el_wrap.append(el_content.element);
    _el_legend.append(btn_expand);
    _el_legend.addStyle("title");
    el_content.addStyle("content");
    _el_wrap.className = "menu";
  }

  void append(UiElement el) {
    el_content.append(el);
  }

  void appendElement(Element el) {
    el_content.appendElement(el);
  }

  void clear() {
    el_content.clear();
  }

  void setExpand(bool expand) {
    btn_expand.setToggled(!expand);
  }

  void changeTitle(String title) {
    btn_expand..changeText(title);
  }

  void _onBtnExpand() {
    el_content.display(!btn_expand.toggled);
  }
}
