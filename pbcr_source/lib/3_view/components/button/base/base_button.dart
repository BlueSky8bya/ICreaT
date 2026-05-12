import 'package:flutter/material.dart';
import 'package:icreat_dct/6_util/cmn_throttler.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';

class BaseButton extends StatefulWidget {
  const BaseButton({
    super.key,
    this.throttleTime,
    this.onTap,
    this.color,
    this.highlightColor,
    this.borderColor,
    this.highlightBorderColor,
    this.disabledOpacity,
    this.borderRadius,
    this.isOutline = false,
    required this.child,
  });

  final int? throttleTime;
  final VoidCallback? onTap;
  final Color? color;
  final Color? highlightColor;
  final Color? borderColor;
  final Color? highlightBorderColor;
  final double? disabledOpacity;
  final double? borderRadius;
  final bool isOutline;
  final Widget child;

  @override
  State<BaseButton> createState() => _BaseButtonState();
}

class _BaseButtonState extends State<BaseButton> {
  late final CMNThrottler _throttler;
  bool _showHighlightColor = false;

  bool get _isEnabled => widget.onTap != null;

  Color get _color => widget.color ?? context.bgBrand;
  Color get _highlightColor =>
      widget.highlightColor ?? context.bgBrandHoverPressed;
  Color get _borderColor => widget.borderColor ?? context.bgBrand;
  Color get _highlightBorderColor =>
      widget.highlightBorderColor ?? context.bgBrandHoverPressed;

  Color get _curDecoColor =>
      _showHighlightColor && _isEnabled ? _highlightColor : _color;

  Color get _curDecoBorderColor =>
      _showHighlightColor && _isEnabled ? _highlightBorderColor : _borderColor;

  static const _defaultDisabledOpacity = 0.3;

  double get _disabledOpacity =>
      widget.disabledOpacity ?? _defaultDisabledOpacity;

  BorderRadius get _borderRadius =>
      BorderRadius.circular(widget.borderRadius ?? 8);

  int get _throttleTime => widget.throttleTime ?? 300;

  @override
  void initState() {
    super.initState();

    _throttler = CMNThrottler(
      duration: Duration(milliseconds: _throttleTime),
    );
  }

  @override
  void dispose() {
    _throttler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _isEnabled ? 1 : _disabledOpacity,
      child: GestureDetector(
        onTap: _throttleTap,
        onTapDown: (_) => _changeHighlightColor(true),
        onTapUp: (_) => _changeHighlightColor(false),
        onTapCancel: () => _changeHighlightColor(false),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _curDecoColor,
            border: widget.isOutline
                ? Border.all(color: _curDecoBorderColor)
                : null,
            borderRadius: _borderRadius,
          ),
          child: widget.child,
        ),
      ),
    );
  }

  void _changeHighlightColor(bool isHighlight) {
    if (!_isEnabled) return;
    setState(() => _showHighlightColor = isHighlight);
  }

  void _throttleTap() {
    _throttler.run(_click);
  }

  void _click() {
    widget.onTap?.call();
  }
}
