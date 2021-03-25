//1 load all dependency files
//2 load all libraries
//3 check if all dependency files start with correct library
//4 check if all dependencies are in the library file

import 'dart:io';

import "contentfiles/library.dart";
import "contentfiles/package.dart";

const String path_library = "game/";
const String path_subpackages = "subpackages/";

void main() {
  var libraryLoader = new LibraryLoader();
  var packageLoader = new PackageLoader(libraryLoader);
  var libraryFixer = new LibaryFix();
  fixPackages(getPackages(path_library, packageLoader), libraryFixer);
  fixPackages(getPackages(path_subpackages, packageLoader), libraryFixer);
}

void fixPackages(Map<String, Package> packages, LibaryFix libraryFixer) {
  for (var p in packages.values) {
    for (var l in p.libraries.values) {
      libraryFixer.fix(l, true);
    }
  }
}

Map<String, Package> getPackages(String dir, PackageLoader packageLoader) {
  var packages = new Map<String, Package>();
  for (var p in new Directory(dir).listSync(recursive: false, followLinks: false)) {
    var path = p.path;
    if (!FileSystemEntity.isDirectorySync(path)) continue;
    path = "${path}/lib/";
    if (!new Directory(path).existsSync()) continue;
    var name = p.path.replaceAll(dir, "");
    packages[name] = packageLoader.load(name, path);
  }
  return packages;
}
