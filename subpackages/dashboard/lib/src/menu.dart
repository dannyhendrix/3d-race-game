part of menu;

class Menu <T extends MenuScreen, M extends MessageMenu>
{
  //menu element
  Element element;
  Map<int,T> menus;
  int _currentmenu = -1;
  Element btn_back;
  Element btn_close;
  //txt_title is the element with text==title
  Element txt_title;
  List _backqueue = new List<int>();
  M messagemenu;

  Menu()
  {

  }

  Map<int,T> getMenus()
  {
    return {};
  }

  void init([bool appendToBody = true])
  {
    menus = getMenus();
    messagemenu = createMessageMenu();
    menus[-2] = messagemenu;
    element = setupFields();
    element.style.display = "none";
    if(appendToBody)
      document.body.append(element);
  }

  Element setupFields()
  {
    Element el = new DivElement();
    el.id = "menu_bg";
    Element ell = new DivElement();
    ell.id = "menu_wrapper";

    ell.append(createTitleElement(createBackButton(),createCloseButton()));

    for(int k in menus.keys)
    {
      menus[k].init();
      ell.append(menus[k].element);
    }

    el.append(ell);
    return el;
  }

  Element createBackButton()
  {
    ButtonElement ret = new ButtonElement();
    ret.id = "menu_back";
    ret.onClick.listen((Event e)
    {
      if(_currentmenu != -1 && _backqueue.length > 0)
        showMenu(_backqueue.removeLast(),0,false);
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
  
  M createMessageMenu()
  {
	return new MessageMenu(this);
  }

  bool isActiveMenu()
  {
    return _currentmenu != -1;
  }

  void showMessage(String title, String message, [bool viewCloseButton = true, bool viewBackButton = false])
  {
    messagemenu.setMessage(title, message,viewCloseButton, viewBackButton);
    showMenu(-2);
  }

  void showMenu(int m, [int effect = 0, bool storeInHistory = true])
  {
    int cm = _currentmenu;
    if(_currentmenu != -1)
    {
      if(storeInHistory)
        _backqueue.add(cm);
      menus[_currentmenu].hide(effect);
    }
    element.style.display = "block";

    menus[m].show(effect);
    _currentmenu = m;

    txt_title.text = menus[m].title;
    btn_back.style.display = (menus[m].backbutton && _backqueue.length > 0) ? "block" : "none";
    btn_close.style.display = (menus[m].closebutton) ? "block" : "none";
  }

  void hideMenu([int effect = 0])
  {
    if(_currentmenu == -1)
      return;
    menus[_currentmenu].hide(effect);
    _currentmenu = -1;

    element.style.display = "none";
    _backqueue.clear();
  }

  void toggleMenu(int m, [int effect = 0])
  {
    if(_currentmenu == m)
      hideMenu(effect);
    else
      showMenu(m,effect);
  }

  T getMenu(int menu)
  {
    return menus[menu];
  }
}

