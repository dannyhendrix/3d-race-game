part of game.menu;

class GameMenuScreen extends MenuScreen<GameMenuStatus>
{
  bool showStoreIncookie = false;

  Element createMenuButtonWithIcon(String label, String icon, [Function onClick])
  {
    Element btn = UIHelper.createButtonWithTextAndIcon(label, icon, onClick);
    btn.classes.add("menu_button");
    return btn;
  }

  Element createOpenMenuButtonWithIcon(Menu menu, String label, String icon, MenuStatus status)
  {
    return createMenuButtonWithIcon(label,icon,(Event e)
    {
      menu.showMenu(status);
    });
  }
}