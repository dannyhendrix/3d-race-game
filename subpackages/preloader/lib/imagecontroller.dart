/**
@author Danny Hendrix
**/

part of preloader;

/**
image resources holder
**/
class ImageController 
{
	static final Logger log = new Logger("ImageController");

  //loaded images
  static Map<String,ImageElement> _images = new Map<String,ImageElement>();
  //the base dir to image folder
  static String relativepath = "";
  static bool nocachedefault = false;
  
  //(pre)load an image
  static ImageElement loadImage(String url, [String accessor, Function callback, bool relative = true, bool nocache = null])
  {
    if(accessor == null)
      accessor = url;
    if(_images.containsKey(accessor))
    {
      if(callback != null)
        callback(accessor, url);
      return _images[accessor];
    }
    
    ImageElement img = new Element.tag("img");
    if(relative == true)
      url = relativepath+url;
	if(nocache == null)
		nocache = nocachedefault;
	if(nocache == true)
	  //TODO:does this go well with php requests? (with the ?t=)
	  url += "?t="+(new DateTime.now().millisecondsSinceEpoch).toString();
    img.src = url;
    _images[accessor] = img;
    
	log.info("Load: $accessor => $url");
    if(callback != null)
      img.onLoad.listen((Event e){callback(accessor, url);});
    return img;
  }
  
  static ImageElement getImage(String accessor)
  {
    if(_images.containsKey(accessor))
      return _images[accessor];
	log.warning("Image $accessor was not loaded. Starting loading now.");
    return loadImage(accessor);
  }
  
  static bool hasLoaded(String accessor)
  {
    if(_images.containsKey(accessor) == false)
      return false;
    return _images[accessor].complete;
  }
}
