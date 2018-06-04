part of game.menu;

class MainMenu extends GameMenuScreen
{
  MainMenu(GameMenuController m) : super(m, "Main menu");

  Element setupFields()
  {
    Element el = super.setupFields();
    el.append(createOpenMenuButtonWithIcon("Singleplayer","account_circle",menu.MENU_SINGLEPLAYER));
    el.append(createOpenMenuButtonWithIcon("Settings","settings",menu.MENU_OPTION));
    el.append(createOpenMenuButtonWithIcon("Controls","videogame_asset",menu.MENU_CONTROLS));
    el.append(createOpenMenuButtonWithIcon("Credits","info",menu.MENU_CREDITS));

    closebutton = false;
    backbutton = false;

    return el;
  }
}

