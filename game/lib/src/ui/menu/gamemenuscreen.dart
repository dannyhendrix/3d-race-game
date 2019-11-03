part of game.menu;

class GameMenuScreen extends MenuScreen<GameMenuStatus>
{
  bool showStoreIncookie = false;

  UiButton createMenuButtonWithIcon(String label, String icon, [Function onClick])
  {
    return UiButtonIconText(label, icon, onClick).addStyle("menu_button");
  }

  UiButton createOpenMenuButtonWithIcon(Menu menu, String label, String icon, MenuStatus status)
  {
    return createMenuButtonWithIcon(label,icon,()
    {
      menu.showMenu(status);
    });
  }
}