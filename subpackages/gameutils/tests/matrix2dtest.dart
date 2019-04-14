library object2map.test;
import "package:gameutils/math.dart";
import "package:test/test.dart";
import "dart:math" as Math;

double precision = 0.00001;

void main()
{
  test("Translate", (){
    var A = new Point2d(2.0,3.0);
    var M = new Matrix2d.identity();
    var MT = M.translate(1.0,2.0);
    var B = MT.apply(A);

    expect(B.x, closeTo(3.0,precision));
    expect(B.y, closeTo(5.0,precision));
  });
  test("Scale", (){
    var A = new Point2d(2.0,3.0);
    var M = new Matrix2d.identity();
    var MT = M.scale(2.0,3.0);
    var B = MT.apply(A);

    expect(B.x, closeTo(4.0,precision));
    expect(B.y, closeTo(9.0,precision));
  });
  test("Rotate180", (){
    var A = new Point2d(2.0,3.0);
    var M = new Matrix2d.identity();
    var MT = M.rotate(Math.pi);
    var B = MT.apply(A);

    expect(B.x, closeTo(-2.0,precision));
    expect(B.y, closeTo(-3.0,precision));
  });
  test("Rotate90", (){
    var A = new Point2d(2.0,3.0);
    var M = new Matrix2d.identity();
    var MT = M.rotate(Math.pi/2);
    var B = MT.apply(A);

    expect(B.x, closeTo(-3.0,precision));
    expect(B.y, closeTo(2.0,precision));
  });
  test("TranslateRotate", (){
    var A = new Point2d(2.0,3.0);
    var M = new Matrix2d.identity();
    M = M.rotate(Math.pi);
    M = M.translate(1.0,2.0);
    var B = M.apply(A);

    expect(B.x, closeTo(-3.0,precision));
    expect(B.y, closeTo(-5.0,precision));
  });
}