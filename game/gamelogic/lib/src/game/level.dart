part of game;

class GameLevelContainer {
  List<Polygon> roadPolygons;
  List<CheckpointGameItem> checkpoints;
  List<PathPoint> _path;

  PathPoint trackPoint(int index) => _path[index];
  int trackLength() => _path.length;
  GameLevelContainer(this._path, this.roadPolygons, this.checkpoints);
}

class GameLevelController {
  PathToTrack _pathToTrack = new PathToTrack();
  TrackToPolygons _trackToPolygons = new TrackToPolygons();

  GameLevelContainer createLevel(GameLevelPath levelpath) {
    var path = _pathToTrack.createTrack(levelpath);
    var roadPolygons = _trackToPolygons.createRoadPolygons(path, levelpath.circular);
    var checkpoints = new List<CheckpointGameItem>();
    for (int i = 0; i < levelpath.checkpoints.length; i++) {
      checkpoints.add(new CheckpointGameItem(levelpath.checkpoints[i], i));
    }
    return new GameLevelContainer(path, roadPolygons, checkpoints);
  }

  bool onRoad(GameLevelContainer level, Vector p) {
    for (int i = 0; i < level.roadPolygons.length; i++) {
      if (_inTriangle(p, level.roadPolygons[i])) {
        return true;
      }
    }
    return false;
  }

  void loadLevel(GameLevel level, GameState state) {
    state.gamelevelType = level.gameLevelType;
    for (var obj in level.walls) {
      var wall = new Wall(obj.x, obj.y, obj.w, obj.h, obj.r);
      state.walls.add(wall);
    }
    for (var obj in level.staticobjects) {
      var tree = new Tree(obj.x, obj.y, obj.r);
      state.trees.add(tree);
    }

    for (var obj in level.score.balls) {
      var ball = new Ball(obj.x, obj.y, obj.r);
      state.balls.add(ball);
    }

    if (level.gameLevelType == GameLevelType.Checkpoint) {
      for (var c in state.level.checkpoints) {
        state.checkpoints.add(c);
        var leftpost = new CheckpointGatePost(c, true);
        var rightpost = new CheckpointGatePost(c, false);
        state.checkpointPosts.add(leftpost);
        state.checkpointPosts.add(rightpost);
      }
    }
  }

  bool _inTriangle(Vector P, Polygon p) {
    var A = p.points[0];
    var B = p.points[1];
    var C = p.points[2];
    var Area = 0.5 * (-B.y * C.x + A.y * (-B.x + C.x) + A.x * (B.y - C.y) + B.x * C.y);
    var s = 1 / (2 * Area) * (A.y * C.x - A.x * C.y + (C.y - A.y) * P.x + (A.x - C.x) * P.y);
    var t = 1 / (2 * Area) * (A.x * B.y - A.y * B.x + (A.y - B.y) * P.x + (B.x - A.x) * P.y);
    return s > 0 && t > 0 && 1 - s - t > 0;
  }
}
