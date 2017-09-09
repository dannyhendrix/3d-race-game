import "package:gamelevelcontrol/gamelevelcontrol.dart";
import "package:test/test.dart";

void main()
{
  test("Store load level", (){
    var stubA = new GameLevelCategoryStub("Dinges",true);
    var levelStubA = new GameLevelStub("Level1");
    stubA.addLevel(levelStubA);
    var stubB = new GameLevelCategoryStub.fromData(stubA.getStoredData());
    var levelStubB = stubB.getLevels().first;
    expect(stubB.name, equals(stubA.name));
    expect(stubB.locked, equals(stubA.locked));
    expect(levelStubB.name, equals(levelStubA.name));
  });
}