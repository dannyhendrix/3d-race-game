part of game.leveleditor;

class LevelEditorComposition implements IDependencyModule {
  GameSettings _settings;
  LevelEditorComposition(this._settings);
  @override
  void load(IDependencyBuilder builder) {
    builder.registerType((lifetime) => LevelEditor(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerLifeTime);
    builder.registerType((lifetime) => Preview(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => StartingPositionsPreview(), lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => EditorMenuCollection(lifetime), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => LevelObjectWrapperWalls(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => LevelObjectWrapperStaticObjects(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => LevelObjectWrapperCheckpoints(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => LevelObjectWall(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => LevelObjectStaticObject(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => LevelObjectCheckpoint(lifetime)..build(), lifeTimeScope: LifeTimeScope.PerUser);

    builder.registerType((lifetime) => CreateMenu(lifetime)..build(), additionRegistrations: [EditorMenu], lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => ClickAddMenu(lifetime)..build(), additionRegistrations: [EditorMenu], lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => LevelObjectControlsMenu(lifetime)..build(), additionRegistrations: [EditorMenu], lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => LevelObjectPropertiesMenu(lifetime)..build(), additionRegistrations: [EditorMenu], lifeTimeScope: LifeTimeScope.PerUser);
    builder.registerType((lifetime) => JsonMenu(lifetime)..build(), additionRegistrations: [EditorMenu], lifeTimeScope: LifeTimeScope.PerUser);
    if (_settings.debug.v) builder.registerType((lifetime) => SaveMenu(lifetime)..build(), additionRegistrations: [EditorMenu], lifeTimeScope: LifeTimeScope.PerUser);

    //TODO: move to correct composition
    builder.registerType((lifetime) => GameLevelLoader(), lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => GameLevelSaver(), lifeTimeScope: LifeTimeScope.SingleInstance);
  }
}
