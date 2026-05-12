import 'dart:async';

import 'package:flutter/material.dart';

class CMNThrottler {
  final Duration duration;
  Timer? _timer;

  bool _isReady = true;

  CMNThrottler({
    this.duration = const Duration(milliseconds: 300),
  });

  run(VoidCallback action) {
    if (_isReady) {
      _isReady = false;
      action();

      _timer = Timer(duration, () {
        _timer = null;
        _isReady = true;
      });
    }
  }

  close() {
    _timer?.cancel();
    _timer = null;
  }
}
