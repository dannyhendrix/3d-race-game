part of micromachines;

enum VehicleThemeColor {
  Red, Green, Blue, Gray, Black, White, Orange, Pink, Yellow
}

class VehicleTheme{
  VehicleThemeColor color1, color2;
  VehicleTheme(this.color1, this.color2);
  VehicleTheme.withDefaults() : this(VehicleThemeColor.Black, VehicleThemeColor.White);
}