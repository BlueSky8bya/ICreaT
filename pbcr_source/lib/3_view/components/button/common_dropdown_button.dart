import 'package:flutter/material.dart';
import 'package:icreat_dct/9_contants/box_decorations.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';

class CommonDropdownButton<T> extends StatelessWidget {
  const CommonDropdownButton({
    super.key,
    this.radius,
    this.padding,
    required this.value,
    this.onChanged,
    this.items,
  });

  // UI

  final double? radius;
  final EdgeInsetsGeometry? padding;

  // Data

  final T value;
  final void Function(T?)? onChanged;
  final List<DropdownMenuItem<T>>? items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecorations.borderBox(
        context,
        borderRadius: BorderRadius.circular(radius ?? 0),
      ),
      child: DropdownButton<T>(
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        value: value,
        onChanged: onChanged,
        isDense: true,
        isExpanded: true,
        iconEnabledColor: context.iconPrimary,
        icon: Icon(
          Icons.arrow_drop_down,
          color: context.iconDisabled,
        ),
        // icon: NewSvgIconType.arrowDown
        //     .svgIconBuilder(size: 20, color: ColorHue.greyscale7),
        alignment: Alignment.centerLeft,
        underline: const SizedBox.shrink(),
        elevation: 1,
        items: items,
      ),
    );
  }
}
