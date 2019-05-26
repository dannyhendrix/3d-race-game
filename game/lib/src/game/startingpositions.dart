part of micromachines;

class StartingPosition{
  Vector point;
  double r;
  StartingPosition(this.point, this.r);
}

class StartingPositions{
  List<StartingPosition> DetermineStartPositions(Vector start, double startAngle, int totalCars, double vehicleW, double vehicleH, double spaceBetweenVehicleW, double spaceBetweenVehicleH, double availableH){
    List<StartingPosition> result = [];

    double x = -(vehicleW/2);//should be 0.0 but this is easier for visual
    int carsRem = totalCars;
    double fixAngle = Math.pi/2;
    //Matrix2d M = new Matrix2d.rotation(startAngle).translatePoint(start);
    Matrix2d M = new Matrix2d().translateThis(start.x, start.y).rotateThis(startAngle).rotateThis(fixAngle);

    while(carsRem > 0){
      int numberOfCarsPerRow = ((availableH+spaceBetweenVehicleH) / (vehicleH+spaceBetweenVehicleH)).floor();
      numberOfCarsPerRow = Math.min(numberOfCarsPerRow, carsRem);
      double requiredH = (numberOfCarsPerRow*vehicleH) + ((numberOfCarsPerRow-1)*spaceBetweenVehicleH);
      double startOffsetH = (availableH-requiredH)/2;


      double y = -(availableH/2)+startOffsetH+(vehicleH/2);
      for(int i = 0; i < numberOfCarsPerRow; i++){
        var p = M.apply(new Vector(x,y));
        //p += start;
        //p = p.rotate(-startAngle,start);
        result.add(new StartingPosition(p, startAngle+fixAngle));
        y += vehicleH+spaceBetweenVehicleH;
      }
      carsRem -= numberOfCarsPerRow;
      x -= vehicleW+spaceBetweenVehicleW;
    }
    return result;
  }
  List<StartingPosition> DetermineStartPositions2(Vector start, double startAngle, int totalCars, double vehicleW, double vehicleH, double spaceBetweenVehicleW, double spaceBetweenVehicleH, double availableW){
    List<StartingPosition> result = [];
    var availableHW = availableW/2;
    var vehicleHW = vehicleW/2;

    double y = vehicleH/2;//move vehicle behind the starting line
    int carsRem = totalCars;
    Matrix2d M = new Matrix2d().translateThis(start.x, start.y).rotateThis(startAngle);

    int numberOfCarsPerRow = (availableW / (vehicleW+spaceBetweenVehicleW)).floor();

    while(carsRem > 0){
      numberOfCarsPerRow = Math.min(numberOfCarsPerRow, carsRem);
      double requiredW = numberOfCarsPerRow*(vehicleW+spaceBetweenVehicleW);
      double startOffsetW = (availableW-requiredW+spaceBetweenVehicleW)/2;

      double x = -availableHW+startOffsetW+vehicleHW;
      for(int i = 0; i < numberOfCarsPerRow; i++){
        var p = new Vector(x,y).applyMatrixToThis(M);
        result.add(new StartingPosition(p, startAngle));
        x += vehicleW+spaceBetweenVehicleW;
      }
      carsRem -= numberOfCarsPerRow;
      y += vehicleH+spaceBetweenVehicleH;
    }
    return result;
  }
}