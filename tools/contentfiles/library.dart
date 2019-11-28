import 'dart:io';

class Library {
  String name;
  File filePath;
  List<String> internalRef = [];
  List<String> externalRef = [];
  List<String> parts = [];

  Library(this.filePath);
}

class LibaryFix {
  void fix(Library library, bool save) {
    _replaceParts(library);
    if (save) {
      _fixDefinitionFile(library);
      for (var part in library.parts) {
        _fixSourceFile(new File("${library.filePath.parent.path}/$part"), library.name);
      }
    }
  }

  void _replaceParts(Library library) {
    library.parts.clear();
    var path = library.filePath.path;
    var dirPackage = path.substring(0, path.lastIndexOf("/"));
    // strip dir and extension
    var libraryFilename = path.substring(path.lastIndexOf("/") + 1, path.length - 5);
    var dirSource = "$dirPackage/src/$libraryFilename";
    var filesSource = _getSourceFiles(dirSource);
    for (var fileSource in filesSource) {
      var pathRelative = fileSource.path.substring(dirSource.length + 1).replaceAll("\\", "/");
      var pathSave = "src/$libraryFilename/$pathRelative";
      library.parts.add(pathSave);
    }
  }

  void _fixSourceFile(File file, String libraryName) {
    var content = file.readAsStringSync();
    if (content.startsWith("part of")) {
      var firstNewLine = content.indexOf("\n");
      content = content.substring(firstNewLine + 1);
    }
    file.writeAsStringSync("part of $libraryName;\n" + content);
  }

  void _fixDefinitionFile(Library library) {
    var str = new StringBuffer();
    str.writeln("library ${library.name};");
    str.writeln("");
    for (var a in library.externalRef) {
      str.writeln("import \"$a\";");
    }
    str.writeln("");
    for (var a in library.internalRef) {
      str.writeln("import \"$a\";");
    }
    str.writeln("");
    for (var a in library.parts) {
      str.writeln("part \"$a\";");
    }
    library.filePath.writeAsStringSync(str.toString());
  }

  List<File> _getSourceFiles(String dir) {
    var files = new List<File>();
    for (var p in new Directory(dir).listSync(recursive: true, followLinks: false)) {
      var path = p.path;
      if (FileSystemEntity.isDirectorySync(path)) continue;
      if (!path.endsWith(".dart")) continue;
      files.add(p);
    }
    return files;
  }
}

class LibraryLoader {
  Library load(File filePath) {
    var library = new Library(filePath);
    var content = filePath.readAsStringSync();
    for (var item in content.split(";")) {
      item = item.trim();
      if (item == "") continue;
      var spl2 = item.split(" ");
      _addReference(library, spl2[0].trim(), spl2[1].trim().toLowerCase().replaceAll('"', "").replaceAll("'", ""));
    }
    return library;
  }

  void _addReference(Library library, String key, String value) {
    switch (key) {
      case "library":
        library.name = value;
        return;
      case "import":
        if (value.startsWith("dart") || value.startsWith("package"))
          library.externalRef.add(value);
        else
          library.internalRef.add(value);
        return;
      case "part":
        library.parts.add(value);
        return;
      default:
        return;
    }
  }
}
