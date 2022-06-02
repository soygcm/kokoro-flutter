import 'package:kokoro/example/externals/position_external.dart';
import 'package:test/test.dart';

import 'package:kokoro/example/counter_app.dart';

class PositionExternalsLeak extends PositionExternals {
  Function() doSomething;

  PositionExternalsLeak(this.doSomething);

  @override
  Future<int> getIncrementalAmount() async {
    doSomething();
    return 4;
  }
}

void main() {
  group('Kokoro', () {
    test('initial state', () {
      final app = PositionApp();
      app.externals = PositionExternalsDemo();
      expect(app.currentState, equals(Position()));
    });

    test('handle events', () {
      final app = PositionApp();
      app.externals = PositionExternalsDemo();
      app.handle.clickUpButton();
      //
      expect(app.currentState.y, 1);
    });

    test('handle events async?', () async {
      final app = PositionApp();
      app.externals = PositionExternalsDemo();
      // final some = features.state.((event) {
      //   print(event);
      // });

      app.handle.onAppear();
      print("onAppear test");
      final firstState = await app.state.first;
      print("firstState = " + firstState.toString());
      final secondState = await app.state.first;

      expect(firstState.y, 1);
      expect(secondState.y, 2);
    });

    test('using externals leak', () async {
      Function()? some = () {
        print("Doing");
      };

      final app = PositionApp();
      app.externals = PositionExternalsLeak(() {
        some!();
      });
      // final some = features.state.((event) {
      //   print(event);
      // });
      some = null;
      some = () {
        print("Doing");
      };
      app.handle.onAppear();

      print("onAppear test");
      final firstState = await app.state.first;

      final secondState = await app.state.first;

      expect(firstState.y, 4);
      expect(secondState.y, 5);
    });
  });
}
