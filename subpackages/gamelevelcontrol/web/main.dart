import "../lib/gamelevelcontrol.dart";

void main()
{
  GameLevelCategory cat_main = new GameLevelCategoryWithFile("Defaults");
  GameLevelController controller = new GameLevelControllerWithFile(cat_main);
  GameLevelCategory cat_training = new GameLevelCategoryWithFile("Basic training");
  cat_main.addCategory(cat_training);
  cat_training.addLevel(new GameLevelWithFile("Basic training","training/basic.json"));
  cat_training.addLevel(new GameLevelWithFile("Demolition","training/damage.json"));
  cat_training.addLevel(new GameLevelWithFile("Enemy training","training/enemies.json"));
  cat_training.addLevel(new GameLevelWithFile("Conqueror training","training/conqueror.json"));
  cat_training.addLevel(new GameLevelWithFile("Portals","training/portal.json"));

  GameLevelCategory cat_levels = new GameLevelCategoryWithFile("Levels");
  cat_main.addCategory(cat_levels);
  for(int i = 1; i <= 18; i++)
    cat_levels.addLevel(new GameLevelWithFile("$i","levels/level$i.json",i>1));

  print(controller.getStoredData());
  print(controller.getStoredProgress());
}