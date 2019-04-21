part of micromachines;

class Ball extends GameItemMovable{
  Ball(double nx, double ny, double nr):super(Polygon.createSquare(nx,ny, 20.0, 20.0, nr));
}