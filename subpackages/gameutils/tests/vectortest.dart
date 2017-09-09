library object2map.test;
import "package:gameutils/math.dart";
import "package:test/test.dart";

void main()
{
  test("Add", (){
    Vector a = new Vector(3.0,4.0);
    Vector b = new Vector(1.0,2.0);
    Vector c = a+b;
    expect(c.x, equals(4.0));
    expect(c.y, equals(6.0));
  });
  test("Sub", (){
    Vector a = new Vector(3.0,4.0);
    Vector b = new Vector(1.0,2.0);
    Vector c = a-b;
    expect(c.x, equals(2.0));
    expect(c.y, equals(2.0));
  });
  test("Mul", (){
    Vector a = new Vector(3.0,4.0);
    double b = 5.0;
    Vector c = a*b;
    expect(c.x, equals(15.0));
    expect(c.y, equals(20.0));
  });
}