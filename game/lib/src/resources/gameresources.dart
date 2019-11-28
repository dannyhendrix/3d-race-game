part of game.resources;

class GameResourcesInvalidException implements Exception{
  final String msg;
  GameResourcesInvalidException(this.msg);
  String toString() => "Exception: Invalid resource settings: $msg";
}

enum GameResourceType {Level, Texture, Json, Dynamic}

abstract class GameResourcesElement{
  void validate(){
  }
}

class GameResources extends GameResourcesElement{
  GameResourceType type;
  List<GameResourcesSet> sets;
  GameResources([this.type=GameResourceType.Dynamic, this.sets = null]){
    if(sets == null) sets = [];
  }
}
class GameResourcesSet extends GameResourcesElement{
  String name;
  GameResourceType type;
  List<GameResource> resources;
  List<GameResourcesSet> subsets;
  GameResourcesSet([this.name="Set", this.type=GameResourceType.Dynamic, this.subsets = null, this.resources = null]){
    if(resources == null) resources = [];
    if(subsets == null) subsets = [];
  }
}
class GameResource extends GameResourcesElement{
  String name;
  String location;
  GameResourceType type;
  GameResource([this.name="Resource", this.location = "", this.type=GameResourceType.Dynamic]);
}

class GameResourcesLoader extends JsonLoaderBase{
  GameResources loadGameResourcesJson(Map json){
    //var upgrader = new GameLevelUpgrader();
    //json = upgrader.upgrade(json);
    var levelList = _parseResources(json);
    levelList.validate();
    return levelList;
  }
  GameResources _parseResources(dynamic m) => new GameResources(
      parseType(m, "type"),
      parseList(m, "sets",_parseSet));

  GameResourcesSet _parseSet(dynamic m) => new GameResourcesSet(
      parse(m, "name", "Set"),
      parseType(m, "type"),
      parseList(m, "sets", _parseSet),
      parseList(m, "resources", _parseResource));

  GameResource _parseResource(dynamic m) => new GameResource(
      parse(m, "name", "Resource"),
      parse(m, "location", ""),
      parseType(m, "type"));
  GameResourceType parseType(Map json, String name){
    if(!json.containsKey(name)) return GameResourceType.Dynamic;
    switch(json[name]){
      case "texture": return GameResourceType.Texture;
      case "level": return GameResourceType.Level;
      case "dynamic": return GameResourceType.Dynamic;
      case "json": return GameResourceType.Json;
      default: return GameResourceType.Dynamic;
    }
  }
}
class GameResourcesSaver{
  Map levelListToJson(GameResources obj){
    return _parseResources(obj);
  }
  Map _parseResources(GameResources obj){
    Map data = {
      "sets" : obj.sets.map(_parseSet).toList(),
    };
    if(obj.type != GameResourceType.Dynamic) data["type"] = _parseType(obj.type);
    return data;
  }
  Map _parseSet(GameResourcesSet obj){
    Map data = {
      "name" : obj.name,
      "sets" : obj.subsets.map(_parseSet).toList(),
      "resources" : obj.resources.map(_parseResource).toList(),
    };
    if(obj.type != GameResourceType.Dynamic) data["type"] = _parseType(obj.type);
    return data;
  }
  Map _parseResource(GameResource obj){
    Map data = {
      "name" : obj.name,
    };
    if(obj.location.isNotEmpty) data["location"] = obj.location;
    if(obj.type != GameResourceType.Dynamic) data["type"] = _parseType(obj.type);
    return data;
  }
  String _parseType(GameResourceType type){
    switch(type){
      case GameResourceType.Texture: return "texture";
      case GameResourceType.Level: return "level";
      case GameResourceType.Dynamic: return "dynamic";
      case GameResourceType.Json: return "json";
      default: return "dynamic";
    }
  }
}