part of menu;

class MenuScreen<H extends MenuStatus>
{
  Element element;

  bool backbutton = true;
  bool closebutton = true;

  void init()
  {
    element = setupFields();
    element.style.display = "none";
  }

  Element setupFields()
  {
    Element el = new DivElement();
    el.className = "menu";
    return el;
  }

  void show(H status)
  {
    element.style.display = "block";
  }
  void hide()
  {
    element.style.display = "none";
  }

  Element createMenuButton(String label, [Function onclick])
  {
    ButtonElement btn = new ButtonElement();
    btn.text = label;
    btn.classes.add("menu_button");
    if(onclick != null)
      btn.onClick.listen(onclick);
    return btn;
  }

  Element createMenuIconButton(String icon, [Function onclick])
  {
    ButtonElement btn = new ButtonElement();
    btn.append(createIcon(icon));
    btn.classes.add("menu_button");
    if(onclick != null)
      btn.onClick.listen(onclick);
    return btn;
  }

  Element createIcon(String icon)
  {
    Element iel = new Element.tag("i");
    iel.className = "material-icons";
    iel.text = icon.toLowerCase();
    return iel;
  }

  Element createOpenMenuButton(Menu menu, String label, H status)
  {
    return createMenuButton(label,(Event e)
    {
      menu.showMenu(status);
    });
  }

  Element createOpenMenuIconButton(Menu menu, String icon, H status)
  {
    return createMenuIconButton(icon,(Event e)
    {
      menu.showMenu(status);
    });
  }

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
}