import "dart:html";
import "package:dashboard/uihelper.dart";
import "package:dashboard/menu.dart";
import "package:dependencyinjection/dependencyinjection.dart";

enum MenuPage {MainMenu, TestMenu, MainMenu2}

void main(){
  var lifetime = DependencyBuilderFactory().createNew((builder){
    builder.registerModule(UiMenuComposition());
    builder.registerModule(UiComposition());
  });
  var menu = lifetime.resolve<MenuExample>();
  menu.showMenu(MenuPage.MainMenu2);
  document.body.append(menu.element);
}
class UiMenuComposition implements IDependencyModule{
  @override
  void load(IDependencyBuilder builder) {
    builder.registerType((lifetime) => new MenuMain(lifetime)..build(), additionRegistrations: [MenuScreenExampleBase], lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => new MenuMain2(lifetime)..build(), additionRegistrations: [MenuScreenExampleBase], lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => new MenuTest(lifetime)..build(), additionRegistrations: [MenuScreenExampleBase], lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => new MenuHistory<MenuPage>(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => new MenuExample(lifetime)..build(), lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => new MenuButton(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
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
    //_btn_test.setOnClick(() => _menu.showMenu(MenuPage.MainMenu2));
    append(_btn_test);
  }
}
class MenuMain2 extends MenuScreenExampleBase{
  String title = "Main Menu2";
  MenuButton _btn_test;
  UiPanel _wrapper;
  UiPanel _main;
  UiPanel _side;
  UiText _textSide;
  UiText _textMain;
  MenuMain2(ILifetime lifetime) : super(lifetime)
  {
    id = MenuPage.MainMenu2;
    showBack = false;
    _btn_test = lifetime.resolve();
    _wrapper = lifetime.resolve();
    _main = lifetime.resolve();
    _side = lifetime.resolve();
    _textSide = lifetime.resolve();
    _textMain = lifetime.resolve();
  }
  void build(){
    _btn_test.changeText("Hide side menu");
    _btn_test.setOnClick(() => _menu.showMenu(MenuPage.TestMenu));
    _textSide..changeText("Side panel")..addStyle("sidemenu");
    _textSide..changeText("Main panel")..addStyle("mainpanel");
    _textSide..changeText("Main panel")..addStyle("mainpanel");

    _wrapper.append(_side);
    _wrapper.append(_main);
    _side.append(_textSide);
    _side.append(_textMain);
    append(_btn_test);
    append(_wrapper);

  }
}

class MenuExample extends UiPanel{
  //menu element
  UiPanel content;
  UiSwitchPanel tabs;
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
    tabs = lifetime.resolve();
    titleContent = lifetime.resolve();
    var menus = lifetime.resolveList<MenuScreenExampleBase>();
    for(var menu in menus){
      _menus[menu.id] = menu;
      menu.attachToMenu(this);
      print("Loaded ${menu.id}");
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
    content.append(tabs);
    append(content);
    for(var menu in _menus.values){
      tabs.setTab(menu.id.index, menu);
    }
  }
  void showMenu(MenuPage id){
    var current = _history.any() ? _history.current() : null;
    _showMenu(id,current, true);
  }
  void _showMenu(MenuPage id, MenuPage current, bool storeInHistory){
    var screen = _menus[id];
    txt_title.changeText(screen.title);
    btn_back.display(screen.showBack && _history.any());
    tabs.showTab(id.index);
    if(storeInHistory) _history.goTo(id);
  }
  void _createBackButton()
  {
    btn_back.changeIcon("navigate_before");
    btn_back.setOnClick((){
      var prev = _history.goBack();
      if(_history.any())
        _showMenu(_history.current(),prev, false);
    });
    btn_back.setStyleId("menu_back");
  }
}