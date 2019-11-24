part of game.leveleditor;

class StartingPositionsPreview {
  void paintPositions(CanvasRenderingContext2D ctx, List<StartingPosition> positions, double vehicleW, double vehicleH, double scale) {
    var vehicleHW = vehicleW ~/ 2;
    var vehicleHH = vehicleH ~/ 2;

    ctx.fillStyle = "blue";
    ctx.strokeStyle = "black";
    for (var p in positions) {
      ctx.save();
      ctx.translate(p.point.x * scale, p.point.y * scale);
      ctx.rotate(p.r);
      ctx.beginPath();
      ctx.rect(-vehicleHW * scale, -vehicleHH * scale, vehicleW * scale, vehicleH * scale);
      ctx.fill();
      ctx.closePath();
      /*
      ctx.beginPath();
      ctx.moveTo(-vehicleHW*scale,-vehicleHH*scale);
      ctx.lineTo(vehicleHW*scale,vehicleHH*scale);
      ctx.stroke();
      ctx.moveTo(vehicleHW*scale,-vehicleHH*scale);
      ctx.lineTo(-vehicleHW*scale,vehicleHH*scale);
      ctx.stroke();
      ctx.closePath();
      */
      ctx.restore();
    }
  }
}
