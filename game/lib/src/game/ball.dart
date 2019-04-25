part of micromachines;

class Ball extends GameItemMovable{
  Ball(double nx, double ny, double nr):super(Polygon.createSquare(nx,ny, 50.0, 30.0, nr));
}