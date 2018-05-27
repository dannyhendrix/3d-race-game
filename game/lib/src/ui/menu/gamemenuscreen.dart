part of game.menu;

class GameMenuScreen extends MenuScreen<GameMenuController>
{
  bool showStoreIncookie = false;

  GameMenuScreen(GameMenuController m, String title) : super(m, title);
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

  ButtonElement createMenuButtonWithIcon(String label, String icon, [Function onclick])
  {
    ButtonElement btn = createButtonWithIcon(icon, onclick);
    btn.appendText(label);
    btn.classes.add("menu_button");
    return btn;
  }

  ButtonElement createOpenMenuButtonWithIcon(String label, String icon, int menuId)
  {
    return createMenuButtonWithIcon(label,icon,(Event e)
    {
      menu.showMenu(menuId, 0);
    });
  }
}

class GameMessageMenuScreen extends MessageMenu<GameMenuController>
{
  bool showStoreIncookie = false;

  GameMessageMenuScreen(GameMenuController m) : super(m);

}