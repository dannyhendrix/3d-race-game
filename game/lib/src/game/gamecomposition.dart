part of game;

class GameComposition implements IDependencyModule{
  @override
  void load(IDependencyBuilder builder) {
    builder.registerType((lifetime) => Game(lifetime), lifeTimeScope: LifeTimeScope.PerLifeTime);
  }
}