part of game.resources;

class ResourceManager{
  LevelPool _levels = LevelPool();
  TexturePool _textures = TexturePool();

  ImageElement getTexture(String key){
    return _textures.select(key);
  }
  GameLevel getLevel(String key){
    return _levels.select(key);
  }
  Iterable<String> getLevelKeys() => _levels.getKeys();
  void loadResources(List<String> sources, Function onComplete){
    _reset();
    var loader = new PreLoader(()=> _onResourcesInfoLoaded(sources,onComplete));
    for(var r in sources){
      loader.loadJson(r,r);
    }
    loader.start();
  }
  void _reset(){
    _levels.clear();
    _textures.clear();
  }
  void _onResourcesInfoLoaded(List<String> sources, Function onComplete){
    var loader = new PreLoader(onComplete);

    for(var r in sources){
      var resourcesInfo = GameResourcesLoader().loadGameResourcesJson(JsonController.getJson(r));
      for(var set in resourcesInfo.sets) _addSetToLoader(loader, set,"",set.type != GameResourceType.Dynamic ? set.type : resourcesInfo.type);
    }
    loader.start();
  }

  void _addSetToLoader(PreLoader loader, GameResourcesSet set, String identifier, GameResourceType rootType){
    identifier += "${set.name}/";
    rootType = set.type != GameResourceType.Dynamic ? set.type : rootType;
    for(var s in set.subsets) _addSetToLoader(loader, s, identifier, rootType);
    for(var r in set.resources){
      var resIdentifier = "${identifier}${r.name}";
      var type = r.type != GameResourceType.Dynamic ? r.type : rootType;
      switch(type){
        case GameResourceType.Level:
          var location = r.location == "" ? "${resIdentifier}.json" : r.location;
          loader.loadJson(location, resIdentifier);
          _levels.addKey(resIdentifier);
          break;
        case GameResourceType.Texture:
          var location = r.location == "" ? "${resIdentifier}.png" : r.location;
          loader.loadImage(location,resIdentifier);
          _textures.addKey(resIdentifier);
          break;
        case GameResourceType.Json:
          var location = r.location == "" ? "${resIdentifier}.json" : r.location;
          loader.loadJson(location,resIdentifier);
          break;
        case GameResourceType.Dynamic:
        // TODO: Handle this case.
          break;
      }
    }
  }
}

abstract class ResourcePool<T>{
  Map<String, T> _pool = {};
  T select(String key){
    if(_pool[key] == null){
      var newItem = _createIfNotPresent(key);
      _pool[key] = newItem;
      return newItem;
    }
    return _pool[key];
  }
  void clear() => _pool.clear();
  void addKey(String key)=>  _pool[key] = null;
  Iterable<String> getKeys() => _pool.keys;
  T _createIfNotPresent(String key);
}
class TexturePool extends ResourcePool<ImageElement>{
  ImageElement _createIfNotPresent(String key) {
    return ImageController.getImage(key);
  }
}
class LevelPool extends ResourcePool<GameLevel>{
  GameLevelLoader _levelLoader = new GameLevelLoader();
  GameLevel _createIfNotPresent(String key) {
    return _levelLoader.loadLevelJson(JsonController.getJson(key));
  }
}