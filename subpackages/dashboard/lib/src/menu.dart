part of menu;

class MenuStatus{
  String title;
  bool showBack = false;
  bool showClose = false;
  MenuStatus(this.title, [this.showBack = false, this.showClose = false]);
}

class Menu<H extends MenuStatus>
{
  List<H> _backqueue = [];
  H _currentStatus;

  //menu element
  UiElement element;
  UiButton btn_back;
  UiButton btn_close;
  //txt_title is the element with text==title
  UiTitle txt_title;

  void init([bool appendToBody = true])
  {
    btn_back = createBackButton();
    btn_close = createCloseButton();
    element = setupFields();
    element.hide();
    if(appendToBody)
      document.body.append(element.element);
  }

  UiElement setupFields()
  {
    var el = new UiPanel();
    el.element.id = "menu_bg";
    var ell = createContent();
    ell.element.id = "menu_wrapper";

    ell.append(createTitleElement(btn_back,btn_close));
    el.append(ell);
    return el;
  }

  UiContainer createContent(){
    return new UiPanel();
  }

  UiButton createBackButton()
  {
    var ret = new UiButtonIcon("navigate_before",()
    {
      if(_backqueue.isNotEmpty)
        showMenu(_backqueue.removeLast(), false);
      else
        hideMenu();
    });
    ret.element.id = "menu_back";
    return ret;
  }

  UiButton createCloseButton()
  {
    var ret = new UiButtonIcon("close",()
    {
      hideMenu();
    });
    ret.element.id = "menu_close";
    return ret;
  }

  UiElement createTitleElement(UiElement btn_back, UiElement btn_close)
  {
    var el = new UiPanel();
    txt_title = UiTitle("Menu");
    el.append(txt_title);
    el.append(btn_back);
    el.append(btn_close);
    el.element.id = "menu_title";
    return el;
  }

  void showMenu(H status, [bool storeInHistory = true]){
    if(_currentStatus == status) return;
    element.show();
    if(storeInHistory && _currentStatus != null)
      _backqueue.add(_currentStatus);
    _currentStatus = status;

    txt_title.changeText(status.title);
    btn_back.display(status.showBack && _backqueue.isNotEmpty);
    btn_close.display(status.showClose);
    btn_close.element.style.display = "none";
  }

  void hideMenu(){
    element.hide();
    _backqueue.clear();
  }
}

