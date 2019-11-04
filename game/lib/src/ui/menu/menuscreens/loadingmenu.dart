part of game.menu;

class LoadingMenu extends GameMenuScreen
{
  GameMenuController menu;
  LoadingMenu(this.menu);

  UiContainer setupFields()
  {
    var el = super.setupFields();
    el.append(new UiText("Loading resources, please wait"));
    return el;
  }
}
