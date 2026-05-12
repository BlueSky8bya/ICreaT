import 'package:flutter/material.dart';

import 'package:icreat_dct/3_view/components/box/outline_box_widget.dart';
import 'package:icreat_dct/8_extension/string_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';


class FormSelectMeasurementWidget extends StatelessWidget {
  final bool isReadOnly;
  final String? selectedAnswer;
  final Function(String) onChangeAnswer;
  final Function() onTap;
  final String? placeholder;
  final String? suffix;

  const FormSelectMeasurementWidget({
    super.key,
    required this.isReadOnly,
    required this.selectedAnswer,
    required this.onChangeAnswer,
    required this.onTap,
    this.placeholder,
    this.suffix,
  });

  bool get showPlaceholder => selectedAnswer.isNullOrEmpty && !placeholder.isNullOrEmpty;

  @override
  Widget build(BuildContext context) {
    return OutlineBoxWidget(
      onTap: isReadOnly ? null : () => onTap(),
      child: (showPlaceholder) ?
        Text(placeholder ?? "", style: TextStyles.body2.tertiaryColor(context)) :
        Row(
          spacing: 4,
          children: [
            Text(selectedAnswer ?? ''),
            Text(suffix ?? ''),
          ]
      ),
    );
  }
}