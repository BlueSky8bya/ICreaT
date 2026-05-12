import 'package:flutter/material.dart';
import 'package:icreat_dct/3_view/components/layout/appbar/empty_appbar.dart';

class SafeScaffold extends StatelessWidget {
  const SafeScaffold({
    super.key,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.statusBarColor,
    this.backgroundColor,
    this.enableBottomSafeArea = true,
    required this.child,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
  });
  
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget child;
  final Color? statusBarColor;
  final Color? backgroundColor;
  final bool enableBottomSafeArea;
  final Widget? bottomNavigationBar;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ??
          EmptyAppBar(
              backgroundColor:
                  statusBarColor ?? Theme.of(context).scaffoldBackgroundColor),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor,
      body: SafeArea(bottom: enableBottomSafeArea, child: child),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}


