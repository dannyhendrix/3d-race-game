import "../lib/gamelevelcontrol.dart";

//0 construct json
//1 check if file exists
// show message: replace existing?


void main(){
  //48-57 0-9 10
  //65-90 A-Z 26
  //97-122 a-z 26
  //62
  UnlockKeyGenerator keyGen = new UnlockKeyGenerator();
  print(keyGen.generate("HoeLangMagDezeStringZijn","Level1"));

  print(keyGen.generate("Levels","10"));
  print(keyGen.generate("Leveks","10"));
  print(keyGen.generate("Levels","1"));
  for(int i = 0; i< 30; i++)
  print(i.toString()+" "+keyGen.generate("Levels",i.toString()));
  //for(int i = 0; i< 100; i++)
  //print(i.toString()+" "+keyGen.convertCodeUnitToBase(i).toString());
}
