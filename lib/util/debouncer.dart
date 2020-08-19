import 'dart:async';

import 'package:dio/dio.dart';

class Debouncer {
  final Duration delay;
  Timer _timer;

  Debouncer(this.delay);

  call(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }
}
