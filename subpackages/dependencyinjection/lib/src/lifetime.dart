part of dependencyinjection;

enum LifeTimeScope {SingleInstance, PerLifeTime, PerUser}
typedef T NewInstance<T>();
typedef void NewChildLifeTime(IDependencyBuilder builder);

class DependencyBuilderFactory{
  ILifetime createNew([NewChildLifeTime build]) => new Lifetime.fromBuilder(null,build);
}
abstract class IDependencyBuilder{
  void RegisterInstance<T>(T obj, {String name = null, List<Type> additionRegistrations});
  void RegisterType<T>(NewInstance<T> create, {LifeTimeScope lifeTimeScope = LifeTimeScope.PerUser, String name = null, List<Type> additionRegistrations});
  void _addRegistration<T>(List<Type> additionRegistrations, Registration registration, String name);
  ILifetime build();
}
abstract class ILifetime{
  ILifetime startNewLifetimeScope([NewChildLifeTime build]);
  List<T> resolveList<T>({String name});
  T resolve<T>({String name});
}
abstract class IDependencyLoader{
  void setDependencies(ILifetime lifetime);
}

class Registration{
  NewInstance<dynamic> create;
  LifeTimeScope lifeTimeScope;
  Registration(this.create, this.lifeTimeScope);
}

class InstanceContainer{
  Map<Registration, dynamic> _lifetimeInstances = {};
  dynamic getInstance(Registration registration, ILifetime lifetime){
    if(!_lifetimeInstances.containsKey(registration)){
      _lifetimeInstances[registration]=createNew(registration, lifetime);
    }
    return _lifetimeInstances[registration];
  }
  static dynamic createNew(Registration registration, ILifetime lifetime){
    var obj = registration.create();
    if(obj is IDependencyLoader) obj.setDependencies(lifetime);
    return obj;
  }
}
class Lifetime implements ILifetime, IDependencyBuilder{
  InstanceContainer _singleInstanceContainer = new InstanceContainer();
  InstanceContainer _lifetimeInstanceContainer = new InstanceContainer();
  Lifetime _parentLifetime = null;
  Map<Type, List<Registration>> _registrations = {};
  Map<String, List<Registration>> _registrationsByName = {};
  Lifetime.fromLifetime(this._parentLifetime);
  Lifetime.fromBuilder(this._parentLifetime,[NewChildLifeTime build]){
    build?.call(this);
  }
  Lifetime();

  //builder
  void RegisterInstance<T>(T obj, {String name = null, List<Type> additionRegistrations}){
    _addRegistration<T>(additionRegistrations,new Registration(() => obj, LifeTimeScope.SingleInstance),name);
  }
  void RegisterType<T>(NewInstance<T> create, {LifeTimeScope lifeTimeScope = LifeTimeScope.PerUser, String name = null, List<Type> additionRegistrations}){
    _addRegistration<T>(additionRegistrations,new Registration(create,lifeTimeScope),name);
  }
  ILifetime build(){
    return this;
  }

  //container
  T resolve<T>({String name}){
    if(name != null){
      var key = _storedKey(name, T);
      return _resolveFromLifetimeByName<T>(key,this);
    }
    return _resolveFromLifetime<T>(this);
  }
  List<T> resolveList<T>({String name}){
    var lst = new List<T>();
    if(name != null){
      var key = _storedKey(name, T);
      _resolveToListByName<T>(lst,key,this);
    }else{
      _resolveToList(lst,this);
    }
    return lst;
  }
  ILifetime startNewLifetimeScope([NewChildLifeTime build]){
    return new Lifetime.fromBuilder(this, build);
  }

  dynamic _getInstance(Registration registration, Lifetime lifetime){
    switch(registration.lifeTimeScope){
      case LifeTimeScope.SingleInstance:return _singleInstanceContainer.getInstance(registration,this);
      case LifeTimeScope.PerLifeTime:return lifetime._lifetimeInstanceContainer.getInstance(registration,this);
      case LifeTimeScope.PerUser: return InstanceContainer.createNew(registration, this);
    }
  }
  T _resolveFromLifetime<T>(Lifetime lifetime){
    if(_registrations.containsKey(T)) return _getInstance(_registrations[T].last,lifetime);
    if(_parentLifetime != null) return _parentLifetime._resolveFromLifetime<T>(lifetime);
    throw new Exception("Cannot resolve type $T");
  }
  T _resolveFromLifetimeByName<T>(String key, Lifetime lifetime){
    if(_registrationsByName.containsKey(key)) return _getInstance(_registrationsByName[key].last,lifetime);
    if(_parentLifetime != null) return _parentLifetime._resolveFromLifetimeByName<T>(key,lifetime);
    throw new Exception("Cannot resolve type $T by name $key");
  }
  void _resolveToList<T>(List<T> objs, Lifetime lifetime){
    if(_parentLifetime != null) _parentLifetime._resolveToList<T>(objs, lifetime);
    if(_registrations.containsKey(T)){
      for(var x in _registrations[T]) objs.add(_getInstance(x, lifetime));
    }
  }
  void _resolveToListByName<T>(List<T> objs, String key, Lifetime lifetime){
    if(_parentLifetime != null) _parentLifetime._resolveToListByName<T>(objs, key, lifetime);
    if(_registrationsByName.containsKey(key)){
      for(var x in _registrationsByName[key]) objs.add(_getInstance(x, lifetime));
    }
  }

  void _addRegistration<T>(List<Type> additionRegistrations, Registration registration, String name){
    _addSingleRegistration(T,registration, name);
    if(additionRegistrations == null) return;
    for(var t in additionRegistrations) _addSingleRegistration(t,registration, name);
  }
  void _addSingleRegistration(Type t, Registration registration, String name){
    if(!_registrations.containsKey(t)) _registrations[t] = [];
    _registrations[t].add(registration);
    if(name != null){
      var key = _storedKey(name, t);
      if(!_registrationsByName.containsKey(key)) _registrationsByName[key] = [];
      _registrationsByName[key].add(registration);
    }
  }
  String _storedKey(String name, Type t) => "${t}_${name}";
}