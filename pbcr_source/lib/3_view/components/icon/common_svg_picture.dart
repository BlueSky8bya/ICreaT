import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/theme_color.dart';

class CommonSvgPicture extends StatelessWidget {
  final String svgPath;
  final double? size;
  final BoxFit? fit;

  /// 색상을 지정하지 않으면 테마의 아이콘 색상을 따름
  final Color? color;

  /// 색상 우선 순위 themeColor > color > 테마의 아이콘 색상
  final ThemeColor? themeColor;
  final EdgeInsetsGeometry? padding;

  final bool showBadge;
  final bool useOriginalColor;

  const CommonSvgPicture(
    this.svgPath, {
    super.key,
    this.size,
    this.fit,
    this.color,
    this.themeColor,
    this.padding,
    this.showBadge = false,
    this.useOriginalColor = false,
  });

  @override
  Widget build(BuildContext context) {
    Color? iconColor;

    if (useOriginalColor) {
      iconColor = null;
    } else {
      iconColor = themeColor?.getColor(context) ??
          color ??
          Theme.of(context).iconTheme.color;
    }

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset(
            svgPath,
            width: size ?? 20,
            height: size ?? 20,
            fit: fit ?? BoxFit.contain,
            colorFilter: iconColor != null
                ? ColorFilter.mode(
                    iconColor,
                    BlendMode.srcIn,
                  )
                : null,
          ),
          if (showBadge)
            Positioned(
              right: 0,
              top: 2,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: context.textDanger,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
