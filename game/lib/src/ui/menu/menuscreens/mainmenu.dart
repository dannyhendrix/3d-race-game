part of game.menu;

class MainMenu extends GameMenuScreen
{
  MainMenu(GameMenuController m) : super(m, "Main menu");

  Element setupFields()
  {
    Element el = super.setupFields();
    el.append(createOpenMenuButtonWithIcon("Singleplayer","account_circle",menu.MENU_SINGLEPLAYER));
    el.append(createOpenMenuButtonWithIcon("Multiplayer","supervised_user_circle",menu.MENU_MAIN));
    el.append(createOpenMenuButtonWithIcon("Settings","settings",menu.MENU_MAIN));
    el.append(createOpenMenuButtonWithIcon("Controls","videogame_asset",menu.MENU_MAIN));
    el.append(createOpenMenuButtonWithIcon("Credits","info",menu.MENU_CREDITS));
/*
    if(menu.settings.debug.v)
    {
      el.append(createSubTitleElement("In DEBUG mode. Settings.DEBUG == true"));
      el.append(createOpenMenuButtonWithIcon("Select level","terrain",menu.MENU_LEVEL));
      el.append(createOpenMenuButtonWithIcon("Edit Character","face",menu.MENU_CHARACTER));
      el.append(createOpenMenuButtonWithIcon("Options","settings",menu.MENU_OPTION));
      el.append(createOpenMenuButtonWithIcon("Controls","videogame_asset",menu.MENU_CONTROLS));
    }
*/
    closebutton = false;
    backbutton = false;
    
    //add(createOpenMenuButton("Options",TeamxMenuController.MENU_OPTION));
    return el;
  }
}

