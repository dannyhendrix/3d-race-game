part of game.definitions;

class GameLevelListInvalidException implements Exception{
  final String msg;
  GameLevelListInvalidException(this.msg);
  String toString() => "Exception: Invalid game list settings: $msg";
}

abstract class GameLevelListElement{
  void validate(){
  }
}

class GameLevelList extends GameLevelListElement{
  List<GameLevelListSet> sets;
  GameLevelList([this.sets = null]){
    if(sets == null) sets = [];
  }
}
class GameLevelListSet extends GameLevelListElement{
  String name;
  List<GameLevelListLevel> levels;
  GameLevelListSet([this.name="Set",this.levels = null]){
    if(levels == null) levels = [];
  }
}
class GameLevelListLevel extends GameLevelListElement{
  String name;
  GameLevelListLevel([this.name="Level"]);
}

class GameLevelListLoader extends JsonLoaderBase{
  GameLevelList loadLevelListJson(Map json){
    //var upgrader = new GameLevelUpgrader();
    //json = upgrader.upgrade(json);
    var levelList = _parseLevelList(json);
    levelList.validate();
    return levelList;
  }
  GameLevelList _parseLevelList(dynamic m) => new GameLevelList(
      _parseList(m, "sets",_parseSet));
  GameLevelListSet _parseSet(dynamic m) => new GameLevelListSet(
      _parse(m, "name", "Set"),
      _parseList(m, "levels", _parseLevel));
  GameLevelListLevel _parseLevel(dynamic m) => new GameLevelListLevel(
      _parse(m, "name", "Level"));
}
class GameLevelListSaver{
  Map levelListToJson(GameLevelList level){
    return _parseLevelList(level);
  }
  Map _parseLevelList(GameLevelList levelList){
    return {
      "sets" : levelList.sets.map(_parseSet).toList(),
    };
  }
  Map _parseSet(GameLevelListSet set){
    return {
      "name" : set.name,
      "levels" : set.levels.map(_parseLevel).toList(),
    };
  }
  Map _parseLevel(GameLevelListLevel level){
    return {
      "name" : level.name,
    };
  }
}