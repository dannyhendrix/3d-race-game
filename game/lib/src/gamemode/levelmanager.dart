part of game.gamemode;

class LevelManager {
  Map<String, GameLevel> _levels = {};
  Random _random = new Random();
  void loadLevel(String key, GameLevel level) {
    _levels[key] = level;
  }

  GameLevel getLevel(String key) => _levels[key];
  GameLevel getRandomLevel() {
    //TODO: controlled randomness: race/soccer, only f1 tracks etc.
    var keys = _levels.keys.toList();
    var randomKey = keys[_random.nextInt(_levels.keys.length)];
    return _levels[randomKey];
  }

  Iterable<String> getLevelKeys() => _levels.keys;
}
