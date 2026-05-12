import 'package:flutter/material.dart';
import 'package:icreat_dct/3_view/components/constants/box_shadows.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';

class ShadowBoxWidget extends StatelessWidget {
  final Widget child;

  const ShadowBoxWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: BoxShadows.shadow4,
        color: context.bgPrimary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}
