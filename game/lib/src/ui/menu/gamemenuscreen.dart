part of game.menu;

abstract class GameMenuScreen extends UiPanel{
  String title = "Title";
  GameMenuPage pageId;
  bool showBack = true;
  bool showClose = false;
  GameMenuController _menu;

  GameMenuScreen(ILifetime lifetime, this.pageId) : super(lifetime);
  void attachToMenu(GameMenuController menu) => _menu = menu;
  void enterMenu(GameMenuStatus status){}
  void exitMenu(){}
}

abstract class GameMenuMainScreen extends GameMenuScreen{
  GameMainMenuPage mainPageId;
  GameMenuMainScreen(ILifetime lifetime, this.mainPageId) : super(lifetime, GameMenuPage.Main);
}

class MenuButton extends UiButtonIconText{
  MenuButton(ILifetime lifetime) : super(lifetime);
  @override
  void build(){
    super.build();
    addStyle("menu_button");
  }
}