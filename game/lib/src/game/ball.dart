part of micromachines;

class Ball extends GameItemMovable{
  Ball(double nx, double ny, double nr):super(Polygon.createSquare(nx,ny,GameConstants.ballSize.x,GameConstants.ballSize.y, nr));
}