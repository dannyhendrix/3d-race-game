import "dart:html";
import "package:gameutils/math.dart";
import "package:renderlayer/renderlayer.dart";
import "package:micromachines/game.dart";

void main(){
  print("Hoi");

  RenderLayer layer = new RenderLayer.withSize(800,800);
  document.body.append(layer.canvas);

  Polygon path = new Polygon([
    new Point(100.0,100.0),
    new Point(300.0,300.0),
    new Point(700.0,500.0),
    new Point(500.0,700.0),
    new Point(200.0,600.0),
  ]);
  var roadToPolygon = new PathToPolygons();
  var roadPolygons = roadToPolygon.createRoadPolygons(path.points, 50.0, true);
  layer.ctx.strokeStyle = "#fff";
  layer.ctx.fillStyle = "#000";
  for(var P in roadPolygons){
    drawPolygon(P,layer);
  }
}

void drawPolygon(Polygon polygon, RenderLayer layer){
  layer.ctx.beginPath();
  var first = polygon.points.first;
  layer.ctx.moveTo(first.x,first.y);
  for(Point p in polygon.points){
    layer.ctx.lineTo(p.x,p.y);
  }
  layer.ctx.lineTo(first.x,first.y);
  layer.ctx.stroke();
  layer.ctx.fill();
}
