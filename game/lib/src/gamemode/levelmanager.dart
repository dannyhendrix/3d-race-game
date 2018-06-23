part of game.gamemode;


class LevelManager{
  //TODO: load levels from JSON
  Map leveljson = {"w":2400,"d":1280,"walls":[{"x":1200.0,"z":8.0,"r":0.0,"w":2400.0,"d":16.0,"h":16.0},{"x":1200.0,"z":1272.0,"r":0.0,"w":480.0,"d":16.0,"h":16.0},{"x":8.0,"z":768.0,"r":0.0,"w":16.0,"d":960.0,"h":16.0},{"x":2392.0,"z":640.0,"r":0.0,"w":16.0,"d":1248.0,"h":16.0},{"x":1184.0,"z":344.0,"r":0.0,"w":1280.0,"d":16.0,"h":16.0},{"x":1856.0,"z":576.0,"r":1.4,"w":480.0,"d":16.0,"h":16.0},{"x":512.0,"z":576.0,"r":1.7,"w":480.0,"d":16.0,"h":16.0},{"x":1168.0,"z":992.0,"r":1.6,"w":560.0,"d":16.0,"h":16.0}],"staticobjects":[{"id":0,"x":70.0,"z":80.0,"r":0.5},{"id":0,"x":40.0,"z":150.0,"r":0.2},{"id":0,"x":30.0,"z":250.0,"r":0.8},{"id":0,"x":780.0,"z":500.0,"r":0.2},{"id":0,"x":850.0,"z":450.0,"r":0.1},{"id":0,"x":680.0,"z":510.0,"r":0.0},{"id":0,"x":1500.0,"z":500.0,"r":0.0},{"id":0,"x":1600.0,"z":560.0,"r":0.2},{"id":0,"x":1650.0,"z":800.0,"r":0.6},{"id":0,"x":1400.0,"z":1200.0,"r":0.2},{"id":0,"x":1260.0,"z":1100.0,"r":0.5}],"path":{"circular":true,"laps":5,"checkpoints":[{"x":944.0,"z":176.0,"radius":160.0},{"x":2080.0,"z":160.0,"radius":160.0},{"x":2080.0,"z":1024.0,"radius":160.0},{"x":1520.0,"z":1008.0,"radius":160.0},{"x":1200.0,"z":496.0,"radius":96.0},{"x":752.0,"z":960.0,"radius":160.0},{"x":288.0,"z":1040.0,"radius":160.0},{"x":304.0,"z":576.0,"radius":160.0},{"x":304.0,"z":176.0,"radius":160.0}]}};
  Map levelJson2 = {"w":2400,"d":1280,"walls":[],"staticobjects":[],"path":{"circular":true,"laps":5,"checkpoints":[
    {"x":1180,"z":1150,"radius":120},
    {"x":2070,"z":1150,"radius":120},
    {"x":2250,"z":840,"radius":120},
    {"x":2070,"z":560,"radius":120},
    {"x":1590,"z":560,"radius":120},
    {"x":1400,"z":80,"radius":120},
    {"x":1100,"z":180,"radius":120},
    {"x":1280,"z":570,"radius":120},
    {"x":480,"z":270,"radius":120},
    {"x":500,"z":70,"radius":120},
    {"x":110,"z":90,"radius":120},
    {"x":110,"z":710,"radius":120},
    {"x":440,"z":1150,"radius":120}
  ]}};
  Map levelJson3 = {"w":2400,"d":1280,"walls":[],"staticobjects":[],"path":{"circular":true,"laps":5,"checkpoints":[{"x":340,"z":1134,"radius":80},{"x":968,"z":1120,"radius":80},{"x":930,"z":700,"radius":80},{"x":1332,"z":652,"radius":80},{"x":1520,"z":906,"radius":80},{"x":1892,"z":1128,"radius":80},{"x":2260,"z":964,"radius":80},{"x":2030,"z":596,"radius":80},{"x":2292,"z":300,"radius":80},{"x":1850,"z":112,"radius":80},{"x":1616,"z":452,"radius":80},{"x":1282,"z":106,"radius":80},{"x":1278,"z":408,"radius":80},{"x":904,"z":374,"radius":80},{"x":808,"z":74,"radius":80},{"x":392,"z":78,"radius":80},{"x":80,"z":362,"radius":80},{"x":538,"z":630,"radius":80}]}};

  GameLevelLoader _levelLoader = new GameLevelLoader();
  Map<int, GameLevel> loadedLevels = {};

  void preLoadLevels(){
    loadedLevels[0] = _levelLoader.loadLevelJson(leveljson);
    loadedLevels[1] = _levelLoader.loadLevelJson(levelJson2);
    loadedLevels[2] = _levelLoader.loadLevelJson(levelJson3);
  }

  GameLevel loadLevel(int id){
   if(loadedLevels.containsKey(id) == false) throw new Exception("Cannot load level $id. Level is not loaded!");
    return loadedLevels[id];
  }
}