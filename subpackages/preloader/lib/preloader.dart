/**
@author Danny Hendrix
**/

library preloader;

import "dart:html";
import "dart:convert";

import "package:logging/logging.dart";

part "imagecontroller.dart";
part "jsoncontroller.dart";
part "textfilecontroller.dart";

/**
load resources, calls a callback when all resources are loaded
**/
class PreLoader 
{
	static final Logger log = new Logger("PreLoader");
	static bool nocachedefault = false;

  int loaded = 0;
  int files = 0;
  
  bool started = false;
  
  Function callbackComplete;
  Function callbackSingle;
  
  PreLoader([this.callbackComplete = null, this.callbackSingle = null]);
  
  void start()
  {
    started = true;
    if(loaded >= files && callbackComplete != null)
      callbackComplete();
  }
  
  void reset()
  {
    loaded = 0;
    files = 0;
    started = false;
  }
  
  void loadImage(String file, [String accessor, bool relative = true, bool nocache = null])
  {
    if(accessor == null)
      accessor = file;
    if(ImageController.hasLoaded(accessor))
      return;
	log.severe("Start loading image $accessor");
    files++;
	if(nocache == null)
		nocache = nocachedefault;
    ImageController.loadImage(file, accessor, fileloaded, relative, nocache);
  }
  
  void loadJson(String file, [String accessor, bool relative = true, bool nocache = null])
  {
    if(accessor == null)
      accessor = file;
    if(JsonController.hasLoaded(accessor))
      return;
	log.severe("Start loading Json $accessor");
    files++;
	if(nocache == null)
		nocache = nocachedefault;
    JsonController.loadJson(file,accessor, fileloaded, relative, nocache);
  }
  
  void loadTextFile(String file, [String accessor, bool relative = true, bool nocache = null])
  {
    if(accessor == null)
      accessor = file;
    if(TextfileController.hasLoaded(accessor))
      return;
	log.severe("Start loading Json $accessor");
    files++;
	if(nocache == null)
		nocache = nocachedefault;
    TextfileController.loadTextFile(file, accessor, fileloaded, relative, nocache);
  }
  
  void fileloaded(String accessor, String file)
  {
    loaded++;
    if(started == false)
      return;
    if(callbackSingle != null)
      callbackSingle(accessor, file);
    if(loaded >= files)
    {
      started = false;
      if(callbackComplete != null)
        callbackComplete();
    }
  }
}
