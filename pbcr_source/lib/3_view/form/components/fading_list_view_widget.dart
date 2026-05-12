import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FadingListViewWidget extends StatefulWidget {
  final List<Widget> children;
  final double threshold;

  const FadingListViewWidget({
    super.key,
    required this.children,
    this.threshold = 50.0,
  });

  @override
  State<FadingListViewWidget> createState() => _FadingListViewWidget();
}

class _FadingListViewWidget extends State<FadingListViewWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _fadeVisibleBottom = false;
  bool _fadeVisibleTop = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFades();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateFades() {
    if (!mounted || !_scrollController.hasClients) return;
    final position = _scrollController.position;
    _updateFadesWithMetrics(position.pixels, position.maxScrollExtent);
  }

  void _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification || notification is ScrollEndNotification) {
      _updateFadesWithMetrics(notification.metrics.pixels, notification.metrics.maxScrollExtent);
    }
  }

  void _updateFadesWithMetrics(double pixels, double maxScrollExtent) {
    final newFadeVisibleTop = pixels > 0;
    final newFadeVisibleBottom = maxScrollExtent > 0 && (pixels < maxScrollExtent - widget.threshold);

    if (newFadeVisibleTop != _fadeVisibleTop || newFadeVisibleBottom != _fadeVisibleBottom) {
      if (mounted) {
        setState(() {
          _fadeVisibleTop = newFadeVisibleTop;
          _fadeVisibleBottom = newFadeVisibleBottom;
        });
      }
    }
  }

  Widget _buildFadeOverlay({
    required bool isVisible,
    required Alignment begin,
    required Alignment end,
    double? top,
    double? bottom,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: IgnorePointer(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: begin,
                end: end,
                colors: const [
                  Colors.transparent,
                  Colors.black26,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            _handleScrollNotification(notification);
            return false;
          },
          child: NotificationListener<SizeChangedLayoutNotification>(
            onNotification: (notification) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _updateFades();
              });
              return false;
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: SizeChangedLayoutNotifier(
                child: Column(
                  children: widget.children,
                ),
              ),
            ),
          ),
        ),
        _buildFadeOverlay(
          isVisible: _fadeVisibleTop,
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          top: 0,
        ),
        _buildFadeOverlay(
          isVisible: _fadeVisibleBottom,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          bottom: 0,
        ),
      ],
    );
  }
}

//--- Helper Widgets ---

class SizeChangedLayoutNotification extends Notification {}

class SizeChangedLayoutNotifier extends SingleChildRenderObjectWidget {
  const SizeChangedLayoutNotifier({
    super.key,
    super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _SizeChangedRenderObject(context);
  }
}

class _SizeChangedRenderObject extends RenderProxyBox {
  _SizeChangedRenderObject(this.context, [RenderBox? child]) : super(child);

  final BuildContext context;
  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    if (size != _oldSize) {
      _oldSize = size;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SizeChangedLayoutNotification().dispatch(context);
      });
    }
  }
}
