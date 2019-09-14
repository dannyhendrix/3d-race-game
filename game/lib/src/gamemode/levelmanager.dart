part of game.gamemode;


class LevelManager{
  GameLevelLoader _levelLoader = new GameLevelLoader();
  Map<int, GameLevel> loadedLevels = {};

  void preLoadLevels(Function onComplete){
    var loader = new PreLoader(()=>_onLevelsListLoaded(onComplete));
    loader.loadJson("levels/levels.json","levels");
    //TODO: refactor
    loader.loadImage("textures/texture_car.png","texture_vehicle");
    loader.loadImage("textures/texture_tree.png","texture_tree");
    loader.loadImage("textures/texture_road.png","texture_road");
    loader.loadImage("textures/texture_wall.png","texture_wall");
    loader.start();
  }
  void _onLevelsListLoaded(Function onComplete){
    print("Levels loaded");
    var levellistJson = JsonController.getJson("levels");
    var levelsList = new GameLevelListLoader().loadLevelListJson(levellistJson);
    var levelloader = new PreLoader(() => _onLevelsLoaded(onComplete, levelsList));
    for(var set in levelsList.sets){
      print("Set ${set.name}");
      for(var level in set.levels){
        levelloader.loadJson("levels/${set.name.toLowerCase()}/${level.name.toLowerCase()}.json","level/${set.name}/${level.name}");
        print("Load level level/${set.name}/${level.name}");
      }
    }
    levelloader.start();
  }
  void _onLevelsLoaded(Function onComplete, GameLevelList levelsList){
    int i = 0;
    for(var set in levelsList.sets){
      for(var level in set.levels){
        loadedLevels[i] = _levelLoader.loadLevelJson(JsonController.getJson("level/${set.name}/${level.name}"));
        i++;
        print("Load level level/${set.name}/${level.name}");
      }
    }
    onComplete();
  }
  void loadLevelFromFile(String file, Function onComplete){
    var loader = new PreLoader(()=>_onLevelLoaded(onComplete, file));
    loader.loadJson(file,"level/$file");
    loader.start();
  }

  void _onLevelLoaded(Function onComplete, String file){
    onComplete(_levelLoader.loadLevelJson(JsonController.getJson("level/$file")));
  }

  GameLevel loadLevel(int id){
   if(loadedLevels.containsKey(id) == false) throw new Exception("Cannot load level $id. Level is not loaded!");
    return loadedLevels[id];
  }
}