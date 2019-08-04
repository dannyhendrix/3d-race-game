part of game.definitions;

class StartingPosition{
  Vector point;
  double r;
  StartingPosition(this.point, this.r);
}

class StartingPositions{
  double spaceBetweenVehicleW = GameConstants.startingPositionSpacing.x;
  double spaceBetweenVehicleH = GameConstants.startingPositionSpacing.y;

  List<StartingPosition> determineStartPositions(double sx, double sy, double sr, double radius, double vehicleW, double vehicleH, int totalCars){
    return transformAndRotatePositions(sx,sy,sr, determineStartLocations(radius, vehicleW,vehicleH,totalCars));
  }

  List<StartingPosition> transformAndRotatePositions(double sx, double sy, double sr, List<Vector> points){
    sr -=  Math.pi;
    Matrix2d M = new Matrix2d().translateThis(sx, sy).rotateThis(sr);
    return points.map((x) => new StartingPosition(x.applyMatrixToThis(M),sr+Math.pi)).toList();
  }

  List<Vector> determineStartLocations(double radius, double vehicleW, double vehicleH, int totalCars){
    List<Vector> result = [];
    var availableH = radius*2;
    var availableHH = availableH/2;
    var vehicleHH = vehicleH/2;
    var vehicleHW = vehicleW/2;
    var vehicleSpaceW = vehicleW+spaceBetweenVehicleW;
    var vehicleSpaceH = vehicleH+spaceBetweenVehicleH;

    double x = vehicleHW;//move vehicle behind the starting line
    int carsRem = totalCars;

    int numberOfCarsPerRow = (availableH / vehicleSpaceH).floor();

    while(carsRem > 0){
      numberOfCarsPerRow = Math.min(numberOfCarsPerRow, carsRem);
      double requiredH = numberOfCarsPerRow*vehicleSpaceH;
      double startOffsetH = (availableH-requiredH+spaceBetweenVehicleH)/2;

      double y = -availableHH+startOffsetH+vehicleHH;
      for(int i = 0; i < numberOfCarsPerRow; i++){
        result.add(new Vector(x,y));
        y += vehicleSpaceH;
      }
      carsRem -= numberOfCarsPerRow;
      x += vehicleSpaceW;
    }
    return result;
  }
}