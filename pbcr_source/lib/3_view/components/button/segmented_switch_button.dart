import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:icreat_dct/3_view/components/constants/box_shadows.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class SegmentedSwitchButton<T> extends StatefulWidget {
  final CustomSegmentedController<T>? controller;

  final T? initialValue;
  final List<T> items;
  final Function(T)? onValueChanged;

  final String Function(BuildContext context, T item)? textTransformer;

  final Color? backgroundColor;
  final Color? activeThumbColor;
  final Color? inactiveThumbColor;
  final Color? activeTextColor;
  final Color? inactiveTextColor;
  final Duration duration;

  const SegmentedSwitchButton({
    super.key,
    this.controller,
    this.initialValue,
    required this.items,
    this.onValueChanged,
    this.textTransformer,
    this.backgroundColor,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.activeTextColor,
    this.inactiveTextColor,
    this.duration = const Duration(milliseconds: 150),
  });

  @override
  State<SegmentedSwitchButton<T>> createState() =>
      _SegmentedSwitchButtonState<T>();
}

class _SegmentedSwitchButtonState<T> extends State<SegmentedSwitchButton<T>> {
  CustomSegmentedController<T>? _localController;

  CustomSegmentedController<T> get _controller =>
      widget.controller ?? _localController!;

  Color? _backgroundColor(BuildContext context) =>
      widget.backgroundColor ?? context.bgTertiary;

  Color? _activeTextColor(BuildContext context) =>
      widget.activeTextColor ?? context.textPrimary;

  Color? _inactiveTextColor(BuildContext context) =>
      widget.inactiveTextColor ?? context.textTertiary;

  Color? textColor(BuildContext context, T item) => _controller.value == item
      ? _activeTextColor(context)
      : _inactiveTextColor(context);

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      _localController = CustomSegmentedController<T>(
        value: widget.initialValue,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomSlidingSegmentedControl<T>(
      controller: _controller,
      initialValue: widget.initialValue,
      isStretch: true,
      children: widget.items.asMap().map(
            (index, item) => MapEntry(
              item,
              Text(
                widget.textTransformer?.call(context, item) ?? item.toString(),
                style:
                    TextStyles.body2.medium.fromColor(textColor(context, item)),
              ),
            ),
          ),
      decoration: BoxDecoration(
        color: _backgroundColor(context),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: 0,
      innerPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      height: 37,
      thumbDecoration: BoxDecoration(
        color: context.bgPrimary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: BoxShadows.shadow4,
      ),
      duration: widget.duration,
      curve: Curves.easeInToLinear,
      onValueChanged: (v) {
        setState(() {
          _controller.value = v;
        });
        widget.onValueChanged?.call(v);
      },
    );
  }
}
