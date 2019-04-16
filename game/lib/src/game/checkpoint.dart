part of micromachines;
//TODO: support gameobjects with multiple polygons
class CheckPoint extends GameItemStatic{
  Game game;
  double wallW = 8.0;
  double wallH = 8.0;
  bool isGate;

  CheckPoint(this.game,PathCheckPoint pathCheckpoint, double angle, [this.isGate = false]) : super(Polygon.createSquare(pathCheckpoint.x,pathCheckpoint.y, 8.0, 8.0, angle)){

  }
/*
  CheckPoint(this.game, PathCheckPoint pathCheckpoint, double angle, [this.isGate = false]){
    position = new Point2d(pathCheckpoint.x,pathCheckpoint.y);
    w = wallW+pathCheckpoint.radius*2;
    h = wallH;
    //TODO: calculate angle from prev and next point
    r = angle;

    if(isGate)
    {
      double wallWh = wallW / 2;
      double wallHh = wallH / 2;
      Polygon wall = new Polygon([
        new Point2d(-wallWh, -wallHh),
        new Point2d(wallWh, -wallHh),
        new Point2d(wallWh, wallHh),
        new Point2d(-wallWh, wallHh),
      ]);
      relativeCollisionFields = [
        wall.applyMatrix(new Matrix2d.translation(-pathCheckpoint.radius, 0.0)),
        wall.applyMatrix(new Matrix2d.translation(pathCheckpoint.radius, 0.0)),
      ];
    }
    setAbsoluteCollisionFieldsCache();
  }*/
}