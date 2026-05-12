import 'package:flutter/material.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';

/// 날짜 하단에 선을 그려서 주단위를 구분하기 위해 사용하는 위젯
class MonthlyBaseDayTile extends StatelessWidget {
  final Widget child;

  const MonthlyBaseDayTile({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 1,
            color: context.borderPrimary,
          ),
        ),
        child,
      ],
    );
  }
}
