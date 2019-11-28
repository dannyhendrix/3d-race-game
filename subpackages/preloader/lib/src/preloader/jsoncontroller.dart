part of preloader;

/**
Json resources holder
**/
class JsonController {
  static Map<String, Map> json_objects = new Map<String, Map>();
  static String relativepath = "";
  static bool nocachedefault = false;

  static final Logger log = new Logger("JsonController");

  static Map getJson(String accessor) {
    if (json_objects.containsKey(accessor) == false) {
      log.severe("$accessor is not loaded.");
      return null;
    }
    return json_objects[accessor];
  }

  static void loadJson(String file, String accessor, final Function callback, [bool relative = true, bool nocache = null]) {
    if (accessor == null) accessor = file;
    if (hasLoaded(accessor)) {
      callback(accessor, file);
      return;
    }
    if (relative == true) file = relativepath + file;

    if (nocache == null) nocache = nocachedefault;
    if (nocache == true)
      //TODO:does this go well with php requests? (with the ?t=)
      file += "?t=" + (new DateTime.now().millisecondsSinceEpoch).toString();

    HttpRequest.getString(file).then((String jsonText) {
      log.info("Load: $accessor => $file");
      json_objects[accessor] = new JsonDecoder().convert(jsonText); //parse(jsonText);//json.parse(req.responseText);
      callback(accessor, file);
    });
  }

  static bool hasLoaded(String accessor) {
    return json_objects.containsKey(accessor);
  }
}
