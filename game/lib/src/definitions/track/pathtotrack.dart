part of game.definitions;

class PathToTrack{

  List<PathPoint> createTrack(GameLevelPath path)
  {
    if(path.checkpoints.length <= 1) return [];

    var roads = _createRoadsFromCheckpoints(path.checkpoints);
    roads = _cutCollidingRoads(roads, path.circular);
    _fixAngles(roads, path.circular);

    return roads;
  }

  // for each checkpoint, add a vector before and after the checkpoint to create a road in the given angle
  List<PathPoint> _createRoadsFromCheckpoints(List<GameLevelCheckPoint> checkpoints){
    List<PathPoint> data = [];
    for(var checkpoint in checkpoints){
      var angle = checkpoint.angle;
      var actual = new Vector(checkpoint.x, checkpoint.y);
      var newPointBefore = actual.clone().addVectorToThis(new Vector.fromAngleRadians(angle+Math.pi, checkpoint.lengthBefore));
      var newPointAfter = actual.clone().addVectorToThis(new Vector.fromAngleRadians(angle, checkpoint.lengthAfter));

      data.add(new PathPoint(newPointBefore, angle, checkpoint.width));
      data.add(new PathPoint(actual, angle, checkpoint.width));
      data.add(new PathPoint(newPointAfter, angle, checkpoint.width));
    }
    return data;
  }
  // if 2 roads from 2 checkpoints intersect, cut them and use the intersection point instead
  List<PathPoint> _cutCollidingRoads(List<PathPoint> path, bool circular){
    List<PathPoint> data= [];
    for(int i = 1; i < path.length-2; i+=3){
      _cutCollidingRoad(path[i], path[i+1], path[i+2], path[i+3], data);
    }
    if(circular)
      _cutCollidingRoad(path[path.length-2], path[path.length-1], path[0], path[1], data);
    return data;
  }
  void _cutCollidingRoad(PathPoint pa, PathPoint pb, PathPoint pc, PathPoint pd, List<PathPoint> output){
    var a = pa.vector;
    var b = pb.vector;
    var c = pc.vector;
    var d = pd.vector;
    Vector intersect = Vector.intersection(a, b,c,d);
    var lengthAB = a.distanceToThis(b);
    var lengthCD = c.distanceToThis(d);
    var lengthAE = a.distanceToThis(intersect);
    var lengthDE = d.distanceToThis(intersect);

    if(lengthAE < lengthAB || lengthDE < lengthCD){
      output.add(new PathPoint(intersect,(pb.angle+pc.angle)/2,(pb.width+pc.width)/2));
    }else{
      output.add(pb);
      output.add(pc);
    }
  }
  void _fixAngles(List<PathPoint> path, bool circular){
    for(int i = 1; i < path.length-1; i++){
      path[i].angle = (path[i-1].vector.angleWithThis(path[i+1].vector)) - Math.pi/2;
    }
    if(circular){
      path[0].angle = (path[path.length-1].vector.angleWithThis(path[1].vector)) - Math.pi/2;
      path[path.length-1].angle = (path[path.length-2].vector.angleWithThis(path[0].vector)) - Math.pi/2;
    }else{
      path[0].angle = (path[0].vector.angleWithThis(path[1].vector)) - Math.pi/2;
      path[path.length-1].angle = (path[path.length-1].vector.angleWithThis(path[0].vector)) - Math.pi/2;
    }
  }
}