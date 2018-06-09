part of menu;

class MenuScreen
{
  Element element;

  bool backbutton = true;
  bool closebutton = true;
  String title;

  MenuScreen(this.title)
  {

  }
  void init()
  {
    element = setupFields();
    element.style.display = "none";
  }

  Element setupFields()
  {
    Element el = new DivElement();
    el.className = "menu";
    el.id = title.toLowerCase().replaceAll(" ","_");
    return el;
  }

  void show([int effect])
  {
    element.style.display = "block";
  }
  void hide(int effect)
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

  Element createOpenMenuButton(Menu menu, String label, int menuId)
  {
    return createMenuButton(label,(Event e)
    {
      menu.showMenu(menuId, 0);
    });
  }

  Element createOpenMenuIconButton(Menu menu, String icon, int menuId)
  {
    return createMenuIconButton(icon,(Event e)
    {
      menu.showMenu(menuId, 0);
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