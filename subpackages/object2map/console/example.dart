library teamx.levels;
import "package:object2map/object2map.dart";

class Point{
  int x = 0;
  int y = 0;
  int _p = 5;

  String toString() => "($x,$y)";
}

class A{
  int x = 0;
  Point p = new Point();
  String str = "";
  List<int> l = [1];
  Map<String,Point> scores = {"a":new Point()};
  A();

  void loadSelf(Map data)
  {
    ObjectFromMap.convertIn(data, this);
  }
}

void main(){
  Map map = {"__obj":"teamx.levels.A","x":4,"str":"Danny","p":{"__obj":"teamx.levels.Point","x":6,"y":12,"_p":6},"l":[2,3],"scores":{"Danny":{"__obj":"teamx.levels.Point","x":6,"y":12},"Herman":{"__obj":"teamx.levels.Point","x":6,"y":12}}};
  A a = new A();//ObjectFromMap.convert(map, A);
  a.loadSelf(map);
  print(a.str);
  print(a.x);
  print(a.p.x);
  print(a.p.y);
  print(a.l);
  print(a.scores);
  print(a.p._p);
  A a2 = new A();
  Map x2c = ObjectToMap.convert(a2);
  print(x2c);
}