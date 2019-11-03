part of game.menu;

class GameMenuScreen extends MenuScreen<GameMenuStatus>
{
  bool showStoreIncookie = false;

  UIButton createMenuButtonWithIcon(String label, String icon, [Function onClick])
  {
    return UiIconTextButton(label, icon, onClick).addStyle("menu_button");
  }

  UIButton createOpenMenuButtonWithIcon(Menu menu, String label, String icon, MenuStatus status)
  {
    return createMenuButtonWithIcon(label,icon,()
    {
      menu.showMenu(status);
    });
  }
}