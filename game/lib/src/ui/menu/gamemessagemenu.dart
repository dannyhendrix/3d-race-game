part of game.menu;

class GameMessageMenu extends GameMessageMenuScreen
{
  GameMessageMenu(GameMenuController m) : super(m);

  DivElement txt_element;
  ButtonElement btn_level;
  ButtonElement btn_restart;
  ButtonElement btn_nextlevel;

  HeadingElement txt_title;


  Element setupFields()
  {
    Element el = super.setupFields();

    txt_element = new DivElement();
    txt_element.append(txt_message);
    txt_element.className = "message_menu_message";

    btn_level = createOpenMenuButtonWithTextAndIcon("list","Select level",menu.MENU_LEVEL);
    btn_restart = createButtonWithTextAndIcon("refresh","Restart level",(Event e){menu.dashboard.startCurrentLevel();});
    btn_nextlevel = createButtonWithTextAndIcon("play_arrow","Next level",(Event e){menu.dashboard.startNextLevel();});
    txt_title = createTitleElement("Message");

    btn_level.style.display = "none";
    btn_restart.style.display = "none";
    btn_nextlevel.style.display = "none";

    el.append(txt_element);
    el.append(btn_level);
    el.append(btn_restart);
    el.append(btn_nextlevel);

    return el;
  }

  void setTitle(String t)
  {
    txt_title.text = t;
  }

  void setText(String t)
  {
    txt_element.innerHtml = t;
  }

  void setShowBack(bool b)
  {
    //TODO:???
    /*
    if(b == true)
      btn_back.style.display = "";
    else
      btn_back.style.display = "none";
      * */
  }

  void setShowRestart(bool b)
  {
    if(b == true)
      btn_restart.style.display = "";
    else
      btn_restart.style.display = "none";
  }

  void setShowLevel(bool b)
  {
    if(b == true)
      btn_level.style.display = "";
    else
      btn_level.style.display = "none";
  }

  void setShowNextLevel(bool b)
  {
    if(b == false)
    {
      btn_nextlevel.style.display = "none";
      return;
    }
    if(menu.dashboard.levelController.hasNextLevel() == false)
      btn_nextlevel.style.display = "none";
    else
      btn_nextlevel.style.display = "";
  }

  void setShowText()
  {
    txt_element.append(txt_message);
  }

  void setShowMessageImage(MessageImage img)
  {
    img.update();
    txt_element.nodes.clear();
    txt_element.append(img.layer.canvas);
  }

  Element createButtonWithTextAndIcon(String icon, String label, [Function onclick])
  {
    Element el = createMenuIconButton(icon, onclick);
    el.appendText(label);
    return el;
  }

  ButtonElement createOpenMenuButtonWithTextAndIcon(String icon, String label, int menuId)
  {
    Element el = createOpenMenuIconButton(icon, menuId);
    el.appendText(label);
    return el;
  }
}

