import 'dart:async';

import '../kokoro.dart';

extension StreamKokoro<State> on Kokoro<State, dynamic> {
  StreamSubscription listenAndDispatch(
    dynamic Function(State state) convert,
    Function(dynamic state) action,
  ) {
    dispatch(action(convert(currentState)));
    return state.map(convert).distinct().listen((state) {
      dispatch(action(state));
    });
  }

  StreamSubscription listenAndDo(
    dynamic Function(State state) convert,
    Function action,
  ) {
    action();
    return state.map(convert).distinct().listen((state) {
      action();
    });
  }
}
