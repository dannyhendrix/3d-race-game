part of gameutils.settings;

typedef void OnGameSettingChanged<T>(T newvalue);

class GameSetting<T>
{
  T _value;
  T defaultvalue;
  final String k;
  String description;
  /**
   * Game should listen to the menu/dashboard whenever a setting changes.
   */
  OnGameSettingChanged<T> onChanged;
  
  /**
   * Set value. Should never be called from Game, only from dasboard or menu.
   */
  set v(T value)
  {
    _value = value;
    if(onChanged != null)
      onChanged(value);
  }
  T get v => _value;
  
  GameSetting(this.k,this._value,[this.description = null])
  {
    defaultvalue = _value;
    if(description == null)
      description = k;
  }
  
  void setOnChanged(OnGameSettingChanged<T> f, [bool triggerToInitialize = false])
  {
	if(f == null)
		return;
	onChanged = f;
	if(triggerToInitialize)
		onChanged(_value);
  }
}

abstract class GameSettingWithTranslator<Type, StoredType>
{
  Type convertFrom(StoredType stored);
  StoredType convertTo(Type actual);
}

class GameSettingWithAllowedValues<T> extends GameSetting<T>
{
	List<T> allowedValues;
	GameSettingWithAllowedValues(String key, T value, this.allowedValues, [String description]) : super(key,value,description);
}

//TODO: this is not ideal. It would be nice if allowedValues could be abstracted from T. Currently Dart does not allow this.
class GameSettingWithEnum<T> extends GameSetting<T> implements GameSettingWithTranslator<T, String>
{
  List<T> allowedValues;
  GameSettingWithEnum(String key, T value, this.allowedValues, [String description]) : super(key,value,description);
  
  T convertFrom(String stored)
  {
    for(T a in allowedValues)
      if(stored == a.toString().split(".").last)
        return a;
    return allowedValues[0];
  }
  String convertTo(T actual)
  {
    return actual.toString().split(".").last;
  }
}

class IntMapSettings<T> extends GameSetting<Map<int,T>> implements GameSettingWithTranslator<Map<int,T>, Map<String,T>>
{
  IntMapSettings(String k, Map<int,T> value, [String description = null]) : super(k, value, description);

  @override
  Map<int, T> convertFrom(Map<String, T> stored)
  {
    Map<int,T> converted = {};
    stored.forEach((String k, T val)
    {
      converted[int.parse(k)] = val;
    });
    return converted;
  }

  @override
  Map<String, T> convertTo(Map<int, T> actual)
  {
    Map<String,T> converted = {};
    actual.forEach((int k, T val)
    {
      converted[k.toString()] = val;
    });
    return converted;
  }
}

class SettingsStoredInCookie
{
  bool loadedFromCookie = false;
	GameSetting<bool> storeInCookie = new GameSetting("storeInCookie", true, "Store cookie");
	void saveToCookie()
  {
    if(!storeInCookie.v)
      return;
    DateTime time = new DateTime.now();
    time.add(new Duration(days: 1000));
    document.cookie = new JsonEncoder().convert(_createStorageMap()) + ";expires="+time.toUtc().toString();
  }

  void emptyCookie()
  {
    DateTime time = new DateTime.now();
    time.add(new Duration(days: 1000));
    document.cookie = new JsonEncoder().convert({}) + ";expires="+time.toUtc().toString();
  }
  
  void loadFromCookie([bool resetCookie = false])
  {
    loadedFromCookie = !document.cookie.isEmpty;
    if(!loadedFromCookie){
        return;
    }
    storeInCookie.v = true;
    _loadStorageMap(new JsonDecoder().convert(document.cookie));
    if(resetCookie)
      saveToCookie();
  }
  
  List<GameSetting> getStoredSettingsKeys()
  {
    return [];
  }
  
  Map _createStorageMap()
  {
    Map result = {};
    for(GameSetting s in getStoredSettingsKeys())
		if(s is GameSettingWithTranslator)
    {
      GameSettingWithTranslator ss = s as GameSettingWithTranslator;
      result[s.k] = ss.convertTo(s.v);
    }
		else
			result[s.k] = s.v;
			
    return result;
  }
  
  void _loadStorageMap(Map stored)
  {
    for(GameSetting s in getStoredSettingsKeys())
      if(stored.containsKey(s.k))
	  {
      if(s is GameSettingWithTranslator)
      {
        GameSettingWithTranslator ss = s as GameSettingWithTranslator;
        s.v = ss.convertFrom(stored[s.k]);
      }
		  else
			  s.v = stored[s.k];
		}
  }
}