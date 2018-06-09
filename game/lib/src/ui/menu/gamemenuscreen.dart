part of game.menu;

class GameMenuScreen extends MenuScreen
{
  bool showStoreIncookie = false;

  GameMenuScreen(String title) : super(title);
/*
  ButtonElement createMenuIconButton(String icon, [Function onclick])
  {
    ButtonElement btn = createMenuIconButton(icon,onclick);
    btn.classes.add("menu_button_icon");
    return btn;
  }
*/
  Element createButtonWithIcon(String icon, Function onClick)
  {
    DivElement btn = new DivElement();
    btn.onClick.listen((MouseEvent e){ e.preventDefault(); onClick(e); });
    btn.onTouchStart.listen((TouchEvent e){ e.preventDefault(); onClick(e); });
    btn.append(createIcon(icon));
    return btn;
  }

  Element createMenuButtonWithIcon(String label, String icon, [Function onclick])
  {
    Element btn = createButtonWithIcon(icon, onclick);
    btn.appendText(label);
    btn.classes.add("menu_button");
    return btn;
  }

  Element createOpenMenuButtonWithIcon(Menu menu, String label, String icon, int menuId)
  {
    return createMenuButtonWithIcon(label,icon,(Event e)
    {
      menu.showMenu(menuId, 0);
    });
  }
}