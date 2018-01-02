import "dart:html";
import "package:gameutils/math.dart";
import "package:renderlayer/renderlayer.dart";
import "package:micromachines/game.dart";
import "dart:math" as Math;

class CheckpointPoints{
  Point2d p1,p2,center;
  CheckpointPoints(this.center, this.p1,this.p2);
}

void main(){
  print("Hoi");

  RenderLayer layer = new RenderLayer.withSize(800,800);
  document.body.append(layer.canvas);

  List<PathCheckPoint> path = [
    new PathCheckPoint(700.0,500.0,50.0),
    new PathCheckPoint(500.0,700.0,50.0),
    new PathCheckPoint(200.0,600.0,50.0),
    new PathCheckPoint(100.0,100.0,50.0),
    new PathCheckPoint(300.0,300.0,50.0),
  ];
  var roadToPolygon = new PathToPolygons();
  var roadPolygons = roadToPolygon.createRoadPolygons(path, true);
  layer.ctx.strokeStyle = "#fff";
  layer.ctx.fillStyle = "#000";



  layer.ctx.strokeStyle = "blue";
  layer.ctx.lineWidth = 50;
  layer.ctx.beginPath();
  layer.ctx.moveTo(path[0].x,path[0].y);
  for(int i = 1; i < path.length; i++){
    layer.ctx.lineTo(path[i].x,path[i].y);
  }
  layer.ctx.lineTo(path[0].x,path[0].y);
  layer.ctx.stroke();

  layer.ctx.strokeStyle = "#fff";
  layer.ctx.lineWidth = 1;

  //for(var P in roadPolygons){
  //  drawPolygon(P,layer);
  //}
  List<CheckpointPoints> checkpointsPoints = [];
  //draw checkpoints
  for(int i = 0; i < path.length; i++){
    var P = path[i];
    var Pnext = i < path.length-1 ? path[i+1] : path[0];
    var Pprev = i > 0 ? path[i-1] : path[path.length-1];
    drawCheckPoint(P, layer);
    /*
    wall.applyMatrix(new Matrix2d.translation(-pathCheckpoint.radius,0.0)),
      wall.applyMatrix(new Matrix2d.translation(pathCheckpoint.radius,0.0)),
     */
    var transposed = new Matrix2d.translation(P.x,P.y).rotate(getCheckpointAngle(P, Pprev,Pnext));
    var p1 = new Point2d(-P.radius, 0.0);
    var p2 = new Point2d(P.radius, 0.0);
    p1 = transposed.apply(p1);
    p2 = transposed.apply(p2);
    layer.ctx.beginPath();
    layer.ctx.moveTo(p1.x,p1.y);
    layer.ctx.lineTo(p2.x,p2.y);
    layer.ctx.stroke();
    //print("${P.x},${P.y}, ${Pnext.x},${Pnext.y} ${Pprev.x},${Pprev.y}");
    checkpointsPoints.add(new CheckpointPoints(P,p1,p2));
  }
  /*
  for(int i = 0; i < checkpointsPoints.length; i++){
    var P = checkpointsPoints[i];
    var Pnext = i < checkpointsPoints.length-1 ? checkpointsPoints[i+1] : checkpointsPoints[0];
    layer.ctx.beginPath();
    layer.ctx.moveTo(P.p1.x,P.p1.y);
    layer.ctx.lineTo(Pnext.p1.x,Pnext.p1.y);
    layer.ctx.stroke();
    layer.ctx.beginPath();
    layer.ctx.moveTo(P.p2.x,P.p2.y);
    layer.ctx.lineTo(Pnext.p2.x,Pnext.p2.y);
    layer.ctx.stroke();
  }
*/
}

double getCheckpointAngle(PathCheckPoint c,PathCheckPoint cPrev,PathCheckPoint cNext){
  double angle = ((cPrev-c)+(c-cNext)).angle;
  angle += Math.PI/2;
  return angle;
}

void drawCheckPoint(PathCheckPoint point, RenderLayer layer){
  layer.ctx.beginPath();
  layer.ctx.arc(point.x, point.y,point.radius,0,2*Math.PI);
  layer.ctx.stroke();
}

void drawPolygon(Polygon polygon, RenderLayer layer){
  layer.ctx.beginPath();
  var first = polygon.points.first;
  layer.ctx.moveTo(first.x,first.y);
  for(Point2d p in polygon.points){
    layer.ctx.lineTo(p.x,p.y);
  }
  layer.ctx.lineTo(first.x,first.y);
  layer.ctx.stroke();
  layer.ctx.fill();
}
