part of micromachines;
//TODO: support gameobjects with multiple polygons

class CheckpointGatePost extends GameItemStatic{
  CheckpointGatePost(CheckpointGameItem checkpoint, bool leftpost) : super(Polygon.createSquare(0.0,0.0,8.0,8.0, 0.0)){
    var offsetx = checkpoint.width;
    if(leftpost) offsetx = -offsetx;
    var offsety = 0.0;
    var m = new Matrix2d()
        .translateThisVector(checkpoint.position)
        .rotateThis(checkpoint.r+(Math.pi/2))
        .translateThis(offsetx, offsety);
    applyMatrix(m);
    r = checkpoint.r+(Math.pi/2);
  }
}

class CheckpointGameItem extends GameItemStatic{
  int index;
  double width;
  CheckpointGameItem(GameLevelCheckPoint checkpoint, this.index) : super(Polygon.createSquare(checkpoint.x,checkpoint.y,checkpoint.width,20.0, checkpoint.angle))
  {
    width = checkpoint.width;
  }
}