part of game.definitions;

enum VehicleType {Car, Truck, Formula, Pickup, /*Bus*/}
// combinations should be blocked in UI
enum TrailerType {None, Caravan, TruckTrailer}

enum VehicleThemeColor {
  Red, Green, Blue, Gray, Black, White, Orange, Pink, Yellow
}

class VehicleTheme{
  int textureId = 0;
  VehicleThemeColor color1, color2;
  VehicleTheme() : color1 = VehicleThemeColor.White, color2 = VehicleThemeColor.Blue;
  VehicleTheme.withColor(this.color1, this.color2, [this.textureId=0]);
  VehicleTheme.withDefaults() : this.withColor(VehicleThemeColor.Black, VehicleThemeColor.White);
}