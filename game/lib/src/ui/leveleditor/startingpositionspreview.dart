part of game.leveleditor;

class StartingPositionsPreview{
  void paintPositions(CanvasRenderingContext2D ctx, List<StartingPosition> positions, double vehicleW, double vehicleH){
    var vehicleHW = vehicleW~/2;
    var vehicleHH = vehicleH~/2;

    ctx.fillStyle = "red";
    for(var p in positions){
      ctx.save();
      ctx.translate(p.point.x, p.point.y);
      ctx.rotate(p.r);
      ctx.beginPath();
      ctx.rect(-vehicleHW,-vehicleHH, vehicleW, vehicleH);
      ctx.fill();
      ctx.moveTo(-vehicleHW,-vehicleHH);
      ctx.lineTo(vehicleHW,vehicleHH);
      ctx.stroke();
      ctx.moveTo(vehicleHW,-vehicleHH);
      ctx.lineTo(-vehicleHW,vehicleHH);
      ctx.stroke();
      ctx.closePath();
      ctx.restore();
    }
  }
}