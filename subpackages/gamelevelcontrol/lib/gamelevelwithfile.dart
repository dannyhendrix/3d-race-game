part of gamelevelcontrol;

class GameLevelControllerWithFile extends GameLevelController<GameLevelCategoryWithFile, GameLevelWithFile> {

  GameLevelControllerWithFile(GameLevelCategoryWithFile category):super(category){
  }
  GameLevelControllerWithFile.fromData(GameLevelCategoryWithFile category,Map data):super(category) {
    setStoredData(data);
  }
}
class GameLevelCategoryWithFile extends GameLevelCategory<GameLevelWithFile> {
  bool defaultLocked = false;
  String name;
  GameLevelCategoryWithFile(this.name, [this.defaultLocked = false]) {
    locked = defaultLocked;
  }
  GameLevelCategoryWithFile.fromData(Map data) {
    setStoredData(data);
  }
  GameLevelWithFile createNewLevel() => new GameLevelWithFile("","");
  GameLevelCategoryWithFile createNewCategory() => new GameLevelCategoryWithFile("");
}
class GameLevelWithFile extends GameLevel {
  String name;
  String location;
  bool defaultLocked = false;
  GameLevelWithFile(this.name, this.location, [this.defaultLocked = false]) {
    locked = defaultLocked;
  }
  GameLevelWithFile.fromData(Map data){
    setStoredData(data);
  }
  Map getStoredData() {
    Map data = super.getStoredData();
    data["location"] = location;
    return data;
  }

  void setStoredData(Map data) {
    super.setStoredData(data);
    location = data["location"];
  }
}