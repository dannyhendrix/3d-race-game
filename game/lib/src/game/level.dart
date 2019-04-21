part of micromachines;

class GameLevelController{
  List<Polygon> roadPolygons;
  List<CheckpointGameItem> checkpoints;

  GameLevelController(GameLevelPath path){
    var pathToPolygons = new PathToPolygons();
    roadPolygons = pathToPolygons.createRoadPolygons(path);
    checkpoints = [];

    var vectors = new List<Vector>();
    for(var c in path.checkpoints) vectors.add(new Vector(c.x, c.z));

    if(vectors.length == 0) return;

    //first checkpoint
    if(path.circular)
    {
      var checkpoint = new CheckpointGameItem(path.checkpoints[0], _getCheckpointAngle(vectors[0], vectors.last, vectors[1]),0);
      checkpoints.add(checkpoint);

      for(int i = 1; i < path.checkpoints.length-1; i++){
        var checkpoint = new CheckpointGameItem( path.checkpoints[i],_getCheckpointAngle(vectors[0],vectors[i+1],vectors[i-1]),i);
        checkpoints.add(checkpoint);
      }

      checkpoint = new CheckpointGameItem(path.checkpoints.last, _getCheckpointAngle(vectors.last, vectors[vectors.length - 2], vectors[0]),vectors.length-1);
      checkpoints.add(checkpoint);
    }
    else{
      var checkpoint = new CheckpointGameItem(path.checkpoints[0], _getCheckpointAngleToNext(vectors[0], vectors[1]), 0);
      checkpoints.add(checkpoint);

      for(int i = 1; i < path.checkpoints.length-1; i++){
        var checkpoint = new CheckpointGameItem(path.checkpoints[i],_getCheckpointAngle(vectors[0],vectors[i+1],vectors[i-1]),i);
        checkpoints.add(checkpoint);
      }

      checkpoint = new CheckpointGameItem(path.checkpoints.last, _getCheckpointAngleToNext(vectors.last, vectors[0]),vectors.length-1);
      checkpoints.add(checkpoint);
    }
  }

  double _getCheckpointAngleToNext(Vector c,Vector cNext){
    return (cNext-c).angleThis();
  }

  double _getCheckpointAngle(Vector c,Vector cPrev,Vector cNext){
    double angle = ((cPrev-c)+(c-cNext)).angleThis();
    angle += Math.pi/2;
    return angle;
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

  Vector checkPointLocation(int index){
    return checkpoints[index].position;
  }
}