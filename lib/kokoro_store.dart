import 'dart:async';
import 'package:fimber/fimber.dart';

typedef Reducer<S> = S Function(dynamic action, S oldState);

final mapHastToBeDefined =
    ArgumentError("map has to be defined if there is a main");

final stateShallBeImmutable = AssertionError("the state shall be immutable");

class KokoroStore<S> {
  final S _initialState;
  late final Reducer<S> _reduce;
  final KokoroStore<dynamic>? _main;
  final S Function(Object)? _map;
  final StreamController<S> _changeController;
  late S _state;

  KokoroStore(this._initialState,
      [Reducer<S>? reduce, this._main, this._map, syncStream = false])
      : _changeController = StreamController.broadcast(sync: syncStream) {
    _state = _initialState;
    _reduce = reduce ?? (a, s) => s;
  }

  KokoroStore<T> child<T>(T Function(S) map) {
    return KokoroStore(map(_initialState),
        (a, _) => map(_reduce(a, currentState)), this, (it) => map(it as S));
  }

  S get currentState {
    if (_main == null) return _state;
    if (_map == null) {
      throw mapHastToBeDefined;
    }
    return _map!(_main!.currentState);
  }

  Stream<S> get state {
    if (_main == null) return _changeController.stream.distinct();
    if (_map == null) {
      throw mapHastToBeDefined;
    }
    return _main!.state.map((it) => _map!.call(it));
  }

  _next(Object action, S oldState, [bool log = false]) {
    final newState = _reduce(action, oldState) ?? oldState;
    if (newState != oldState) {
      if (newState.hashCode == oldState.hashCode) {
        // throw stateShallBeImmutable;
        Fimber.e(stateShallBeImmutable.toString());
      }
      if (log) {
        Fimber.d("${runtimeType.toString()} newState:// $newState");
      }
      _state = newState;
      _changeController.add(newState);
    }
  }

  dispatch(Object action, [bool log = false]) {
    if (log) {
      Fimber.d("${_initialState.runtimeType.toString()} action:// $action ");
      Fimber.d(
          "${_initialState.runtimeType.toString()} currentState:// $currentState ");
    }

    if (_main != null) {
      _main?.dispatch(action, log);
    } else {
      _next(action, currentState, log);
    }
  }
}
