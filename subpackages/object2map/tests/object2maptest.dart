library object2map.test;
import "package:object2map/object2map.dart";
import "package:test/test.dart";

class Point
{
  int x = 0;
  int y = 0;
  String str = "Test";

  bool operator ==(Point p2){
    return x == p2.x && y == p2.y && str == p2.str;
  }

  void isEqual(Point p2)
  {
    expect(x, equals(p2.x));
    expect(y, equals(p2.y));
    expect(str, equals(p2.str));
  }
}
class A
{
  Point p = new Point();
  List<int> l = [1];
  List<Point> lp = [new Point()];
  Map<String, int> m = {"asdf":3, "jkl;":5};
  Map<String, Point> mp = {"asdf":new Point(), "jkl;":new Point()};

  void isEqual(A other)
  {
    expect(p, equals(other.p));
    expect(l, equals(other.l));
    expect(lp, equals(other.lp));
    expect(m, equals(other.m));
    expect(mp, equals(other.mp));
  }
}

void main()
{
  test("Object2Map point", (){
    Point p1 = new Point();
    p1.x = 12;
    p1.y = 1337;
    p1.str = "Danny ftw";
    Map m = ObjectToMap.convert(p1);
    Point p2 = ObjectFromMap.convert(m, Point);
    p1.isEqual(p2);
  });
  test("Object2Map A", (){
    A a1 = new A();
    a1.l = [3,4];
    a1.mp = {"a1":new Point(),"a2":new Point()};
    Map m = ObjectToMap.convert(a1);
    A a2 = ObjectFromMap.convert(m, A);
    a1.isEqual(a2);
  });
}