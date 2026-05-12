import 'package:flutter/material.dart';

import 'package:icreat_dct/3_view/components/button/solid_button.dart';
import 'package:icreat_dct/3_view/data/async_state.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class LoadingStatusWidget extends StatelessWidget {
  final AsyncState status;
  final Widget child;
  final Widget Function(BuildContext)? onLoadingBuilder;
  final Widget Function(BuildContext)? onErrorBuilder;

  final VoidCallback? onRefresh;

  const LoadingStatusWidget({
    super.key,
    required this.status,
    required this.child,
    this.onLoadingBuilder,
    this.onErrorBuilder,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (status == AsyncState.loading || status == AsyncState.initial) {
      return onLoadingBuilder?.call(context) ??
          Center(
            child: CircularProgressIndicator(color: context.bgBrand),
          );
    }

    if (status == AsyncState.error) {
      return onErrorBuilder?.call(context) ??
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '문제가 발생했습니다.',
                  style: TextStyles.body1.semiBold,
                ),
                const SizedBox(height: 8),
                Text(
                  '문제가 발생하여 현재 데이터를 불러오지 못했습니다.',
                  style: TextStyles.body2.secondaryColor(context),
                ),
                const SizedBox(height: 16),
                SolidButton(
                  text: '새로고침',
                  onTap: onRefresh,
                ).expand
              ],
            ),
          );
    }

    return child;
  }
}
