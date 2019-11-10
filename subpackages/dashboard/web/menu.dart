import "dart:html";
import "package:dashboard/uihelper.dart";
import "package:dashboard/menu.dart";
import "package:dependencyinjection/dependencyinjection.dart";

enum MenuPage {MainMenu, TestMenu}

void main(){
  var lifetime = DependencyBuilderFactory().createNew((builder){
    builder.registerModule(UiMenuComposition());
    builder.registerModule(UiComposition());
  });
  var menu = lifetime.resolve<MenuExample>();
  menu.showMenu(MenuPage.MainMenu);
  document.body.append(menu.element);
}
class UiMenuComposition implements IDependencyModule{
  @override
  void load(IDependencyBuilder builder) {
    builder.registerType((lifetime) => new MenuMain(lifetime)..build(), additionRegistrations: [MenuScreenExampleBase], lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => new MenuTest(lifetime)..build(), additionRegistrations: [MenuScreenExampleBase], lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => new MenuHistory<MenuPage>(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => new MenuExample(lifetime)..build(), lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => new MenuButton(lifetime)..build(), lifeTimeScope: LifeTimeScope.SingleInstance);
  }
}

abstract class MenuScreenExampleBase extends UiPanel{
  String title = "Title";
  MenuPage id;
  bool showBack = true;
  bool showClose = false;
  MenuExample _menu;

  MenuScreenExampleBase(ILifetime lifetime) : super(lifetime);
  void attachToMenu(MenuExample menu) => _menu = menu;
}

class MenuButton extends UiButtonIconText{
  MenuButton(ILifetime lifetime) : super(lifetime);

}

class MenuTest extends MenuScreenExampleBase{
  String title = "Main Menu";
  UiText _text;
  MenuTest(ILifetime lifetime):super(lifetime)
  {
    id = MenuPage.TestMenu;
    _text = lifetime.resolve();
  }
  void build(){
    _text.changeText("Ahoi");
    append(_text);
  }
}

class MenuMain extends MenuScreenExampleBase{
  String title = "Main Menu";
  MenuButton _btn_test;
  MenuMain(ILifetime lifetime) : super(lifetime)
  {
    id = MenuPage.MainMenu;
    showBack = false;
    _btn_test = lifetime.resolve();
  }
  void build(){
    _btn_test.changeText("Go to test menu");
    _btn_test.setOnClick(() => _menu.showMenu(MenuPage.TestMenu));
    append(_btn_test);
  }
}

class MenuExample extends UiPanel{
  //menu element
  UiPanel content;
  UiPanel titleContent;
  UiButtonIcon btn_back;
  //txt_title is the element with text==title
  UiTitle txt_title;
  MenuHistory<MenuPage> _history;
  Map<MenuPage, MenuScreenExampleBase> _menus = {};

  MenuExample(ILifetime lifetime) : super(lifetime){
    _history = lifetime.resolve();
    btn_back = lifetime.resolve();
    txt_title = lifetime.resolve();
    content = lifetime.resolve();
    titleContent = lifetime.resolve();
    var menus = lifetime.resolveList<MenuScreenExampleBase>();
    for(var menu in menus){
      _menus[menu.id] = menu;
    }
  }
  void build()
  {
    setStyleId("menu_bg");
    content.setStyleId("menu_wrapper");

    // title
    txt_title.changeText("Menu");
    titleContent.append(txt_title);
    titleContent.append(btn_back);
    titleContent.setStyleId("menu_title");
    _createBackButton();

    content.append(titleContent);
    append(content);
    for(var menu in _menus.values){
      content.append(menu);
      menu.attachToMenu(this);
      menu.hide();
    }
  }
  void showMenu(MenuPage id){
    var current = _history.any() ? _history.current() : null;
    _showMenu(id,current, true);
  }
  void _showMenu(MenuPage id, MenuPage current, bool storeInHistory){
    if(current != null) _menus[current].hide();
    var screen = _menus[id];
    txt_title.changeText(screen.title);
    btn_back.display(screen.showBack && _history.any());
    screen.show();
    if(storeInHistory) _history.goTo(id);
  }
  void _createBackButton()
  {
    btn_back.changeIcon("navigate_before");
    btn_back.setOnClick(()
    {
      var prev = _history.goBack();
      if(_history.any())
        _showMenu(_history.current(),prev, false);
    });
    btn_back.setStyleId("menu_back");
  }
}