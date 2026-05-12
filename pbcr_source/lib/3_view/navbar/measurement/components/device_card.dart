import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icreat_dct/3_view/components/constants/svg_icons.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class DeviceCard extends StatelessWidget {
  final SvgIcons svgIcon;
  final String label;

  final VoidCallback onTap;

  const DeviceCard({
    super.key,
    required this.svgIcon,
    required this.label,
    required this.onTap,
  });

  factory DeviceCard.bloodPressure(VoidCallback onTap) {
    return DeviceCard(
      svgIcon: SvgIcons.bloodPressure,
      label: '혈압',
      onTap: onTap,
    );
  }

  factory DeviceCard.thermometer(VoidCallback onTap) {
    return DeviceCard(
      svgIcon: SvgIcons.thermometer,
      label: '체온',
      onTap: onTap,
    );
  }

  factory DeviceCard.weight(VoidCallback onTap) {
    return DeviceCard(
      svgIcon: SvgIcons.weight,
      label: '몸무게',
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.bgPrimary,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.borderPrimary,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 8,
              children: [
                SvgPicture.asset(
                  svgIcon.svgPath,
                  width: 36,
                  height: 36,
                ),
                Text(
                  label,
                  style: TextStyles.body1.semiBold.primaryColor(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
