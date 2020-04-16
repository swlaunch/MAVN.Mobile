import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:mockito/mockito.dart';

class MockModule extends Mock implements TestModule1 {}

class TestModule1 extends Module {
  @override
  void provideInstances() {
    provideSingleton(() => 'hello');
  }
}

void main() {
  group('ModuleProvider tests', () {
    testWidgets('Module gets disposed when ModuleProvider gets disposed',
        (widgetTester) async {
      final mockModule = MockModule();
      BuildContext innerContext;

      await widgetTester.pumpWidget(TestAppFrame(
          child: ModuleProvider<TestModule1>(
        module: mockModule,
        child: Builder(
          builder: (context) {
            innerContext = context;
            return Container();
          },
        ),
      )));

      expect(
          ModuleProvider.of<TestModule1>(
            innerContext,
            listen: false,
          ),
          isNotNull);
      expect(
          ModuleProvider.of<Module>(
            innerContext,
            listen: false,
          ),
          isNotNull);

      await widgetTester.pumpWidget(
        TestAppFrame(child: Container()),
      );

      await untilCalled(mockModule.dispose());
    });
  });
}

class TestAppFrame extends StatelessWidget {
  const TestAppFrame({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: MaterialApp(
          title: 'Test widget frame',
          theme: ThemeData(),
          home: child,
        ),
      );
}

class ParentModule extends Module {
  @override
  void provideInstances() {
    provideFactory(() => 'Hello');
    provideFactory(() => 'Another hello', qualifierName: 'another');

    provideSingleton(() => 1.0);
    provideSingleton(() => 2.0, qualifierName: 'another');
  }
}

class ChildModule extends Module {
  String get firstString => get(qualifierName: 'childDefault');

  String get secondString => get(qualifierName: 'childAnother');

  double get firstDouble => get(qualifierName: 'childDefault');

  double get secondDouble => get(qualifierName: 'childAnother');

  bool get notFoundBool => get();

  @override
  void provideInstances() {
    provideFactory(() => '${get<String>()}, world',
        qualifierName: 'childDefault');
    provideFactory(() => '${get<String>(qualifierName: 'another')}, world',
        qualifierName: 'childAnother');

    provideSingleton(() => get<double>() + 0.5, qualifierName: 'childDefault');
    provideSingleton(() => get<double>(qualifierName: 'another') + 0.5,
        qualifierName: 'childAnother');
  }
}
