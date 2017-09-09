import "package:gamelevelcontrol/gamelevelcontrol.dart";
import "package:test/test.dart";

void main()
{
  test("Store progress", (){
    var createStub = (){
      var stubA = new GameLevelControllerStub();
      var catStubA1 = new GameLevelCategoryStub("cat1",true);
      var catStubA2 = new GameLevelCategoryStub("cat2",true);
      var levStubA1 = new GameLevelStub("Lev1",true);
      var levStubA2 = new GameLevelStub("Lev2",true);
      var levStubA3 = new GameLevelStub("Lev3",true);
      catStubA1.addLevel(levStubA1);
      catStubA1.addLevel(levStubA2);
      catStubA2.addLevel(levStubA3);
      stubA.getMainCategory().addCategory(catStubA1);
      stubA.getMainCategory().addCategory(catStubA2);
      stubA.goToFirstLevel();
      return stubA;
    };

    var stubA = createStub();
    var stubB = createStub();

    stubA.goToFirstLevel();
    stubA.getCurrentCategory().locked = false;
    stubA.getCurrentLevel().locked = false;
    stubB.setStoredProgress(stubA.getStoredProgress());

    var performCheck = (){
      expect(stubB.getCurrentLevel().name, stubA.getCurrentLevel().name);
      expect(stubB.getCurrentLevel().locked, stubA.getCurrentLevel().locked);
      expect(stubB.getCurrentCategory().name, stubA.getCurrentCategory().name);
      expect(stubB.getCurrentCategory().locked, stubA.getCurrentCategory().locked);
    };
    var goToLev = (int cat, int lev){
      stubA.setCurrentLevel(stubA.getMainCategory().getCategoryByIndex(cat).getLevelByIndex(lev));
      stubB.setCurrentLevel(stubA.getMainCategory().getCategoryByIndex(cat).getLevelByIndex(lev));
    };

    performCheck();
    goToLev(0,0);
    performCheck();
    goToLev(1,0);
    performCheck();
  });

  test("Store load category", (){
    var stubA = new GameLevelControllerStub();
    var catStubA = new GameLevelCategoryStub("Cat1");
    var levStubA = new GameLevelStub("Lev1");
    stubA.getMainCategory().addCategory(catStubA);
    catStubA.addLevel(levStubA);
    stubA.setCurrentLevel(stubA.getFirstLevel());

    var stubB = new GameLevelControllerStub.fromData(stubA.getStoredData());
    stubB.setCurrentLevel(stubB.getFirstLevel());
    var catStubB = stubB.getCurrentCategory();
    var levStubB = stubB.getCurrentLevel();
    expect(catStubB.name, equals(catStubA.name));
    expect(levStubB.name, equals(levStubA.name));
  });

  test("Cat level prev/next", (){
    var stub = new GameLevelControllerStub();
    var cat1 = new GameLevelCategoryStub("cat1",false);
    var cat2 = new GameLevelCategoryStub("cat2",false);
    var cat1lev1 = new GameLevelStub("Lev1");
    var cat2lev1 = new GameLevelStub("Lev2");
    cat1.addLevel(cat1lev1);
    cat2.addLevel(cat2lev1);
    stub.getMainCategory().addCategory(cat1);
    stub.getMainCategory().addCategory(cat2);

    stub.goToFirstLevel();
    expect(stub.getCurrentCategory().name, equals(cat1.name));
    expect(stub.getCurrentLevel().name, equals(cat1lev1.name));
    stub.goToNextLevel(true);
    expect(stub.getCurrentCategory().name, equals(cat2.name));
    expect(stub.getCurrentLevel().name, equals(cat2lev1.name));
    expect(stub.hasNextLevel(), equals(false));
    stub.goToFirstLevel();
    expect(stub.hasNextLevel(), equals(true));
    expect(stub.getCurrentCategory().name, equals(cat1.name));
    expect(stub.getCurrentLevel().name, equals(cat1lev1.name));
  });

}