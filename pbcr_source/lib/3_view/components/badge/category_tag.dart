import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:icreat_dct/3_view/components/badge/badge_color.dart';
import 'package:icreat_dct/3_view/components/badge/badge_size.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';

class CategoryTag extends StatelessWidget {
  final String text;
  final EdgeInsets? padding;
  final Widget? prefix;
  final Widget? suffix;
  final double? borderRadius;
  final BadgeSize size;
  final BadgeColor color;
  final MainAxisAlignment? mainAxisAlignment;

  const CategoryTag({
    super.key,
    this.text = '',
    this.padding,
    this.prefix,
    this.suffix,
    this.size = BadgeSize.small,
    this.color = BadgeColor.grey,
    this.mainAxisAlignment,
    this.borderRadius,
  });

  factory CategoryTag.thumbnailTag(
    String text, {
    BadgeColor? color,
    Widget? prefix,
    MainAxisAlignment? mainAxisAlignment,
  }) {
    return CategoryTag(
      text: text,
      size: BadgeSize.small,
      color: color ?? BadgeColor.grey,
      prefix: prefix,
      mainAxisAlignment: mainAxisAlignment,
    );
  }

  Color _textColor(BuildContext context) => color.textColor(context);

  TextStyle? _textStyle(BuildContext context) {
    return size.textStyle(context).copyWith(color: _textColor(context)).medium;
  }

  EdgeInsets? get _padding {
    if (padding != null) return padding;
    return size.padding;
  }

  BoxDecoration? _decoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius ?? 4),
      color: color.backgroundColor(context),
    );
  }

  CategoryTag copyWith({
    String? text,
    Widget? prefix,
    Widget? suffix,
    BadgeSize? size,
    BadgeColor? color,
    EdgeInsets? padding,
    MainAxisAlignment? mainAxisAlignment,
  }) =>
      CategoryTag(
        text: text ?? this.text,
        prefix: prefix ?? this.prefix,
        suffix: suffix ?? this.suffix,
        size: size ?? this.size,
        color: color ?? this.color,
        padding: padding ?? this.padding,
        mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _padding,
      decoration: _decoration(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        children: [
          if (prefix != null) ...[
            SizedBox(
              width: size.iconSize,
              height: size.iconSize,
              child: prefix!,
            ),
            if (text.isNotEmpty) const SizedBox(width: 2),
          ],
          Text(
            text,
            style: _textStyle(context),
          ),
          if (suffix != null) ...[
            const SizedBox(width: 2),
            SizedBox(
              width: size.iconSize,
              height: size.iconSize,
              child: suffix!,
            ),
          ],
        ],
      ),
    );
  }
}

extension CategoryTagExt on CategoryTag {
  CategoryTag get small => copyWith(size: BadgeSize.small);
  CategoryTag get large => copyWith(size: BadgeSize.large);

  CategoryTag withSvgPrefix(BuildContext context, String svgPath) => copyWith(
        prefix: SvgPicture.asset(
          svgPath,
          colorFilter: ColorFilter.mode(_textColor(context), BlendMode.srcIn),
        ),
      );

  CategoryTag withSvgSuffix(BuildContext context, String svgPath) => copyWith(
        suffix: SvgPicture.asset(
          svgPath,
          colorFilter: ColorFilter.mode(_textColor(context), BlendMode.srcIn),
        ),
      );
}
