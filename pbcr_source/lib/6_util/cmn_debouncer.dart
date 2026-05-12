import 'dart:async';

import 'package:flutter/material.dart';

class CMNDebouncer {
  final Duration duration;
  Timer? _timer;

  CMNDebouncer({this.duration = const Duration(milliseconds: 300)});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  close() {
    _timer?.cancel();
    _timer = null;
  }
}