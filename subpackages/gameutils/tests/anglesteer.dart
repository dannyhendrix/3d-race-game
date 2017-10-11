library mathutils.test;
import "package:gameutils/math.dart";
import "package:test/test.dart";
import "dart:math" as Math;

enum Steer {Left,Right,None}

Steer determineSteerAngle(Point A, double RA, Point B){
  var dist = B-A;
  var normT = new Vector(dist.x,dist.y).normalized;
  var normA = new Vector.fromAngleRadians(RA,1.0);
  var ra = normA.angle;
  var rt = normT.angle;
  print("B ${B.x},${B.y} RA $RA ra $ra rt $rt");
  if(ra == 0){
    if(rt>0) return Steer.Right;
    return Steer.Left;
  }
  if(rt == 0){
    if(ra<0) return Steer.Right;
    return Steer.Left;
  }
  if(ra < 0 && rt < 0){
    if(ra < rt) return Steer.Right;
    return Steer.Left;
  }
  if(ra > 0 && rt > 0){
    if(rt < ra) return Steer.Left;
    return Steer.Right;
  }
  if(ra < 0 && rt > 0){
    if(rt-ra > Math.PI) return Steer.Left;
    return Steer.Right;
  }
  if(ra > 0 && rt < 0){
    if(ra-rt > Math.PI) return Steer.Right;
    return Steer.Left;
  }
  return Steer.None;
}
void main()
{
  test("Angle", (){
    expect(determineSteerAngle(new Point(2.0,-4.0),0.0,new Point(5.0,-2.0)), equals(Steer.Right));
    expect(determineSteerAngle(new Point(2.0,-4.0),0.0,new Point(-4.0,-6.0)), equals(Steer.Left));
    expect(determineSteerAngle(new Point(2.0,-4.0),0.0,new Point(-5.0,2.0)), equals(Steer.Right));
    expect(determineSteerAngle(new Point(2.0,-4.0),0.0,new Point(-1.0,4.0)), equals(Steer.Right));
    expect(determineSteerAngle(new Point(2.0,-4.0),0.0,new Point(3.0,3.0)), equals(Steer.Right));

    expect(determineSteerAngle(new Point(2.0,-4.0),-2.0,new Point(5.0,-2.0)), equals(Steer.Right));
    expect(determineSteerAngle(new Point(2.0,-4.0),-2.0,new Point(-4.0,-6.0)), equals(Steer.Left));
    expect(determineSteerAngle(new Point(2.0,-4.0),-2.0,new Point(-5.0,2.0)), equals(Steer.Left));
    expect(determineSteerAngle(new Point(2.0,-4.0),-2.0,new Point(-1.0,4.0)), equals(Steer.Left));
    expect(determineSteerAngle(new Point(2.0,-4.0),-2.0,new Point(3.0,3.0)), equals(Steer.Left));
  });
}