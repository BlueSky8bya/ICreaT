import 'package:flutter/widgets.dart';

class PageIndicator extends StatefulWidget {
  final PageController controller;
  final int pageCount;
  final double pageSpacing;
  final double cursorHeight;
  final Color? activeColor;

  const PageIndicator({
    super.key,
    required this.controller,
    required this.pageCount,
    this.activeColor,
    this.cursorHeight = 10,
    this.pageSpacing = 2,
  });
  @override
  State<PageIndicator> createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  double cursorWidth = 0;
  double cursorPosition = 0;

  void setCursorWidth(double maxWidth) {
    if (widget.pageCount == 0) {
      cursorWidth = 0;
      return;
    }
    cursorWidth = (maxWidth - (widget.pageSpacing * (widget.pageCount - 1))) /
        widget.pageCount;
  }

  void _updateCursorPosition() {
    final pageIndex = widget.controller.page ?? 0;
    setState(() {
      cursorPosition = _calculateCursorPosition(pageIndex);
    });
  }

  double _calculateCursorPosition(double pageIndex) {
    final spacing = widget.pageSpacing * pageIndex;
    return pageIndex * cursorWidth + spacing;
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateCursorPosition);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateCursorPosition);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        setCursorWidth(width);
        return SizedBox(
          height: widget.cursorHeight,
          child: Stack(
            children: [
              Positioned(
                left: cursorPosition,
                bottom: 0,
                child: Container(
                  width: cursorWidth,
                  height: widget.cursorHeight,
                  color: widget.activeColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
