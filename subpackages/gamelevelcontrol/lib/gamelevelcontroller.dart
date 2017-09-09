part of gamelevelcontrol;

abstract class GameLevelController<LC extends GameLevelCategory<L>, L extends GameLevel> {
  LC _mainCategory;
  L _currentLevel;
  UnlockKeyGenerator _keyGen;

  GameLevelController.withKeyGen(this._mainCategory,this._keyGen);
  GameLevelController(this._mainCategory){
    _keyGen = new UnlockKeyGenerator();
  }
  LC getMainCategory() => _mainCategory;
  L getCurrentLevel() => _currentLevel;
  void setCurrentLevel(L l){
    _currentLevel = l;
  }

  LC getCurrentCategory() => _currentLevel.parent;

  L getFirstLevel() => _getFirstLevel(_mainCategory);
  L _getFirstLevel(LC cat, [int catStartIndex = 0]){
    if(cat.getLevels().length > 0)
      return cat.getLevels().first;
    for(LC c in cat.getCategories())
    {
      if(catStartIndex > 0)
      {
        catStartIndex--;
        continue;
      }
      var lev = _getFirstLevel(c);
      if (lev != null) return lev;
    }
    return null;
  }

  L getNextLevel(L currentLevel, [bool canBeLocked = false])
  {
    LC  cat = currentLevel.parent;
    if (cat == null) return null;
    int nextLevelIndex = currentLevel.index + 1;

    if(nextLevelIndex < cat.getLevels().length)
    {
      return cat.getLevelByIndex(nextLevelIndex);
    }

    while(cat.parent != null){
      var next = _getFirstLevel(cat.parent,cat.index+1);
      if(next != null) return next;
      cat = cat.parent;
    }
    return null;
  }
  bool goToFirstLevel(){
    L l = getFirstLevel();
    if(l == null) return false;
    _currentLevel = l;
    return true;
  }
  bool goToNextLevel([bool unlock = false]){
    L nextLevel = getNextLevel(_currentLevel, true);
    if(nextLevel == null) return false;
    if(!unlock && nextLevel.locked) return false;
    if(unlock && nextLevel.locked) nextLevel.unlock();
    _currentLevel = nextLevel;
    return true;
  }
  bool unlockNextLevel(){
    L nextLevel = getNextLevel(_currentLevel, true);
    if(nextLevel == null) return false;
    if(nextLevel.locked) nextLevel.unlock();
    return true;
  }
  bool hasNextLevel() => null != getNextLevel(_currentLevel, true);

  Map getStoredData() => _mainCategory.getStoredData();

  void setStoredData(Map data) {
    _mainCategory.setStoredData(data);
  }

  List<String> _getProgressKeysFromCategory(GameLevelCategory cat){
    List<String> keys = new List<String>();
    int unlocked = 0;
    int totalLevels = cat.getLevels().length;
    List<String> catKeys = new List<String>();
    for(L lev in cat.getLevels()){
      if(!lev.locked){
        catKeys.add(_keyGen.generate(cat.name,lev.name));
        unlocked++;
      }
    }
    if(unlocked == totalLevels){
      keys.add(_keyGen.generate(cat.name,"-2"));
    }else{
      keys.addAll(catKeys);
      if(!cat.locked) keys.add(_keyGen.generate(cat.name,"-1"));
    }
    for (LC c in cat.getCategories()){
      keys.addAll(_getProgressKeysFromCategory(c));
    }
    return keys;
  }

  Map getStoredProgress(){
    Map data = new Map();
    data["currentCat"] = _currentLevel.parent != null ? _currentLevel.parent.name : "";
    data["currentLev"] = _currentLevel.name;
    data["progress"] = _getProgressKeysFromCategory(_mainCategory);
    return data;
  }

  void _setProgressKeysFromCategory(GameLevelCategory cat,List<String> keys, String currentCat, String currentLev){
    if(keys.isEmpty && currentCat == "" && currentLev == "") return;
    bool catAllUnlocked = keys.contains(_keyGen.generate(cat.name,"-2"));
    cat.locked = !(catAllUnlocked || keys.contains(_keyGen.generate(cat.name,"-1")));

    for(L lev in cat.getLevels()){
      if(catAllUnlocked || keys.contains(_keyGen.generate(cat.name,lev.name))){
        lev.locked = false;
        if(cat.name == currentCat && lev.name == currentLev){
          _currentLevel = lev;
          if(keys.isEmpty) return;
        }
      }
    }

    for(GameLevelCategory c in cat.getCategories()){
      _setProgressKeysFromCategory(c,keys,currentCat,currentLev);
    }

    if(_currentLevel == null)
      _currentLevel = getFirstLevel();
  }

  void setStoredProgress(Map data) {
      _setProgressKeysFromCategory(_mainCategory,
          data.containsKey("progress") ? data["progress"] : [],
          data.containsKey("currentCat") ? data["currentCat"] : "",
          data.containsKey("currentLev") ? data["currentLev"] : "");
      if(_currentLevel == null)
        goToFirstLevel();
  }
}

class GameLevelControllerStub extends GameLevelController<GameLevelCategoryStub, GameLevelStub> {
  GameLevelControllerStub():super(new GameLevelCategoryStub(""));
  GameLevelControllerStub.fromData(Map data):super(new GameLevelCategoryStub("")) {
    setStoredData(data);
  }
  GameLevelCategoryStub createNewCategory() => new GameLevelCategoryStub("");
}
