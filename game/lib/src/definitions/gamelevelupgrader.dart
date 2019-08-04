part of game.definitions;

typedef Map upgrader(Map data);

class GameLevelUpgrader{
  int mainVersion = 1;
  int subVersion = 1;

  List<List<upgrader>> _upgraders;

  GameLevelUpgrader(){
    _upgraders = [
      [// main 0
        _upgrade_0_0 //sub 0
      ],
      [// main 1
        _upgrade_1_0, //sub 0
        //_upgrade_1_1 //sub 1
      ]
    ];
  }

  Map upgrade(Map data){
    var versionSpl = data["version"].toString().split(".");
    var mainVersionIn = int.parse(versionSpl[0]);
    var subVersionIn = int.parse(versionSpl[1]);

    while(mainVersionIn < mainVersion){
      print("Mainversion: ${mainVersionIn}");
      while(subVersionIn < _upgraders[mainVersionIn].length){
        print("Subversion: ${subVersionIn}");
        data = _upgraders[mainVersionIn][subVersionIn](data);
        subVersionIn++;
      }
      subVersionIn = 0;
      mainVersionIn++;
    }

    while(subVersionIn < subVersion){
      print("Subversion: ${subVersionIn}");
      data = _upgraders[mainVersionIn][subVersionIn](data);
      subVersionIn++;
    }

    data["version"] = "${mainVersion}.${subVersion}";
    return data;
  }

  Map _upgrade_1_0(Map data){
    if(data.containsKey("path")){
      if(data["path"].containsKey("checkpoints"))
        for(var x in data["path"]["checkpoints"]) {
          x["lengthBefore"] = x["radius"];
          x["lengthAfter"] = x["radius"];
          _rename(x, "radius", "width");
        }
    }
    return data;
  }
  Map _upgrade_0_0(Map data){
    _rename(data, "d", "h");
    if(data.containsKey("walls")) for(var x in data["walls"]){ _rename(x, "z", "y"); _swap(x, "d", "h");}
    if(data.containsKey("staticobjects")) for(var x in data["staticobjects"]) _rename(x, "z", "y");
    if(data.containsKey("score")){
      if(data["score"].containsKey("balls"))
        for(var x in data["score"]["balls"])
          _rename(x, "z", "y");
      if(data["score"].containsKey("teams"))
        for(var x in data["score"]["teams"]){
          if(x.containsKey("startingpositions"))
            for(var x in x["startingpositions"])
              {
                x.remove("w");
                x.remove("h");
                x["radius"] = 100.0;
              }
          if(x.containsKey("goals"))
            for(var x in x["goals"]){
              _rename(x, "z", "y");
              _swap(x, "d", "h");
            }
        }
    }
    if(data.containsKey("path")){
      if(data["path"].containsKey("checkpoints"))
        for(var x in data["path"]["checkpoints"]) _rename(x, "z", "y");
    }
    return data;
  }

  void _rename(Map data, String oldName, String newName){
    var temp = data[oldName];
    data.remove(oldName);
    data[newName] = temp;
  }
  void _swap(Map data, String fieldA, String fieldB){
    var temp = data[fieldA];
    data[fieldA] = data[fieldB];
    data[fieldB] = temp;
  }
}