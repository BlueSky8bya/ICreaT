import 'package:flutter/material.dart';
import 'package:icreat_dct/3_view/components/button/alt_gesture_detector.dart';

class OpacityWidgetButton extends StatefulWidget {
  const OpacityWidgetButton({
    super.key,
    this.onTap,
    this.onDoubleTap,
    this.debounceTime,
    this.useFastDoubleTap = false,
    required this.child,
  });

  final void Function(BuildContext context)? onTap;
  final void Function(BuildContext context)? onDoubleTap;
  final int? debounceTime;
  final bool useFastDoubleTap;

  final Widget child;

  factory OpacityWidgetButton.noDebounce({
    void Function(BuildContext context)? onTap,
    void Function(BuildContext context)? onDoubleTap,
    bool useFastDoubleTap = false,
    required Widget child,
  }) {
    return OpacityWidgetButton(
      debounceTime: 0,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      useFastDoubleTap: useFastDoubleTap,
      child: child,
    );
  }

  @override
  State<OpacityWidgetButton> createState() => _OpacityWidgetButtonState();

  OpacityWidgetButton copyWith({
    void Function(BuildContext context)? onTap,
    int? debounceTime,
    Widget? child,
  }) {
    return OpacityWidgetButton(
      onTap: onTap ?? this.onTap,
      debounceTime: debounceTime ?? this.debounceTime,
      child: child ?? this.child,
    );
  }
}

class _OpacityWidgetButtonState extends State<OpacityWidgetButton> {
  bool onTapped = false;

  late int? debounceTime = widget.debounceTime ?? 600;
  DateTime? _lastClickTime;

  _debounceTap(BuildContext context) {
    final now = DateTime.now();
    if (_lastClickTime == null) {
      _lastClickTime = now;
      _click(context);
    } else {
      if (now.difference(_lastClickTime!).inMilliseconds > debounceTime!) {
        _lastClickTime = now;
        _click(context);
      }
    }
  }

  void _click(BuildContext context) {
    widget.onTap?.call(context);
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.onTap == null ? 1 : (onTapped ? 0.6 : 1),
      child: widget.useFastDoubleTap
          ? AltGestureDetector(
              onTap: widget.onTap == null
                  ? null
                  : () => _debounceTap.call(context),
              onTapDown: (_) => _changeHighlightColor(true),
              onTapUp: (_) => _changeHighlightColor(false),
              onTapCancel: () => _changeHighlightColor(false),
              onDoubleTap: () => _doubleTap(context),
              child: widget.child,
            )
          : GestureDetector(
              onTap: widget.onTap == null
                  ? null
                  : () => _debounceTap.call(context),
              onTapDown: (_) => _changeHighlightColor(true),
              onTapUp: (_) => _changeHighlightColor(false),
              onTapCancel: () => _changeHighlightColor(false),
              onDoubleTap:
                  widget.onDoubleTap != null ? () => _doubleTap(context) : null,
              child: widget.child,
            ),
    );
  }

  void _changeHighlightColor(bool isHighlight) {
    setState(() => onTapped = isHighlight);
  }

  void _doubleTap(BuildContext context) {
    widget.onDoubleTap?.call(context);
  }
}
