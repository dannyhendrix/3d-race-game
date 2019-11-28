part of game.menu;

class SettingsMenu extends GameMenuMainScreen
{
  GameSettings _settings;

  SettingsMenu(ILifetime lifetime) : super(lifetime, GameMainMenuPage.Settings){
    _settings = lifetime.resolve();
  }
}

