//import 'dart:ui';
import 'package:kokoro/kokoro.dart';
import 'package:kokoro/kokoro_store.dart';

abstract class PositionExternals {
  Future<int> getIncrementalAmount();
}

class Position {
  int x;
  int y;

  Position([this.x = 0, this.y = 0]);

  Position copyWith({int? x, int? y}) => Position(x ?? this.x, y ?? this.y);

  @override
  operator ==(other) {
    return other is Position && x == other.x && y == other.y;
  }

  //@override
  //int get hashCode => hashValues(x, y);
}

class PositionEvents {
  EmptyUIEvent clickUpButton;
  EmptyUIEvent onAppear;

  PositionEvents({required this.clickUpButton, required this.onAppear});
}

class MoveUp {
  int amount;

  MoveUp([this.amount = 1]);
}

class PositionApp extends Kokoro<Position, PositionEvents> {
  PositionApp([KokoroStore<Position>? store]) : super(Position(), store);

  late PositionExternals externals;

  //TODO: handler vs handle
  @override
  get handle => PositionEvents(clickUpButton: () {
        dispatch(MoveUp());
      }, onAppear: () async {
        final amount = await externals.getIncrementalAmount();
        dispatch(MoveUp(amount));
        await Future.delayed(const Duration(seconds: 1));
        dispatch(MoveUp());
      });

  @override
  reduce(action, oldState) {
    if (action is MoveUp) {
      return oldState.copyWith(y: oldState.y + action.amount);
    }
    return oldState;
  }
}
