part of game.menu;

class MainMenu extends GameMenuScreen
{
  GameMenuController menu;
  MainMenu(this.menu) : super("Main menu");

  Element setupFields()
  {
    Element el = super.setupFields();
    el.append(createOpenMenuButtonWithIcon(menu,"Singleplayer","account_circle",menu.MENU_SINGLEPLAYER));
    el.append(createOpenMenuButtonWithIcon(menu,"Settings","settings",menu.MENU_OPTION));
    el.append(createOpenMenuButtonWithIcon(menu,"Controls","videogame_asset",menu.MENU_CONTROLS));
    el.append(createOpenMenuButtonWithIcon(menu,"Credits","info",menu.MENU_CREDITS));

    closebutton = false;
    backbutton = false;

    return el;
  }
}

