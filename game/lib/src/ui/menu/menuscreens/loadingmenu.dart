part of game.menu;

class LoadingMenu extends GameMenuScreen
{
  GameMenuController menu;
  LoadingMenu(this.menu);

  Element setupFields()
  {
    Element el = super.setupFields();

    DivElement e = new DivElement();
    e.text = "Loading resources, please wait";
    el.append(e);
    return el;
  }
}
