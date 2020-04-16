import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

Module subjectModule;

void main() {
  group('Module unit tests', () {
    setUp(() {});

    test('Module can not provide same Factory type with no qualifier name', () {
      expect(() => TestModule1(), throwsAssertionError);
    });

    test(
        'Module can not provide same Lazy Singleton type with no qualifier '
        'name', () {
      expect(() => TestModule2(), throwsAssertionError);
    });

    test('Module can provide same type with a different qualifier name', () {
      final subject = TestModule3();
      expect(subject.firstString, 'Hello');
      expect(subject.secondString, 'Another hello');

      expect(subject.firstDouble, 1.0);
      expect(subject.secondDouble, 2.0);
    });

    test(
        'Different Modules can provide same types, '
        'because they have different containers', () {
      TestModule3();
      TestModule4();
    });

    test('Lazy Singleton returns same instance', () {
      final subject = TestModule5();
      expect(identical(subject.testObject, subject.testObject), true);
    });

    test('Factory returns different instances', () {
      final subject = TestModule6();
      expect(identical(subject.testObject, subject.testObject), false);
    });

    test('Lazy Singleton with qualifier returns same instance', () {
      final subject = TestModule7();
      expect(identical(subject.testObject, subject.testObject), true);
    });

    test('Factory with qualifier returns different instances', () {
      final subject = TestModule8();
      expect(identical(subject.testObject, subject.testObject), false);
    });

    test(
        'Lazy Singleton with qualifier returns different instance '
        'than Lazy Singleton with another qualifier', () {
      final subject = TestModule7();
      expect(identical(subject.testObject, subject.anotherTestObject), false);
    });

    test(
        'Singleton with qualifier returns different instance '
        'than Singleton with another qualifier', () {
      final subject = TestModule7();
      expect(identical(subject.testObject, subject.anotherTestObject), false);
    });

    test(
        'Factory with qualifier returns different instance '
        'than Factory with another qualifier', () {
      final subject = TestModule7();
      expect(identical(subject.testObject, subject.anotherTestObject), false);
    });

    test(
        'Dependencies of Lazy Singleton can not be specified after '
        'registering it', () {
      final subject = TestModule9();
      expect(subject.testObject, isNotNull);
    });
  });
}

// UTILS
class TestModule1 extends Module {
  @override
  void provideInstances() {
    provideFactory(() => 'Hello');
    provideFactory(() => 'Another hello');
  }
}

class TestModule2 extends Module {
  @override
  void provideInstances() {
    provideSingleton(() => 1.0);
    provideSingleton(() => 2.0);
  }
}

class TestModule3 extends Module {
  String get firstString => get();

  String get secondString => get(qualifierName: 'another');

  double get firstDouble => get();

  double get secondDouble => get(qualifierName: 'another');

  @override
  void provideInstances() {
    provideFactory(() => 'Hello');
    provideFactory(() => 'Another hello', qualifierName: 'another');

    provideSingleton(() => 1.0);
    provideSingleton(() => 2.0, qualifierName: 'another');
  }
}

class TestModule4 extends Module {
  String get firstString => get();

  String get secondString => get(qualifierName: 'another');

  int get firstInt => get();

  int get secondInt => get(qualifierName: 'another');

  double get firstDouble => get();

  double get secondDouble => get(qualifierName: 'another');

  @override
  void provideInstances() {
    provideFactory(() => 'Hello');
    provideFactory(() => 'Another hello', qualifierName: 'another');

    provideSingleton(() => 1.0);
    provideSingleton(() => 2.0, qualifierName: 'another');
  }
}

class SimplePODO {
  SimplePODO(this.name, this.count, this.price);

  final String name;
  final int count;
  final double price;
}

class TestModule5 extends Module {
  SimplePODO get testObject => get();

  @override
  void provideInstances() {
    provideSingleton(() => SimplePODO('someName', 1, 2));
  }
}

class TestModule6 extends Module {
  SimplePODO get testObject => get();

  @override
  void provideInstances() {
    provideFactory(() => SimplePODO('someName', 1, 2));
  }
}

class TestModule7 extends Module {
  SimplePODO get testObject => get(qualifierName: 'someQualifierName');

  SimplePODO get anotherTestObject =>
      get(qualifierName: 'anotherQualifierName');

  @override
  void provideInstances() {
    provideSingleton(() => SimplePODO('someName', 1, 2),
        qualifierName: 'someQualifierName');
    provideSingleton(() => SimplePODO('someName', 1, 2),
        qualifierName: 'anotherQualifierName');
  }
}

class TestModule8 extends Module {
  SimplePODO get testObject => get(qualifierName: 'someQualifierName');

  SimplePODO get anotherTestObject =>
      get(qualifierName: 'anotherQualifierName');

  @override
  void provideInstances() {
    provideFactory(() => SimplePODO('someName', 1, 2),
        qualifierName: 'someQualifierName');
    provideFactory(() => SimplePODO('someName', 1, 2),
        qualifierName: 'anotherQualifierName');
  }
}

class TestModule9 extends Module {
  SimplePODO get testObject => get();

  @override
  void provideInstances() {
    provideSingleton(() => SimplePODO(get(), get(), get()));
    provideFactory(() => 'someName');
    provideFactory(() => 1);
    provideFactory(() => 2.0);
  }
}
