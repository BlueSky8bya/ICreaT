import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/3_view/components/loading/loading_view.dart';
import 'package:icreat_dct/3_view/components/base_view_model.dart';


class ProgressWrap extends StatelessWidget {
  final Widget child;
  final BaseViewModel controller;

  const ProgressWrap({
    super.key,
    required this.controller,
    required this.child,
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
              decoration: const BoxDecoration(
                color: LoadingView.loadingBackgroundColor,
              ),
              child: LoadingView.indicatorDark(),
            )
        ],
      ),
    );
  }
}
