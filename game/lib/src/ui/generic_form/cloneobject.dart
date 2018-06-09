part of webgl_game;

class CloneObject{
  static final _listBaseType = reflectType(List);
  static final _mapBaseType = reflectType(Map);

  static dynamic clone(dynamic obj){
    InstanceMirror instance = reflect(obj);
    return _clone(obj, instance.type);
  }
  static dynamic _clone(dynamic input, TypeMirror type)
  {
    if (input == null)
      return null;
    Type t = type.reflectedType;
    if (t == String || t == int || t == double || t == bool)
      return input;
    if (type.originalDeclaration.isSubtypeOf(_listBaseType))
      return _cloneFromList(input,type);
    if (type.originalDeclaration.isSubtypeOf(_mapBaseType))
      return _cloneFromMap(input,type);

    InstanceMirror instance = reflect(input);
    ClassMirror cm = instance.type;
    if(cm.isEnum) return _cloneFromEnum(instance, cm);
    return _cloneFromObj(instance, type);
  }

  static List _cloneFromList(List inlist, TypeMirror type)
  {
    TypeMirror valueType = type.typeArguments[0];
    return inlist.map((x) => _clone(x,valueType)).toList();
  }

  static Map _cloneFromMap(Map inmap, TypeMirror type)
  {
    Map map = {};
    TypeMirror keyType = type.typeArguments[0];
    TypeMirror valueType = type.typeArguments[1];
    inmap.forEach((dynamic k, dynamic v)
    {
      map[_clone(k,keyType)] = _clone(v,valueType);
    });
    return map;
  }
  static dynamic _cloneFromEnum(InstanceMirror instance,ClassMirror cm)
  {
    int index = instance.getField(new Symbol("index")).reflectee;
    return cm.getField(new Symbol("values")).reflectee[index];
  }
  static dynamic _cloneFromObj(InstanceMirror instance, ClassMirror cm)
  {
    InstanceMirror newinstance = cm.newInstance(new Symbol(""), []);

    for(var x in cm.declarations.values){
      if(!(x is VariableMirror)) continue;
      VariableMirror dm = x;
      Symbol s = dm.simpleName;
      newinstance.setField(s, _clone(instance.getField(s).reflectee, dm.type));
    }
    cm = cm.superclass;

    return newinstance.reflectee;
  }
}
