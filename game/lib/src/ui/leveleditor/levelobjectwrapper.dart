part of game.leveleditor;

class LevelObjectWrapperWalls extends LevelObjectWrapper<LevelObjectWall> {
  LevelObjectWrapperWalls(ILifetime lifetime) : super(lifetime);
}

class LevelObjectWrapperStaticObjects extends LevelObjectWrapper<LevelObjectStaticObject> {
  LevelObjectWrapperStaticObjects(ILifetime lifetime) : super(lifetime);
}

class LevelObjectWrapperCheckpoints extends LevelObjectWrapper<LevelObjectCheckpoint> {
  LevelObjectWrapperCheckpoints(ILifetime lifetime) : super(lifetime);
}

class LevelObjectWrapper<T extends LevelObject> extends UiPanel {
  List<T> levelObjects = [];

  LevelObjectWrapper(ILifetime lifetime) : super(lifetime);
  @override
  void build() {
    super.build();
    addStyle("levelObjectWrapper");
  }

  void clearAll() {
    clear();
    levelObjects = [];
  }

  void addLevelObject(T o) {
    levelObjects.add(o);
    append(o);
  }

  void removeLevelObject(T o) {
    levelObjects.remove(o);
    o.element.remove();
  }
}
