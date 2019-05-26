part of game.definitions;

class GameLevelExtensions{
  double getCheckpointAngleToNext(Vector c,Vector cNext){
    return (cNext-c).angleThis();
  }

  double getCheckpointAngle(Vector c,Vector cPrev,Vector cNext){
    double angle = ((cPrev-c)+(c-cNext)).angleThis();
    angle += Math.pi/2;
    return angle;
  }

  double getCheckpointAngleCheckpoint(GameLevelCheckPoint c,GameLevelCheckPoint cPrev,GameLevelCheckPoint cNext){
    double angle = new Vector(cPrev.x-cNext.x,cPrev.z-cNext.z).angleThis();
    angle -= Math.pi/2;
    return angle;
  }
  double getCheckpointAngleToNextCheckpoint(GameLevelCheckPoint c,GameLevelCheckPoint cNext){
    return new Vector(cNext.x-c.x,cNext.z-c.z).angleThis();
  }

  List<double> getCheckpointAngles(GameLevelPath path){
    var numberOfCheckpoints = path.checkpoints.length;
    if(numberOfCheckpoints == 0) return <double>[];
    if(numberOfCheckpoints == 1) return <double>[0.0];

    var result = <double>[];
    if(path.circular && numberOfCheckpoints > 2){
      result.add(getCheckpointAngleCheckpoint(path.checkpoints[0], path.checkpoints[numberOfCheckpoints-1], path.checkpoints[1]));
    }else{
      result.add(getCheckpointAngleToNextCheckpoint(path.checkpoints[0], path.checkpoints[1]));
    }
    for(int i = 1; i < numberOfCheckpoints-1; i++){
      result.add(getCheckpointAngleCheckpoint(path.checkpoints[i], path.checkpoints[i-1], path.checkpoints[i+1]));
    }
    if(path.circular && numberOfCheckpoints > 2){
      result.add(getCheckpointAngleCheckpoint(path.checkpoints[numberOfCheckpoints-1], path.checkpoints[numberOfCheckpoints-2], path.checkpoints[0]));
    }else{
      result.add(getCheckpointAngleToNextCheckpoint(path.checkpoints[numberOfCheckpoints-1], path.checkpoints[numberOfCheckpoints-2]));
    }
    return result;
  }
}