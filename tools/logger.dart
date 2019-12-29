import "../subpackages/dependencyinjection/lib/dependencyinjection.dart";

void main(){
	var lifetime = DependencyBuilderFactory().createNew((builder){
      builder.registerType((lifetime)=> new Tracer("root"));
      builder.registerType((lifetime)=> new Sample(lifetime));
    });
	var tracer = lifetime.resolve<Tracer>();
    tracer.trace(()=>"Hoi");
	lifetime.resolve<Sample>().init();
}

typedef String Trace();
class Tracer{
	static Map<String, Tracer> _tracers = {};
	Tracer getTracer(Type type){
		var name = type.toString();
		if(!_tracers.containsKey(name)) _tracers[name] = new Tracer(name);
		return _tracers[name];
	}
	String _name = "";
	Tracer(this._name);
	void trace(Trace f){
		print("${_name} ${f()}");
	}
}

class Sample{
	Tracer _logger;
	
	  Sample(ILifetime lifetime) {
			_logger = lifetime.resolve<Tracer>().getTracer(Sample);
	  }
	  
	  void init(){
		_logger.trace(()=>"Samepl");
	  }
}