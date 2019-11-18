part of game.menu;

class GameMenuComposition implements IDependencyModule{
  @override
  void load(IDependencyBuilder builder) {
    builder.registerType((lifetime) => new MainMenu(lifetime)..build(), additionRegistrations: [GameMenuScreen], lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => new ProfileMenu(lifetime)..build(), additionRegistrations: [GameMenuMainScreen], lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => new SettingsMenuDebug(lifetime)..build(), additionRegistrations: [GameMenuMainScreen], lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => new SettingsMenu(lifetime)..build(), additionRegistrations: [GameMenuMainScreen], lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => new SingleRaceMenu(lifetime)..build(), additionRegistrations: [GameMenuScreen], lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => new SoccerGameMenu(lifetime)..build(), additionRegistrations: [GameMenuScreen], lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => new PlayGameMenu(lifetime)..build(), additionRegistrations: [GameMenuScreen], lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => new GameResultMenu(lifetime)..build(), additionRegistrations: [GameMenuScreen], lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => new CreditsMenu(lifetime)..build(), additionRegistrations: [GameMenuMainScreen], lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => new ControlsMenu(lifetime)..build(), additionRegistrations: [GameMenuMainScreen], lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => new MenuHistory<GameMenuStatus>(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => new MenuButton(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => new GameMenuController(lifetime)..build(), lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => new ResourceManager(), lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => new GameLoader(lifetime), lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => new ColorSelection(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => new GameInputSelectionVehicle(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => new GameInputSelectionTrailer(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => new GameInputSelectionLevel(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => new CustomLevelInput(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => new EnterKey(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);

    //TODO: move to correct composition
    builder.registerType((lifetime) => new TextureGenerator(lifetime.resolve()), lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => new GameLevelLoader(), lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => new WebglGame2d(lifetime), lifeTimeScope: LifeTimeScope.PerLifeTime);
    builder.registerType((lifetime) => new WebglGame3d(lifetime), lifeTimeScope: LifeTimeScope.PerLifeTime);
  }
}