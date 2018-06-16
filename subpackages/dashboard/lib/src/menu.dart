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
  Element btn_back;
  Element btn_close;
  //txt_title is the element with text==title
  Element txt_title;

  void init([bool appendToBody = true])
  {
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

    ell.append(createTitleElement(createBackButton(),createCloseButton()));
    el.append(ell);
    return el;
  }

  Element createContent(){
    return new DivElement();
  }

  Element createBackButton()
  {
    ButtonElement ret = new ButtonElement();
    ret.id = "menu_back";
    ret.onClick.listen((Event e)
    {
      if(_backqueue.isNotEmpty)
        showMenu(_backqueue.removeLast(), false);
      else
        hideMenu();
    });

    btn_back = ret;
    return ret;
  }

  Element createCloseButton()
  {
    ButtonElement ret = new ButtonElement();
    ret.id = "menu_close";
    ret.onClick.listen((Event e)
    {
      hideMenu();
    });
    btn_close = ret;
    return ret;
  }

  Element createTitleElement(Element btn_back, Element btn_close)
  {
    DivElement el = new DivElement();
    txt_title = new SpanElement();
    txt_title.text = "Menu";
    el.append(txt_title);
    el.append(btn_back);
    el.append(btn_close);
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
    btn_back.style.display = (status.showBack && _backqueue.isNotEmpty) ? "block" : "none";
    btn_close.style.display = status.showClose ? "block" : "none";
  }

  void hideMenu(){
    element.style.display = "none";
    _backqueue.clear();
  }
}

