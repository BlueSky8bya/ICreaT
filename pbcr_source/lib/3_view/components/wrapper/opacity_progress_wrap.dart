import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:icreat_dct/3_view/components/loading/loading_view.dart';
import 'package:icreat_dct/3_view/components/base_view_model.dart';

class OpacityProgressWrap extends StatelessWidget {
  final Widget child;
  final BaseViewModel controller;
  final double opacity;

  const OpacityProgressWrap({
    super.key,
    required this.child,
    required this.controller,
    this.opacity = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Obx(
      () => Stack(
        children: [
          child,
          if (controller.isOnProgress.value)
            Container(
              width: w,
              height: h,
              color: Colors.black.withValues(alpha: opacity),
              child: LoadingView.indicatorDark(),
            ),
        ],
      ),
    );
  }
}
