import 'package:kokoro/example/counter_app.dart';

class PositionExternalsDemo extends PositionExternals {
  @override
  Future<int> getIncrementalAmount() async {
    return 1;
  }
}
