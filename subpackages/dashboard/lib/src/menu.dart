part of menu;

class MenuStatus{
  String title;
  bool showBack = false;
  bool showClose = false;
  MenuStatus(this.title, [this.showBack = false, this.showClose = false]);
}

class TabView{
  Map<int, Element>  _menus;
  int _current = -1;
  Element setupFields(Map<int, Element> menus)
  {
    _menus = menus;
    Element el = new DivElement();
    for(int k = 0; k < menus.length; k++)
    {
      el.append(menus[k]);
      menus[k].style.display = "none";
    }
    return el;
  }
  void showTab(int index){
    if(_current != -1)
    {
      _menus[_current].style.display = "none";
    }
    _current = index;
    _menus[_current].style.display = "block";
  }
}

class Menu<H extends MenuStatus>
{
  List<H> _backqueue = [];
  H _currentStatus;

  //menu element
  Element element;
  UIButton btn_back;
  UIButton btn_close;
  //txt_title is the element with text==title
  Element txt_title;

  void init([bool appendToBody = true])
  {
    btn_back = createBackButton();
    btn_close = createCloseButton();
    element = setupFields();
    element.style.display = "none";
    if(appendToBody)
      document.body.append(element);
  }

  Element setupFields()
  {
    Element el = new DivElement();
    el.id = "menu_bg";
    Element ell = createContent();
    ell.id = "menu_wrapper";

    ell.append(createTitleElement(btn_back,btn_close));
    el.append(ell);
    return el;
  }

  Element createContent(){
    return new DivElement();
  }

  UIButton createBackButton()
  {
    var ret = new UIIconButton("navigate_before",()
    {
      if(_backqueue.isNotEmpty)
        showMenu(_backqueue.removeLast(), false);
      else
        hideMenu();
    });
    ret.element.id = "menu_back";
    return ret;
  }

  UIButton createCloseButton()
  {
    print("Create close");
    var ret = new UIIconButton("close",()
    {
      hideMenu();
    });
    ret.element.id = "menu_close";
    return ret;
  }

  Element createTitleElement(UiElement btn_back, UiElement btn_close)
  {
    Element el = new HeadingElement.h1();
    txt_title = new SpanElement();
    txt_title.text = "Menu";
    el.append(txt_title);
    el.append(btn_back.element);
    el.append(btn_close.element);
    el.id = "menu_title";
    return el;
  }

  void showMenu(H status, [bool storeInHistory = true]){
    if(_currentStatus == status) return;
    element.style.display = "block";
    if(storeInHistory && _currentStatus != null)
      _backqueue.add(_currentStatus);
    _currentStatus = status;

    txt_title.text = status.title;
    btn_back.display(status.showBack && _backqueue.isNotEmpty);
    btn_close.display(status.showClose);
    btn_close.element.style.display = "none";
    print("closebutton: ${status.showClose} ${btn_close.element.style.display}");
  }

  void hideMenu(){
    element.style.display = "none";
    _backqueue.clear();
  }
}

