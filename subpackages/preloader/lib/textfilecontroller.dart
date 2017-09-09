/**
@author Danny Hendrix
**/

part of preloader;

class TextfileController 
{
  static Map<String,String> raw_texts = new Map<String, String>();
  static String relativepath = "";
  static bool nocachedefault = false;
  
  static final Logger log = new Logger("TextfileController");

  static String getText(String accessor)
  {
    if(raw_texts.containsKey(accessor) == false)
    {
		log.severe("$accessor is not loaded.");
      return null;
    }
    return raw_texts[accessor];
  }
  
  static void loadTextFile(String file, String accessor, final Function callback, [bool relative = true, bool nocache = null])
  {
    if(accessor == null)
      accessor = file;
    if(hasLoaded(accessor))
      return;
    if(relative == true)
      file = relativepath + file;
	  
	if(nocache == null)
		nocache = nocachedefault;
	if(nocache == true)
	  //TODO:does this go well with php requests? (with the ?t=)
	  file += "?t="+(new DateTime.now().millisecondsSinceEpoch).toString();
    
    HttpRequest.getString(file).then((String text)
    {
	  log.info("Load: $accessor => $file");
      raw_texts[accessor] = text;
      callback();
    });
  }
  
  static bool hasLoaded(String accessor)
  {
    return raw_texts.containsKey(accessor);
  }
}
