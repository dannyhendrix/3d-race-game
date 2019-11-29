part of game;

class Tree extends GameItemStatic {
  Tree(double nx, double ny, [double nr = 0.0]) {
    setPolygon(Polygon.createSquare(nx, ny, GameConstants.treeSize.x, GameConstants.treeSize.y, nr));
    r = nr;
  }
}
