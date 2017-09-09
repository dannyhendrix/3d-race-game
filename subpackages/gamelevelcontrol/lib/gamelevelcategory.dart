part of gamelevelcontrol;

abstract class GameLevelCategory<L extends GameLevel> {
  String name = "";
  int index;
  GameLevelCategory parent;
  List<GameLevelCategory> _categories = [];
  List<L> _levels = [];
  bool defaultLocked = false;
  bool locked = false;

  void unlock() {
    parent?.unlock();
    locked = false;
  }

  List<GameLevelCategory> getCategories() => _categories;
  GameLevelCategory getCategoryByIndex(int i) => _categories[i];

  void addCategory(GameLevelCategory cat) {
    cat.parent = this;
    cat.index = _categories.length;
    _categories.add(cat);
  }

  void clearCategories() {
    _categories.forEach((GameLevelCategory l){
      l.index = 0;
      l.parent = null;
    });
    _categories.clear();
  }

  List<L> getLevels() => _levels;
  L getLevelByIndex(int i) => _levels[i];

  void addLevel(L level) {
    level.parent = this;
    level.index = _levels.length;
    _levels.add(level);
  }

  void clearLevels() {
    _levels.forEach((GameLevel l){
      l.index = 0;
      l.parent = null;
    });
    _levels.clear();
  }

  Map getStoredData() {
    Map data = {};
    List levs = [];
    List cats = [];
    for (L lev in _levels) levs.add(lev.getStoredData());
    for (GameLevelCategory cat in _categories) cats.add(cat.getStoredData());
    data["name"] = name;
    data["locked"] = defaultLocked;
    if(levs.length > 0) data["levels"] = levs;
    if(cats.length > 0) data["categories"] = cats;
    return data;
  }

  void setStoredData(Map data) {
    name = data["name"];
    defaultLocked = data["locked"];
    locked = defaultLocked;
    _levels = [];
    int levelIndex = 0;
    int catIndex = 0;
    if(data.containsKey("categories"))
      for (Map cat in data["categories"]) {
        GameLevelCategory catObj = createNewCategory();
        catObj.setStoredData(cat);
        catObj.parent = this;
        catObj.index = catIndex++;
        _categories.add(catObj);
      }
    if(data.containsKey("levels"))
      for (Map lev in data["levels"]) {
        L levObj = createNewLevel();
        levObj.setStoredData(lev);
        levObj.parent = this;
        levObj.index = levelIndex++;
        _levels.add(levObj);
      }
  }

  L createNewLevel();
  GameLevelCategory createNewCategory();
}

class GameLevelCategoryStub extends GameLevelCategory<GameLevelStub> {
  bool defaultLocked;
  String name;
  GameLevelCategoryStub(this.name, [this.defaultLocked = false]) {
    locked = defaultLocked;
  }
  GameLevelCategoryStub.fromData(Map data) {
    setStoredData(data);
  }
  createNewLevel() => new GameLevelStub("");
  GameLevelCategory createNewCategory() => new GameLevelCategoryStub("");
}
