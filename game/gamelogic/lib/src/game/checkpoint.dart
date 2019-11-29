part of game;
//TODO: support gameobjects with multiple polygons

class CheckpointGatePost extends GameItemStatic {
  CheckpointGatePost(CheckpointGameItem checkpoint, bool leftpost) {
    setPolygon(Polygon.createSquare(0.0, 0.0, 8.0, 8.0, 0.0));
    var offsetx = checkpoint.width / 2;
    if (leftpost) offsetx = -offsetx;
    var offsety = 0.0;
    var m = new Matrix2d().translateThisVector(checkpoint.position).rotateThis(checkpoint.r + (pi / 2)).translateThis(offsetx, offsety);
    applyMatrix(m);
    r = checkpoint.r;
  }
}

class CheckpointGameItem extends GameItemStatic {
  int index;
  double width;
  CheckpointGameItem(GameLevelCheckPoint checkpoint, this.index) {
    setPolygon(Polygon.createSquare(checkpoint.x, checkpoint.y, 20.0, checkpoint.width, checkpoint.angle));
    width = checkpoint.width;
    r = checkpoint.angle;
  }
}
