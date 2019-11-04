part of menu;

class MenuScreen<H extends MenuStatus>
{
  UiElement element;

  bool backbutton = true;
  bool closebutton = true;

  void init()
  {
    element = setupFields();
    element.hide();
  }

  UiContainer setupFields()
  {
    var el = new UiPanel();
    el.addStyle("menu");
    return el;
  }

  void show(H status)
  {
    element.show();
  }
  void hide()
  {
    element.hide();
  }
/*
  Element createTitleElement(String title)
  {
    HeadingElement h = new HeadingElement.h1();
    h.text = title;
    h.classes.add("menu_title");
    return h;
  }

  Element createSubTitleElement(String title)
  {
    HeadingElement h = new HeadingElement.h2();
    h.text = title;
    h.classes.add("menu_subtitle");
    return h;
  }

  Element createSpacerElement()
  {
    DivElement e = new DivElement();
    e.classes.add("menu_spacer");
    return e;
  }
 */
}