import 'package:flutter/material.dart';

/// 싱글탭과 더블탭을 같이 쓸 경우
/// 싱글탭의 속도를 빠르게 하기 위한 GestureDetector
class AltGestureDetector extends StatefulWidget {
  final GestureTapCallback? onTap;
  final GestureTapCallback? onDoubleTap;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCallback? onTapCancel;

  final Duration doubleTapTime;

  final Widget child;

  const AltGestureDetector({
    super.key,
    this.onTap,
    this.onDoubleTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.doubleTapTime = const Duration(milliseconds: 300),
    required this.child,
  });

  @override
  State<AltGestureDetector> createState() => _AltGestureDetectorState();
}

class _AltGestureDetectorState extends State<AltGestureDetector> {
  int _lastClickMs = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) {
        int currMills = DateTime.now().millisecondsSinceEpoch;
        if (_isDoubleTap(currMills)) {
          _doubleTap();
        } else {
          _lastClickMs = currMills;
          _singleTap();
        }

        widget.onTapDown?.call(details);
      },
      onTapUp: widget.onTapUp,
      onTapCancel: widget.onTapCancel,
      child: widget.child,
    );
  }

  bool _isDoubleTap(int currMills) {
    return (currMills - _lastClickMs) < widget.doubleTapTime.inMilliseconds;
  }

  void _singleTap() {
    widget.onTap?.call();
  }

  void _doubleTap() {
    widget.onDoubleTap?.call();
  }
}
