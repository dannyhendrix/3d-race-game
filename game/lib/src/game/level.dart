part of game;

class GameLevelController{
  List<Polygon> roadPolygons;
  List<CheckpointGameItem> checkpoints;
  List<PathPoint> _path;

  GameLevelController(GameLevelPath path){
    var pathToTrack = new PathToTrack();
    var trackToPolygons = new TrackToPolygons();
    _path = pathToTrack.createTrack(path);
    roadPolygons = trackToPolygons.createRoadPolygons(_path, path.circular);
    checkpoints = [];

    var vectors = new List<Vector>();
    for(var c in path.checkpoints) vectors.add(new Vector(c.x, c.y));

    if(vectors.length == 0) return;

    for(int i = 0; i < path.checkpoints.length; i++){
      checkpoints.add(new CheckpointGameItem( path.checkpoints[i],i));
    }
  }

  bool onRoad(Vector p){
    for(int i = 0; i< roadPolygons.length; i++){
      if(_inTriangle(p,roadPolygons[i])){
        return true;
      }
    }
    return false;
  }

  bool _inTriangle(Vector P, Polygon p){
    var A = p.points[0];
    var B = p.points[1];
    var C = p.points[2];
    var Area = 0.5 *(-B.y*C.x + A.y*(-B.x + C.x) + A.x*(B.y - C.y) + B.x*C.y);
    var s = 1/(2*Area)*(A.y*C.x - A.x*C.y + (C.y - A.y)*P.x + (A.x - C.x)*P.y);
    var t = 1/(2*Area)*(A.x*B.y - A.y*B.x + (A.y - B.y)*P.x + (B.x - A.x)*P.y);
    return s > 0 && t > 0 && 1-s-t > 0;
  }

  PathPoint trackPoint(int index){
    return _path[index];
  }
  int trackLength() => _path.length;
}