library object2map;

import "dart:mirrors";

const String _ObjectIdentifier = "__obj";

abstract class ObjectFromMap
{
  static final _listBaseType = reflectType(List);
  static final _mapBaseType = reflectType(Map);

  static dynamic convert(Map map, Type type) => _convert(map,reflectType(type));

  static dynamic convertIn(Map map, dynamic obj)
  {
    InstanceMirror instance = reflect(obj);
    ClassMirror cm = instance.type;
    return _convertFromObjExtracted(map,cm,instance);
  }

  static dynamic _convert(dynamic input, TypeMirror type)
  {
    if (input == null)
      return null;
    Type t = type.reflectedType;
    if (t == String || t == int || t == double || t == bool)
      return input;
    if (type.originalDeclaration.isSubtypeOf(_listBaseType))
      return _convertFromList(input,type);
    if (type.originalDeclaration.isSubtypeOf(_mapBaseType))
      return _convertFromMap(input,type);
    return _convertFromObj(input, type);
  }

  static List _convertFromList(List inlist, TypeMirror type)
  {
    TypeMirror valueType = type.typeArguments[0];
    return inlist.map((x) => _convert(x,valueType)).toList();
  }

  static Map _convertFromMap(Map inmap, TypeMirror type)
  {
    Map map = {};
    TypeMirror keyType = type.typeArguments[0];
    TypeMirror valueType = type.typeArguments[1];
    inmap.forEach((dynamic k, dynamic v)
    {
      map[_convert(k,keyType)] = _convert(v,valueType);
    });
    return map;
  }

  static dynamic _convertFromObj(Map map, TypeMirror type)
  {
    String fullName = map[_ObjectIdentifier].toString();
    String objS = fullName.split(".").last;
    String libS = fullName.length == objS.length ? "" : fullName.substring(0,fullName.length-objS.length-1);
    Symbol obj = MirrorSystem.getSymbol(objS);
    Symbol lib = MirrorSystem.getSymbol(libS);
    ClassMirror cm = currentMirrorSystem().findLibrary(lib).declarations[obj];
    InstanceMirror instance = cm.newInstance(new Symbol(""), []);
    return _convertFromObjExtracted(map,cm,instance);
  }

  static dynamic _convertFromObjExtracted(Map map, ClassMirror cm, InstanceMirror instance)
  {
    while(cm != null){
      cm.declarations.values.where((x) => x is VariableMirror).forEach((VariableMirror dm){
        Symbol s = dm.simpleName;
        String name = MirrorSystem.getName(s);
        if(map.containsKey(name)) instance.setField(s, _convert(map[name], dm.type));
      });
      cm = cm.superclass;
    }
    return instance.reflectee;
  }
}

abstract class ObjectToMap{
  static Map convert(dynamic obj, [bool includePrivateFields = true]) => _convert(obj, includePrivateFields);
  static Map convertWithTypeSchema(dynamic obj, Type type, [bool includePrivateFields = true]){
    InstanceMirror instance = reflect(obj);
    ClassMirror cm = reflectClass(type);
    return _convertFromObjExtracted(instance,cm,includePrivateFields);
  }

  static dynamic _convert(dynamic input, bool includePrivateFields){
    if(input == null)
      return null;
    if(input is String || input is int || input is double)
      return input;
    if(input is List)
      return _convertFromList(input, includePrivateFields);
    if(input is Map)
      return _convertFromMap(input, includePrivateFields);
    return _convertFromObj(input, includePrivateFields);
  }

  static List _convertFromList(List inlist, bool includePrivateFields){
    return inlist.map((dynamic val) => _convert(val, includePrivateFields)).toList();
  }

  static Map _convertFromMap(Map inmap, bool includePrivateFields){
    Map map = {};
    inmap.forEach((dynamic k, dynamic v)
    {
      map[_convert(k, includePrivateFields)] = _convert(v, includePrivateFields);
    });
    return map;
  }

  static Map _convertFromObj(dynamic obj, bool includePrivateFields) {
    InstanceMirror instance = reflect(obj);
    ClassMirror cm = instance.type;
    return _convertFromObjExtracted(instance,cm,includePrivateFields);
  }

  static Map _convertFromObjExtracted(InstanceMirror instance, ClassMirror cm, bool includePrivateFields) {
    Map result = {};
    result[_ObjectIdentifier] = MirrorSystem.getName(cm.qualifiedName);
    while(cm != null){
      Iterable<DeclarationMirror> decls = includePrivateFields
          ? cm.declarations.values.where((x) => x is VariableMirror)
          : cm.declarations.values.where((x) => x is VariableMirror && !x.isPrivate);
      decls.forEach((VariableMirror dm){
        if(dm.isStatic) return;
        Symbol s = dm.simpleName;
        result[MirrorSystem.getName(s)] = _convert(instance.getField(s).reflectee, includePrivateFields);
      });
      cm = cm.superclass;
    }
    return result;
  }
}