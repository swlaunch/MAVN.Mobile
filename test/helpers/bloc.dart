import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

class MockBloc<T extends BlocState> extends Mock implements Bloc<T> {
  @mustCallSuper
  MockBloc(T initialState) {
    if (initialState != null) {
      when(currentState).thenReturn(initialState);
    }

    _stateObservable = BehaviorSubject.seeded(initialState);
    _eventObservable = PublishSubject();

    when(state).thenAnswer((_) => _stateObservable.stream);
    when(event).thenAnswer((_) => _eventObservable.stream);
  }

  BehaviorSubject<T> _stateObservable;
  PublishSubject<BlocEvent> _eventObservable;

  Future<void> testNewState({
    @required T state,
    @required WidgetTester widgetTester,
  }) async {
    _stateObservable.add(state);
    await widgetTester?.pump();
  }

  Future<void> testNewEvent({
    @required BlocEvent event,
    @required WidgetTester widgetTester,
  }) async {
    _eventObservable.add(event);
    await widgetTester?.pump();
  }
}

class BlocTester<T extends Bloc> {
  BlocTester(this._bloc) {
    _mergeStateAndEventStreams();
  }

  final T _bloc;

  Stream<BlocOutput> _output;

  int _outputsEmitted = 0;

  BlocState get currentState => _bloc.currentState;

  Future<void> assertCurrentState(BlocState expectedState) async {
    expect(currentState, expectedState);
  }

  Future<void> assertCurrentStateType(Type expectedStateType) async {
    expect(currentState.runtimeType, expectedStateType);
  }

  Future<void> assertFullBlocOutputInOrder(
      Iterable<BlocOutput> expectedOutput) async {
    await expectLater(_output, emitsInOrder(expectedOutput));

    expect(
      _outputsEmitted,
      expectedOutput.length,
      reason: 'You haven\'t asserted all Bloc outputs. The Bloc had '
          '$_outputsEmitted outputs, you expected ${expectedOutput.length} '
          'outputs.',
    );
  }

  Future<void> assertFullBlocOutputInAnyOrder(
      Iterable<BlocOutput> expectedOutput) async {
    await expectLater(_output, emitsInAnyOrder(expectedOutput));

    expect(
      _outputsEmitted,
      expectedOutput.length,
      reason: 'You haven\'t asserted all Bloc outputs. The Bloc had '
          '$_outputsEmitted outputs, you expected ${expectedOutput.length} '
          'outputs.',
    );
  }

  void _mergeStateAndEventStreams() {
    _outputsEmitted = 0;
    _output = MergeStream([_bloc.event, _bloc.state]).publishReplay()
      ..connect()
      ..listen((_) {
        _outputsEmitted++;
      });
  }
}
