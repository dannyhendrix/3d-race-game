part of micromachines;

class StartingPosition{
  Point2d point;
  double r;
  StartingPosition(this.point, this.r);
}

class StartingPositions{
  List<StartingPosition> DetermineStartPositions(Point2d start, Point2d next, int totalCars, double vehicleW, double vehicleH, double spaceBetweenVehicleW, double spaceBetweenVehicleH, double availableH){
    double startAngle = start.angleWith(next);
    List<StartingPosition> result = [];

    double x = -(vehicleW/2);//should be 0.0 but this is easier for visual
    int carsRem = totalCars;

    while(carsRem > 0){
      int numberOfCarsPerRow = ((availableH+spaceBetweenVehicleH) / (vehicleH+spaceBetweenVehicleH)).floor();
      numberOfCarsPerRow = Math.min(numberOfCarsPerRow, carsRem);
      double requiredH = (numberOfCarsPerRow*vehicleH) + ((numberOfCarsPerRow-1)*spaceBetweenVehicleH);
      double startOffsetH = (availableH-requiredH)/2;

      double y = -(availableH/2)+startOffsetH+(vehicleH/2);
      for(int i = 0; i < numberOfCarsPerRow; i++){
        Point2d p = new Point2d(x,y);
        p += start;
        p = p.rotate(-startAngle,start);
        result.add(new StartingPosition(p, startAngle));
        y += vehicleH+spaceBetweenVehicleH;
      }
      carsRem -= numberOfCarsPerRow;
      x -= vehicleW+spaceBetweenVehicleW;
    }
    return result;
  }
}