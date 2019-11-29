part of game;

class Ball extends GameItemMovable {
  Ball(double nx, double ny, double nr) {
    setPolygon(Polygon.createSquare(nx, ny, GameConstants.ballSize.x, GameConstants.ballSize.y, nr));
  }
}
