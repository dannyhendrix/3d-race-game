part of micromachines;

enum VehicleType {Car, Pickup, GrandPrix, Truck, Bus}
// combinations should be blocked in UI
enum TrailerType {None, Caravan, TruckTrailer}

enum VehicleThemeColor {
  Red, Green, Blue, Gray, Black, White, Orange, Pink, Yellow
}

class VehicleTheme{
  VehicleThemeColor color1, color2;
  VehicleTheme() : color1 = VehicleThemeColor.White, color2 = VehicleThemeColor.Blue;
  VehicleTheme.withColor(this.color1, this.color2);
  VehicleTheme.withDefaults() : this.withColor(VehicleThemeColor.Black, VehicleThemeColor.White);
}