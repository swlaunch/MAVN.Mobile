import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

abstract class BlocOutput with EquatableMixin {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => false;
}

abstract class BlocEvent extends BlocOutput {}

abstract class BlocState extends BlocOutput {}

abstract class Bloc<BLOC_STATE extends BlocState> {
  Bloc() {
    if (BLOC_STATE == Bloc) {
      throw StateError('You forgot to pass a type to the Bloc');
    }
    _stateObservable = BehaviorSubject.seeded(initialState());
    _eventObservable = PublishSubject();
  }

  BLOC_STATE get currentState => _stateObservable.value;

  Stream<BLOC_STATE> get state => _stateObservable.stream;

  Stream<BlocEvent> get event => _eventObservable.stream;

  BehaviorSubject<BLOC_STATE> _stateObservable;
  PublishSubject<BlocEvent> _eventObservable;

  @protected
  BLOC_STATE initialState();

  @mustCallSuper
  void dispose() {
    _stateObservable.close();
    _eventObservable.close();
  }

  @protected
  @visibleForTesting
  void setState(BLOC_STATE newState) {
    _stateObservable.add(newState);
  }

  @protected
  @visibleForTesting
  void sendEvent(BlocEvent newEvent) {
    _eventObservable.add(newEvent);
  }
}

typedef ShouldUpdate<BLOC_STATE extends BlocState> = bool Function(
    BLOC_STATE oldState, BLOC_STATE newState);

BLOC_STATE useBlocState<BLOC_STATE extends BlocState>(Bloc<BLOC_STATE> bloc,
    {ShouldUpdate<BLOC_STATE> shouldUpdate}) {
  if (BLOC_STATE == BlocState) {
    throw StateError('You forgot to pass a type to useBlocState');
  }

  final oldState = useValueNotifier<BLOC_STATE>(bloc.currentState);
  return useStream<BLOC_STATE>(
          bloc.state.skip(1).where(
            (newState) {
              final willUpdate = shouldUpdate != null && oldState.value != null
                  ? shouldUpdate(oldState.value, newState)
                  : true;
              oldState.value = newState;
              return willUpdate;
            },
          ),
          initialData: bloc.currentState)
      .data;
}

typedef BlocEventListenerCallback = void Function(BlocEvent event);

void useBlocEventListener(
  Bloc bloc,
  BlocEventListenerCallback blocEventListener,
) {
  final blocEventStream = bloc.event;

  useEffect(
    // ignore: void_checks
    () {
      final subscription = blocEventStream.listen(blocEventListener);
      // This will cancel the subscription when the widget is disposed
      // or if the callback is called again.
      return subscription.cancel;
    },
    // when the stream change, useEffect will call the callback again.
    [blocEventStream, blocEventListener],
  );
}

class BlocEventListener extends HookWidget {
  const BlocEventListener(
      {@required this.bloc, @required this.onEvent, this.child, Key key})
      : super(key: key);

  final Bloc bloc;
  final Widget child;

  @required
  final BlocEventListenerCallback onEvent;

  @override
  Widget build(BuildContext context) {
    useBlocEventListener(bloc, onEvent);

    return child;
  }
}

// ignore: must_be_immutable
class BlocConsumer<BLOC_STATE extends BlocState> extends HookWidget {
  BlocConsumer({
    @required this.bloc,
    @required this.builder,
    this.shouldUpdate,
    this.child,
  });

  final Bloc bloc;

  /// Called whenever the [BLOC_STATE] changes.
  final BlocStateBuilder<BLOC_STATE> builder;

  final ShouldUpdate<BLOC_STATE> shouldUpdate;

  /// An optional constant child that does not depend on the bloc state.
  /// This will be passed as the child of [builder].
  final Widget child;

  BLOC_STATE oldState;

  @override
  Widget build(BuildContext context) {
    final oldState = useValueNotifier<BLOC_STATE>(bloc.currentState);

    return StreamBuilder<BLOC_STATE>(
      initialData: bloc.currentState,
      stream: bloc.state.skip(1).where((newState) {
        final willUpdate = shouldUpdate != null && oldState.value != null
            ? shouldUpdate(oldState.value, newState)
            : true;
        oldState.value = newState;
        return willUpdate;
      }),
      builder: (context, snapshot) => builder(context, child, snapshot.data),
    );
  }
}

/// Builds a child for a [BlocConsumer].
typedef BlocStateBuilder<BLOC_STATE extends BlocState> = Widget Function(
  BuildContext context,
  Widget child,
  BLOC_STATE state,
);
