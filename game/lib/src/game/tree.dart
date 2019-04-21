part of micromachines;

class Tree extends GameItemStatic{
  Tree(double nx, double ny, [double nr = 0.0]) : super(Polygon.createSquare(nx,ny,20.0,20.0, nr))
  {
    r=nr;
  }
}