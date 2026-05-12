import 'package:flutter/material.dart';

class MiddleRangeLinearIndicator extends StatelessWidget {
  final double totalValue;
  final double startValue;
  final double endValue;

  final double thickness;
  final Color backgroundColor;
  final Color foregroundColor;

  const MiddleRangeLinearIndicator({
    super.key,
    required this.totalValue,
    required this.startValue,
    required this.endValue,
    this.thickness = 16,
    this.backgroundColor = Colors.grey,
    this.foregroundColor = Colors.blue,
  }) : assert(totalValue > 0, 'totalValue는 0보다 커야 합니다.');

  double get indicatorStartFraction => startValue / totalValue;
  double get indicatorWidthFraction => (endValue - startValue) / totalValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: thickness,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final startPosition = constraints.maxWidth * indicatorStartFraction;
          final width = constraints.maxWidth * indicatorWidthFraction;

          return Stack(
            children: [
              Container(
                width: constraints.maxWidth,
                height: thickness,
                color: backgroundColor,
              ),
              Positioned(
                left: startPosition,
                child: Container(
                  width: width,
                  height: thickness,
                  color: foregroundColor,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
