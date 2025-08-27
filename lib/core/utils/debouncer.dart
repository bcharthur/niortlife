import 'dart:async';

/// Simple Debouncer utility.
/// Usage:
///   final _debounce = Debouncer(milliseconds: 300);
///   _debounce(() { /* your code */ });
class Debouncer {
  Debouncer({this.milliseconds = 300});
  final int milliseconds;
  Timer? _timer;

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}