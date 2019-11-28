import 'dart:io';
import 'library.dart';

class Package {
  String name;
  Map<String, Library> libraries;
  Package(this.name, this.libraries);
}

class PackageLoader {
  LibraryLoader _libraryLoader;
  PackageLoader(this._libraryLoader);
  Package load(String name, String dir) {
    return new Package(name, _getLibraries(dir));
  }

  Map<String, Library> _getLibraries(String dir) {
    var libraries = new Map<String, Library>();
    for (var p in new Directory(dir).listSync(recursive: false, followLinks: false)) {
      var path = p.path;
      if (FileSystemEntity.isDirectorySync(path)) continue;
      if (!path.endsWith(".dart")) continue;
      libraries[path.replaceAll(dir, "")] = _libraryLoader.load(p);
    }
    return libraries;
  }
}
