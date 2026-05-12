import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';

class ToggleButton extends StatefulWidget {
  final bool isSelected;
  final Function()? onToggle;
  final double? toggleSize;
  final double? width;
  final double? height;
  final double? padding;
  final Widget? activeIcon;
  final Widget? inactiveIcon;

  /// 버튼 true 색상
  final Color? activeColor;

  /// 버튼 false 색상
  final Color? inactiveColor;

  /// 버튼 동그라미 색상
  final Color? toggleColor;

  /// 비활성화 상태일 때 색상
  final Color? disabledColor;

  /// 비활성화 상태일 때 동그라미 색상
  final Color? disabledToggleColor;

  const ToggleButton({
    super.key,
    required this.isSelected,
    this.onToggle,
    this.toggleSize,
    this.width,
    this.height,
    this.padding,
    this.activeIcon,
    this.inactiveIcon,
    this.activeColor,
    this.inactiveColor,
    this.toggleColor,
    this.disabledColor,
    this.disabledToggleColor,
  });

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  bool _isHover = false;
  bool get _isDisabled => widget.onToggle == null;

  bool get _isSelected => !_isDisabled && widget.isSelected;

  void onToggle(bool value) {
    if (_isDisabled) return;
    widget.onToggle?.call();
  }

  List<BoxShadow>? _boxShadow(BuildContext context) {
    if (_isDisabled) return null;
    if (_isHover) {
      if (_isSelected) {
        return [
          BoxShadow(
            offset: const Offset(0, 0),
            color: _activeColor(context).withValues(alpha:  0.1),
            spreadRadius: 3,
          ),
        ];
      } else {
        return [
          BoxShadow(
            offset: const Offset(0, 0),
            color: _inactiveColor(context).withValues(alpha: .1),
            spreadRadius: 3,
          ),
        ];
      }
    }

    return null;
  }

  Color _disabledColor(BuildContext context) =>
      widget.disabledToggleColor ?? context.bgDisabled;

  Color _disabledToggleColor(BuildContext context) =>
      widget.disabledToggleColor ?? context.iconDisabled;

  Color _activeColor(BuildContext context) {
    if (_isDisabled) {
      return _disabledColor(context);
    }
    if (widget.activeColor != null) return widget.activeColor!;
    return context.bgSuccess;
  }

  // Brightness 전환 중 전역 Context를 사용하면 변경 완료될 때 변경된 밝기로 바뀌지 않는다.
  // 그래서 전역 Context를 사용하지 않고, 각각의 Context를 사용하도록 수정해야 한다.
  Color _inactiveColor(BuildContext context) {
    if (_isDisabled) {
      return _disabledColor(context);
    }
    if (widget.inactiveColor != null) return widget.inactiveColor!;
    return context.bgTertiary;
  }

  Color _toggleColor(BuildContext context) {
    if (_isDisabled) {
      return _disabledToggleColor(context);
    }

    return context.iconInverse;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isHover = true),
      onTapUp: (_) => setState(() => _isHover = false),
      onTapCancel: () => setState(() => _isHover = false),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: _boxShadow(context),
          borderRadius: BorderRadius.circular(20),
        ),
        child: FlutterSwitch(
          value: _isSelected,
          onToggle: onToggle,
          disabled: _isDisabled,
          activeColor: _activeColor(context),
          inactiveColor: _inactiveColor(context),
          toggleColor: _toggleColor(context),
          toggleSize: widget.toggleSize ?? 16,
          padding: widget.padding ?? 2,
          width: widget.width ?? 36,
          height: widget.height ?? 20,
          activeIcon: widget.activeIcon,
          inactiveIcon: widget.inactiveIcon,
        ),
      ),
    );
  }
}
