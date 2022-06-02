import 'package:flutter/widgets.dart';
import 'package:kokoro/kokoro.dart';

typedef AsyncWidgetBuilderKokoro<T> = Widget Function(
    BuildContext context, T data);

extension FlutterKokoro<S, E> on Kokoro<S, E> {
  StreamBuilder<T> stateBuilder<T>(
    T Function(S) map, {
    Key? key,
    T? initialState,
    bool log = false,
    required AsyncWidgetBuilderKokoro<T> builder,
  }) {
    final initialData = initialState ?? map(currentState);
    return StreamBuilder<T>(
      key: key,
      initialData: initialData,
      stream: state.map(map).distinct((one, two) {
        if (log) {
          print("------ stateBuilder.equals $one $two ${one == two}");
        }
        return one == two;
      }),
      builder: (
        BuildContext context,
        AsyncSnapshot<T> snapshot,
      ) {
        if (log) {
          print("------ stateBuilder ${snapshot.data ?? initialData}");
        }
        return builder(context, snapshot.data ?? initialData);
      },
    );
  }

  StreamBuilder<T> streamBuilder<T>(
    T Function(S) map, {
    Key? key,
    T? initialState,
    bool log = false,
    required AsyncWidgetBuilder<T> builder,
  }) {
    final initialData = initialState ?? map(currentState);
    return StreamBuilder<T>(
      key: key,
      initialData: initialData,
      stream: state.map(map).distinct((one, two) {
        if (log) {
          print("------ streamBuilder.equals $one $two ${one == two}");
        }
        return one == two;
      }),
      builder: (
        BuildContext context,
        AsyncSnapshot<T> snapshot,
      ) {
        if (log) {
          print("------ streamBuilder ${snapshot.data ?? initialData}");
        }
        return builder(context, snapshot);
      },
    );
  }
}
