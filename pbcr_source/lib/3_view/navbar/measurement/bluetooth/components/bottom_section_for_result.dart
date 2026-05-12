import 'package:flutter/material.dart';
import 'package:icreat_dct/3_view/components/constants/box_shadows.dart';
import 'package:icreat_dct/theme/color_hue.dart';

class BottomSectionForResult extends StatelessWidget {
  const BottomSectionForResult({
    super.key,
    required this.onTapSave,
    required this.onTapRetry,
    this.retryText = '다시 측정',
    this.isDisconnected = true,
  });

  final GestureTapCallback? onTapSave;
  final GestureTapCallback onTapRetry;
  final String retryText;
  final bool isDisconnected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: ColorHue.white,
        boxShadow: BoxShadows.shadow2,
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
        top: 16,
      ),
      child: Row(
        spacing: 16,
        children: [
          if (isDisconnected)
            Expanded(
              child: ElevatedButton(
                onPressed: onTapRetry,
                child: Text(retryText),
              ),
            ),
          Expanded(
            child: ElevatedButton(
              onPressed: onTapSave,
              child: Text('저장'),
            ),
          ),
        ],
      ),
    );
  }
}
