part of game.gamemode;

class GameModeComposition implements IDependencyModule{
  @override
  void load(IDependencyBuilder builder) {
    builder.registerType((lifetime) => new GameBuilder(lifetime), lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => new LevelManager(), lifeTimeScope: LifeTimeScope.SingleInstance);
    builder.registerType((lifetime) => new AiPlayerProfileDatabase(), lifeTimeScope: LifeTimeScope.SingleInstance);
  }
}