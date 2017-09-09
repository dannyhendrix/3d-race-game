import "package:gamelevelcontrol/gamelevelcontrol.dart";
import "package:test/test.dart";

void main()
{
  test("Store load", (){
    var stubA = new GameLevelStub("Dinges",true);
    var data = stubA.getStoredData();
    var stubB = new GameLevelStub("");
    stubB.setStoredData(data);
    expect(stubB.name, equals(stubA.name));
    expect(stubB.locked, equals(true));
  });
}