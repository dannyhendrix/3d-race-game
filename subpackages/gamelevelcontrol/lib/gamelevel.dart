part of gamelevelcontrol;

class GameLevel {
  GameLevelCategory parent;
  int index;
  String name;
  bool defaultLocked = false;
  bool locked = false;

  void unlock(){
    locked = false;
    parent?.unlock();
  }

  Map getStoredData() {
    Map data = {};
    data["name"] = name;
    data["locked"] = defaultLocked;
    return data;
  }

  void setStoredData(Map data) {
    name = data["name"];
    defaultLocked = data["locked"];
    locked = defaultLocked;
  }

  dynamic getStoredProgress() => locked;
  void setStoredProgress(dynamic input) {
    locked = input;
  }
}

class GameLevelStub extends GameLevel {
  String name;
  bool defaultLocked = false;
  GameLevelStub(this.name, [this.defaultLocked = false]) {
    locked = defaultLocked;
  }
  GameLevelStub.fromData(Map data){
    setStoredData(data);
  }
}
