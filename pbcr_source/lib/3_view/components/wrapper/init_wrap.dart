import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icreat_dct/3_view/components/loading/loading_view.dart';
import 'package:icreat_dct/3_view/components/base_view_model.dart';

/// Widget child가 아니라 함수를 받아서 렌더링하는 이유는
/// 비동기 처리 후 렌더링 시점의 데이터를 사용해야하기 때문
/// 만약 Widget child를 받으면 위젯이 맨처음 생성되는 시점의 데이터를 사용하게 되기 때문에 비동기 시작전 데이터를 그대로 사용하게 됨
/// 예를 들면 List data를 받아서 사용할 경우 Widget child를 받으면 초기의 data를 그대로 사용하는 위젯이 선언되어버려 고정되지만
/// 함수를 받으면 렌더링 시점에 builder 함수가 실행되어 최신 데이터를 사용할 수 있음

class InitWrap extends StatelessWidget {
  final BaseViewModel controller;
  final Widget? progressWidget;

  final Widget Function() builder;

  const InitWrap({
    super.key,
    required this.controller,
    this.progressWidget,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Obx(
      () => controller.completedInit.value
          ? builder()
          : Scaffold(
              body: progressWidget ??
                  Container(
                    width: w,
                    height: h,
                    decoration: const BoxDecoration(
                      color: LoadingView.loadingBackgroundColor,
                    ),
                    child: LoadingView.indicatorDark(),
                  ),
            ),
    );
  }
}
