part of game.definitions;

abstract class GameConstants{
  static int levelMainVersion = 1;
  static int levelSubVersion = 1;

  static Vector carSize = new Vector(50.0,30.0);
  static Vector truckSize = new Vector(50.0,40.0);
  static Vector formulaCarSize = new Vector(50.0,30.0);
  static Vector pickupCarSize = new Vector(70.0,30.0);
  static Vector caravanSize = new Vector(50.0,30.0);
  static Vector truckTrailerSize = new Vector(100.0,40.0);
  static Vector treeSize = new Vector(20.0,20.0);
  static Vector checkpointPostSize = new Vector(8.0,8.0);
  static Vector ballSize = new Vector(50.0,30.0);

  static Vector startingPositionSpacing = new Vector(10.0,10.0);
  static List<String> resources = ["resources/resources.json", "resources/levels.json"];
}