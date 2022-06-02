import 'package:flutter/widgets.dart';
import 'package:kokoro/kokoro.dart';

//inspired on https://github.com/brianegan/flutter_redux/blob/master/lib/flutter_redux.dart

class AppProviderError<S> extends Error {
  /// Creates a StoreProviderError
  AppProviderError();

  @override
  String toString() {
    return '''Error: No $S found. To fix, please try:
          
  * Wrapping your MaterialApp with the StoreProvider<State>, 
  rather than an individual Route
  * Providing full type information to your Store<State>, 
  StoreProvider<State> and StoreConnector<State, ViewModel>
  * Ensure you are using consistent and complete imports. 
  E.g. always use `import 'package:my_app/app_state.dart';
  
If none of these solutions work, please file a bug at:
https://github.com/brianegan/flutter_redux/issues/new
      ''';
  }
}

class AppProvider<S, E> extends InheritedWidget {
  final Kokoro<S, E> _app;

  /// Create a [AppProvider] by passing in the required [store] and [child]
  /// parameters.
  const AppProvider({
    Key? key,
    required Kokoro<S, E> app,
    required Widget child,
  })  : _app = app,
        super(key: key, child: child);

  /// A method that can be called by descendant Widgets to retrieve the Store
  /// from the StoreProvider.
  ///
  /// Important: When using this method, pass through complete type information
  /// or Flutter will be unable to find the correct StoreProvider!
  ///
  /// ### Example
  ///
  /// ```
  /// class MyWidget extends StatelessWidget {
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     final store = StoreProvider.of<int>(context);
  ///
  ///     return Text('${store.state}');
  ///   }
  /// }
  /// ```
  ///
  /// If you need to use the [Store] from the `initState` function, set the
  /// [listen] option to false.
  ///
  /// ### Example
  ///
  /// ```
  /// class MyWidget extends StatefulWidget {
  ///   static GlobalKey<_MyWidgetState> captorKey = GlobalKey<_MyWidgetState>();
  ///
  ///   MyWidget() : super(key: captorKey);
  ///
  ///   _MyWidgetState createState() => _MyWidgetState();
  /// }
  ///
  /// class _MyWidgetState extends State<MyWidget> {
  ///   Store<String> store;
  ///
  ///   @override
  ///   void initState() {
  ///     super.initState();
  ///     store = StoreProvider.of<String>(context, listen: false);
  ///   }
  ///
  ///   @override
  ///  Widget build(BuildContext context) {
  ///     return Container();
  ///   }
  /// }
  /// ```
  static Kokoro<S, E> of<S, E>(BuildContext context, {bool listen = true}) {
    final provider = (listen
        ? context.dependOnInheritedWidgetOfExactType<AppProvider<S, E>>()
        : context
            .getElementForInheritedWidgetOfExactType<AppProvider<S, E>>()
            ?.widget) as AppProvider<S, E>?;

    if (provider == null) throw AppProviderError<AppProvider<S, E>>();

    return provider._app;
  }

  @override
  bool updateShouldNotify(AppProvider<S, E> oldWidget) =>
      _app != oldWidget._app;
}
