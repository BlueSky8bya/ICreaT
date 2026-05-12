import 'package:flutter/material.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class TitleRowWidget extends StatelessWidget {
  final String title;

  const TitleRowWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyles.body2.medium.primaryColor(context),
      ),
    );
  }
}
