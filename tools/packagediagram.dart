import "dart:io";

const String path_library = "../game/lib/";
const String path_subpackages = "../subpackages/";
const String path_diagram = "../design/diagram/";

void main() {
  var p = new Package.fromLocation("game", path_library);
  p.saveDiagrams(path_diagram);

  var packages = getSubPackages(path_subpackages);
  for (var p in packages.values) {
    p.saveDiagrams(path_diagram);
  }
}

Map<String, Package> getSubPackages(String dir) {
  var packages = new Map<String, Package>();
  for (var p in new Directory(dir).listSync(recursive: false, followLinks: false)) {
    var path = p.path;
    if (!FileSystemEntity.isDirectorySync(path)) continue;
    path = "${path}/lib/";
    if (!new Directory(path).existsSync()) continue;
    var name = p.path.replaceAll(dir, "");
    packages[name] = new Package.fromLocation(name, path);
  }
  return packages;
}

class Package {
  String name;
  Map<String, Library> libraries;
  Package.fromLocation(this.name, String dir) {
    libraries = _getLibraries(dir);
  }
  Map<String, Library> _getLibraries(String dir) {
    var libraries = new Map<String, Library>();
    for (var p in new Directory(dir).listSync(recursive: false, followLinks: false)) {
      var path = p.path;
      if (FileSystemEntity.isDirectorySync(path)) continue;
      if (!path.endsWith(".dart")) continue;
      libraries[path.replaceAll(dir, "")] = Library.fromFile(path);
    }
    return libraries;
  }

  String createPlantUml(bool includeExternal) {
    var str = new StringBuffer();
    str.writeln("@startuml");
    str.writeln("rectangle {");
    for (var lib in libraries.keys) {
      str.writeln("rectangle ${libraries[lib].name} as ${lib}");
    }
    str.writeln("}");
    for (var lib in libraries.keys) {
      for (var reference in libraries[lib].internalRef) {
        str.writeln("$lib  -->  $reference");
      }
      if (includeExternal) {
        for (var reference in libraries[lib].externalRef) {
          str.writeln("$lib  -->  $reference");
        }
      }
    }
    str.writeln("@enduml");
    return str.toString();
  }

  void saveDiagrams(String location) {
    new File("$location/${name}_packages.plantuml").writeAsStringSync(createPlantUml(false));
    new File("$location/${name}_packages_full.plantuml").writeAsStringSync(createPlantUml(true));
  }
}

class Library {
  String name;
  List<String> internalRef = [];
  List<String> externalRef = [];
  Library(this.name);
  void addReference(String key, String value) {
    switch (key) {
      case "library":
        name = value;
        return;
      case "import":
        if (value.startsWith("dart") || value.startsWith("package"))
          externalRef.add(value);
        else
          internalRef.add(value);
        return;
      //case "part":
      default:
        return;
    }
  }

  Library.fromFile(String filePath) {
    name = filePath;
    var content = new File(filePath).readAsStringSync();
    print(filePath);
    for (var item in content.split(";")) {
      item = item.trim();
      if (item == "") continue;
      var spl2 = item.split(" ");
      addReference(spl2[0].trim().toLowerCase(), spl2[1].trim().toLowerCase().replaceAll('"', "").replaceAll("'", "").replaceAll(":", "_").replaceAll("/", "_"));
    }
  }
}
