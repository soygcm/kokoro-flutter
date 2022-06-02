import 'package:kokoro/kokoro_store.dart';

typedef EmptyUIEvent = void Function();
typedef UIEvent<T> = void Function(T);
typedef TwoParamsUIEvent<T, K> = Function(T, K);
typedef EmptyUIEventReturnBool = Future<bool> Function();

abstract class Kokoro<S, E> {
  late KokoroStore<S> _store;
  late Stream<S> state;

  KokoroStore<S> _createStore(S initialState) {
    return KokoroStore(initialState, reduce);
  }

  Kokoro(S initialState, [KokoroStore<S>? store]) {
    _store = store ?? _createStore(initialState);
    state = _store.state;
  }

  KokoroStore<ChildState> store<ChildState>(ChildState Function(S) map) {
    return _store.child(map);
  }

  S get currentState => _store.currentState;

  void dispatch(action, [bool log = true]) {
    _store.dispatch(action, log);
  }

  S reduce(action, S oldState);

  //TODO: is lazy needed?
  E get handle;
}
