part of dependencyinjection;

enum LifeTimeScope {SingleInstance, PerLifeTime, PerUser}
typedef T NewInstance<T>(ILifetime lifetime);
typedef void NewChildLifeTime(IDependencyBuilder builder);

class DependencyBuilderFactory{
  ILifetime createNew([NewChildLifeTime build]) => new Lifetime.fromBuilder(null,build);
}
abstract class IDependencyBuilder{
  void registerInstance<T>(T obj, {String name = null, List<Type> additionRegistrations});
  void registerType<T>(NewInstance<T> create, {LifeTimeScope lifeTimeScope = LifeTimeScope.PerUser, String name = null, List<Type> additionRegistrations});
  void registerModule(IDependencyModule module);
  ILifetime build();
}
abstract class ILifetime{
  ILifetime startNewLifetimeScope([NewChildLifeTime build]);
  List<T> resolveList<T>({String key});
  T resolve<T>({String key});
}

abstract class IDependencyModule{
  void load(IDependencyBuilder builder);
}

class Registration{
  NewInstance<dynamic> create;
  LifeTimeScope lifeTimeScope;
  Registration(this.create, this.lifeTimeScope);
  dynamic createNew(ILifetime lifetime){
    var obj = create(lifetime);
    return obj;
  }
}

class InstanceContainer{
  Map<Registration, dynamic> _lifetimeInstances = {};
  dynamic getInstance(Registration registration, ILifetime lifetime){
    if(!_lifetimeInstances.containsKey(registration)){
      _lifetimeInstances[registration]=registration.createNew(lifetime);
    }
    return _lifetimeInstances[registration];
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
  void registerInstance<T>(T obj, {String name = null, List<Type> additionRegistrations}){
    _addRegistration<T>(additionRegistrations,new Registration((lifetime) => obj, LifeTimeScope.SingleInstance),name);
  }
  void registerType<T>(NewInstance<T> create, {LifeTimeScope lifeTimeScope = LifeTimeScope.PerUser, String name = null, List<Type> additionRegistrations}){
    _addRegistration<T>(additionRegistrations,new Registration(create,lifeTimeScope),name);
  }
  void registerModule(IDependencyModule module){
    module.load(this);
  }
  ILifetime build(){
    return this;
  }

  //container
  T resolve<T>({String key}){
    if(key != null){
        return _resolveFromLifetimeByName<T>(key, this);
    }
    return _resolveFromLifetime<T>(this);
  }
  List<T> resolveList<T>({String key}){
    var lst = new List<T>();
    if(key != null){
      _resolveToListByName<T>(lst,this,key);
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
      case LifeTimeScope.PerUser: return registration.createNew(this);
    }
  }
  T _resolveFromLifetime<T>(Lifetime lifetime){
    if(_registrations.containsKey(T)) return _getInstance(_registrations[T].last,lifetime);
    if(_parentLifetime != null) return _parentLifetime._resolveFromLifetime<T>(lifetime);
    throw new Exception("Cannot resolve type $T");
  }
  T _resolveFromLifetimeByName<T>(String key, Lifetime lifetime){
    var storedKey = _storedKey(key, T);
    if(_registrationsByName.containsKey(storedKey)) return _getInstance(_registrationsByName[storedKey].last,lifetime);
    if(_parentLifetime != null) return _parentLifetime._resolveFromLifetimeByName<T>(key,lifetime);
    throw new Exception("Cannot resolve type $T by name $key");
  }
  void _resolveToList<T>(List<T> objs, Lifetime lifetime){
    if(_parentLifetime != null) _parentLifetime._resolveToList<T>(objs, lifetime);
    if(_registrations.containsKey(T)){
      for(var x in _registrations[T]) objs.add(_getInstance(x, lifetime));
    }
  }
  void _resolveToListByName<T>(List<T> objs, Lifetime lifetime, String key){
    var storedKey = _storedKey(key, T);
    if(_parentLifetime != null) _parentLifetime._resolveToListByName<T>(objs, lifetime, key);
    if(_registrationsByName.containsKey(storedKey)){
      for(var x in _registrationsByName[storedKey]) objs.add(_getInstance(x, lifetime));
    }
  }

  void _addRegistration<T>(List<Type> additionRegistrations, Registration registration, String key){
    _addSingleRegistration(T,registration, key);
    if(additionRegistrations == null) return;
    for(var t in additionRegistrations) _addSingleRegistration(t,registration, key);
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