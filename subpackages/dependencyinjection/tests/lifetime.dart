library dependencyinjection.test;

import "package:test/test.dart";
import "package:dependencyinjection/dependencyinjection.dart";

abstract class Base {}

class SimpleClassWithDependencies extends Base {
  int val;
  SimpleClass dependency;
  SimpleClassWithDependencies(ILifetime lifetime, this.val) {
    dependency = lifetime.resolve();
  }
}

class SimpleClass {
  int val;
  SimpleClass(this.val);
}

void main() {
  test("register_instance", () {
    var value = 5;
    var lifetime = DependencyBuilderFactory().createNew((builder) {
      builder.registerInstance<int>(value);
    });
    expect(value, equals(lifetime.resolve<int>()));
  });
  test("register_type", () {
    var value = 5;
    var lifetime = DependencyBuilderFactory().createNew((builder) {
      builder.registerType<int>((lifetime) => value);
    });
    expect(value, equals(lifetime.resolve<int>()));
  });
  test("register_overregistration", () {
    var value = 5;
    var value2 = 2;
    var lifetime = DependencyBuilderFactory().createNew((builder) {
      builder.registerType<int>((lifetime) => value);
      builder.registerType<int>((lifetime) => value2);
    });
    expect(value2, equals(lifetime.resolve<int>()));
  });
  test("register_instance_name", () {
    var value = 5;
    var name = "a";
    var lifetime = DependencyBuilderFactory().createNew((builder) {
      builder.registerInstance<int>(value, name: name);
    });
    expect(value, equals(lifetime.resolve<int>(key: name)));
  });
  test("scope_single", () {
    var counter = 0;
    var lifetime = DependencyBuilderFactory().createNew((builder) {
      builder.registerType((lifetime) => new SimpleClass(counter++), lifeTimeScope: LifeTimeScope.SingleInstance);
    });
    var childLifetime1 = lifetime.startNewLifetimeScope();
    var childLifetime2 = childLifetime1.startNewLifetimeScope();
    expect(0, equals(lifetime.resolve<SimpleClass>().val));
    expect(0, equals(childLifetime1.resolve<SimpleClass>().val));
    expect(0, equals(childLifetime2.resolve<SimpleClass>().val));

    var list = childLifetime2.resolveList<SimpleClass>();
    expect(1, equals(list.length));
    expect(0, equals(list[0].val));
  });
  test("scope_peruser", () {
    var counter = 0;
    var lifetime = DependencyBuilderFactory().createNew((builder) {
      builder.registerType((lifetime) => new SimpleClass(counter++), lifeTimeScope: LifeTimeScope.PerUser);
    });
    var childLifetime1 = lifetime.startNewLifetimeScope();
    var childLifetime2 = childLifetime1.startNewLifetimeScope();
    expect(0, equals(lifetime.resolve<SimpleClass>().val));
    expect(1, equals(childLifetime1.resolve<SimpleClass>().val));
    expect(2, equals(childLifetime2.resolve<SimpleClass>().val));
    expect(3, equals(childLifetime2.resolve<SimpleClass>().val));

    var list = childLifetime2.resolveList<SimpleClass>();
    expect(1, equals(list.length));
    expect(4, equals(list[0].val));
  });
  test("scope_perlifetime_parent", () {
    var counter = 0;
    var lifetime = DependencyBuilderFactory().createNew((builder) {
      builder.registerType((lifetime) => new SimpleClass(counter++), lifeTimeScope: LifeTimeScope.PerLifeTime);
    });
    var childLifetime1 = lifetime.startNewLifetimeScope();
    var childLifetime2 = childLifetime1.startNewLifetimeScope();
    expect(0, equals(lifetime.resolve<SimpleClass>().val));
    expect(1, equals(childLifetime1.resolve<SimpleClass>().val));
    expect(2, equals(childLifetime2.resolve<SimpleClass>().val));
    expect(2, equals(childLifetime2.resolve<SimpleClass>().val));

    var list = childLifetime2.resolveList<SimpleClass>();
    expect(1, equals(list.length));
    expect(2, equals(list[0].val));
  });

  test("scope_perlifetime", () {
    var counter = 0;
    var lifetime = DependencyBuilderFactory().createNew((builder) {
      builder.registerType((lifetime) => new SimpleClass(counter++), lifeTimeScope: LifeTimeScope.PerLifeTime);
    });
    var childLifetime1 = lifetime.startNewLifetimeScope();
    var childLifetime2 = lifetime.startNewLifetimeScope();
    expect(0, equals(lifetime.resolve<SimpleClass>().val));
    expect(1, equals(childLifetime1.resolve<SimpleClass>().val));
    expect(2, equals(childLifetime2.resolve<SimpleClass>().val));

    var list = childLifetime2.resolveList<SimpleClass>();
    expect(1, equals(list.length));
    expect(2, equals(list[0].val));
  });

  test("list_type", () {
    var value1 = 5;
    var value2 = 0;
    var value3 = 2;
    var value4 = 7;
    var lifetime = DependencyBuilderFactory().createNew((builder) {
      builder.registerType<int>((lifetime) => value1);
      builder.registerType<int>((lifetime) => value2);
    });
    var childLifetime1 = lifetime.startNewLifetimeScope((builder) {
      builder.registerType<int>((lifetime) => value3);
    });
    var childLifetime2 = childLifetime1.startNewLifetimeScope((builder) {
      builder.registerType<int>((lifetime) => value4);
    });
    var list = childLifetime2.resolveList<int>();
    expect(list.length, equals(4));
    expect(value1, equals(list[0]));
    expect(value2, equals(list[1]));
    expect(value3, equals(list[2]));
    expect(value4, equals(list[3]));
  });

  test("injection", () {
    var counter = 0;
    var lifetime = DependencyBuilderFactory().createNew((builder) {
      builder.registerType((lifetime) => new SimpleClass(counter++), lifeTimeScope: LifeTimeScope.SingleInstance);
      builder.registerType((lifetime) => new SimpleClassWithDependencies(lifetime, counter++));
    });
    expect(1, equals(lifetime.resolve<SimpleClassWithDependencies>().dependency.val));
    expect(1, equals(lifetime.resolve<SimpleClass>().val));
  });
  test("injection_perlifetime_overregister", () {
    var value1 = 9;
    var value2 = 2;
    var value3 = 5;
    var lifetime = DependencyBuilderFactory().createNew((builder) {
      builder.registerType((lifetime) => new SimpleClass(value2), lifeTimeScope: LifeTimeScope.SingleInstance);
      builder.registerType((lifetime) => new SimpleClassWithDependencies(lifetime, value1));
    });
    var childLifetime1 = lifetime.startNewLifetimeScope((builder) {
      builder.registerType((lifetime) => new SimpleClass(value3), lifeTimeScope: LifeTimeScope.SingleInstance);
    });

    expect(value3, equals(childLifetime1.resolve<SimpleClassWithDependencies>().dependency.val));
  });
  test("injection_perlifetime", () {
    var counter = 0;
    var value1 = 2;
    var lifetime = DependencyBuilderFactory().createNew((builder) {
      builder.registerType((lifetime) => new SimpleClass(counter++), lifeTimeScope: LifeTimeScope.PerLifeTime);
    });
    var childLifetime1 = lifetime.startNewLifetimeScope((builder) {
      builder.registerType((lifetime) => new SimpleClassWithDependencies(lifetime, value1));
    });

    expect(0, equals(lifetime.resolve<SimpleClass>().val));
    expect(1, equals(childLifetime1.resolve<SimpleClass>().val));
    expect(1, equals(childLifetime1.resolve<SimpleClassWithDependencies>().dependency.val));
  });
}
