import 'package:flutter/material.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';

class LinearIndicator extends StatefulWidget {
  const LinearIndicator({
    super.key,
    required this.totalValue,
    required this.currentValue,
    this.thickness,
    this.fillColor,
    this.inActiveColor,
    this.borderRadius,
    this.gradientColors,
    this.isGradient = false,
    this.showPoint = false,
    this.repeatAnimation = false,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  final double totalValue;
  final double currentValue;
  final double? thickness;
  final Color? fillColor;
  final Color? inActiveColor;
  final double? borderRadius;
  final bool isGradient;
  final List<Color>? gradientColors;
  final bool showPoint;
  final bool repeatAnimation;
  final Duration animationDuration;

  factory LinearIndicator.withPercent({
    required double percent,
    double? thickness,
    Color? fillColor,
    Color? inActiveColor,
    double? borderRadius,
    List<Color>? gradientColors,
    bool isGradient = false,
    bool showPoint = false,
    bool repeatAnimation = false,
    Duration animationDuration = const Duration(milliseconds: 500),
  }) {
    return LinearIndicator(
      totalValue: 1,
      currentValue: percent,
      thickness: thickness,
      fillColor: fillColor,
      inActiveColor: inActiveColor,
      borderRadius: borderRadius,
      gradientColors: gradientColors,
      isGradient: isGradient,
      showPoint: showPoint,
      repeatAnimation: repeatAnimation,
      animationDuration: animationDuration,
    );
  }

  @override
  State<LinearIndicator> createState() => _LinearIndicatorState();
}

class _LinearIndicatorState extends State<LinearIndicator>
    with TickerProviderStateMixin {
  late AnimationController _animationCtrl;
  late Animation<double> _animation;
  Duration get _duration => widget.animationDuration;

  double get totalValue => widget.totalValue;
  double get currentValue => widget.currentValue;
  double get _percent {
    if (currentValue == 0) return 0;
    if (currentValue >= totalValue) return 1;
    return currentValue / totalValue;
  }

  double get _thickness => widget.thickness ?? 4;
  BorderRadius get _borderRadius =>
      BorderRadius.circular(widget.borderRadius ?? 0);

  @override
  void initState() {
    super.initState();
    _animationCtrl = AnimationController(
      vsync: this,
      duration: _duration,
    );

    setAnimation();

    if (_percent > 0) {
      activateAnimation();
    }
  }

  void setAnimation() {
    _animation = Tween<double>(begin: 0, end: _percent).animate(_animationCtrl)
      ..addListener(() {
        setState(() {});
      });
  }

  void activateAnimation() {
    if (widget.repeatAnimation) {
      _animationCtrl.repeat();
    } else {
      _animationCtrl.forward();
    }
  }

  @override
  void didUpdateWidget(covariant LinearIndicator oldWidget) {
    if ((oldWidget.totalValue == widget.totalValue) &&
        (oldWidget.currentValue == widget.currentValue)) {
      return;
    }

    setAnimation();
    _animationCtrl.reset();
    activateAnimation();

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.centerLeft,
      children: [
        Container(
          height: _thickness,
          decoration: BoxDecoration(
            color: widget.inActiveColor ?? context.bgTertiary,
            borderRadius: _borderRadius,
          ),
        ),
        FractionallySizedBox(
          widthFactor: _animation.value,
          child: Container(
            height: _thickness,
            decoration: BoxDecoration(
              color: widget.fillColor ?? context.bgBrand,
              borderRadius: _borderRadius,
              gradient: widget.isGradient
                  ? LinearGradient(
                      colors: widget.gradientColors ??
                          [
                            context.bgBrandSubtitle,
                            context.bgBrand,
                          ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
