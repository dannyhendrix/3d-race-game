part of gamelevelcontrol;

class UnlockKeyGenerator{
  //the version is prepaned to the code
  // this allows so possibilities when the code generation has to change in the future
  int version = 0;
  // keys should not be 0 and primes are prefered
  int key1 = 7;
  int key2 = 11;
  int key3 = 3;

  bool validateKey(String categoryId, String levelId, String key) => key == generate(categoryId,levelId);

  String generate(String categoryId, String levelId){
    //key is 10 characters long
    //0-5 = (categoryId[i]-key2) + (key3*i) where i goes from 0 to 6
    //6-10 = (levelId[i]-key2) + (key3*i) where i goes from 0 to 6

    //finally: (this prevents simularity for instance when the category is the same)
    //[i] += sum([0-13])

    List<int> code = new List<int>(11);
    code[0] = version;
    _createString(code, categoryId, 1);
    _createString(code, levelId, 6);
    _createCheck(code,1);

    for(int i = 0; i<code.length; i++){
      code[i] = _convertCodeUnitToCharAscii(code[i]);
    }

    //checksum
    return new String.fromCharCodes(code);
  }

  List<int> _createString(List<int> codeUnits, String str, int startIndex){
    if(str == null) str = "";
    List<int> strCodeUnits = str.codeUnits;
    codeUnits[startIndex] = strCodeUnits.length*key1;
    for(int i = 1; i < 5; i++){
      codeUnits[startIndex+i] = key3*(i+key2);
    }
    for(int i = 0; i < strCodeUnits.length; i++){
      codeUnits[startIndex+(i%5)] += (_convertCodeUnitToBase(strCodeUnits[i])-key2);
    }
  }

  List<int> _createCheck(List<int> codeUnits, int start){
    int total = 0;
    for(int i = start; i < codeUnits.length; i++){
      total+= codeUnits[i];
    }
    for(int i = start; i < codeUnits.length; i++){
      codeUnits[i] += total;
    }
    return codeUnits;
  }

  int convertCodeUnitToBase(int codeUnit) => _convertCodeUnitToBase(codeUnit);
  int _convertCodeUnitToBase(int codeUnit){
    //48-57 0-90
    //65-90 A-Z
    //97-122 a-z
    if(codeUnit >= 48 && codeUnit <= 57) return codeUnit - 48;
    if(codeUnit >= 65 && codeUnit <= 90) return codeUnit + 10 - 65;
    if(codeUnit >= 97 && codeUnit <= 122) return codeUnit + 36 - 97;
    return 0;
  }

  int _convertCodeUnitToCharAscii(int codeUnit){
    //48-57 0-9 10
    //65-90 A-Z 26
    //97-122 a-z 26
    //62
    codeUnit = codeUnit % 62;
    if(codeUnit < 10) return codeUnit + 48;
    if(codeUnit < 36) return codeUnit - 10 + 65;
    return codeUnit - 36 + 97;
  }
}