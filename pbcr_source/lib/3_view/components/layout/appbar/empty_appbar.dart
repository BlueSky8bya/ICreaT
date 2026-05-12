import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EmptyAppBar({
    super.key,
    required this.backgroundColor,
  });
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: backgroundColor),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(0);
}