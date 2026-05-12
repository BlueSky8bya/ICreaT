import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BouncingScrollView extends StatelessWidget {
  const BouncingScrollView({
    super.key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.padding,
    bool? primary,
    this.physics,
    this.controller,
    this.child,
    this.dragStartBehavior = DragStartBehavior.start,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  })  : primary = primary ??
            controller == null && identical(scrollDirection, Axis.vertical);

  final Axis scrollDirection;
  final bool reverse;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final bool primary;
  final ScrollPhysics? physics;
  final Widget? child;
  final DragStartBehavior dragStartBehavior;
  final Clip clipBehavior;
  final String? restorationId;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: physics ?? const BouncingScrollPhysics(),
      scrollDirection: scrollDirection,
      reverse: reverse,
      padding: padding,
      controller: controller,
      primary: primary,
      dragStartBehavior: dragStartBehavior,
      clipBehavior: clipBehavior,
      restorationId: restorationId,
      keyboardDismissBehavior: keyboardDismissBehavior,
      child: child,
    );
  }
}
