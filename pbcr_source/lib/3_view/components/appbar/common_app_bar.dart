import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icreat_dct/3_view/components/button/svg_icon_button.dart';
import 'package:icreat_dct/3_view/components/constants/svg_icons.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final bool showDefaultBackButton;
  final Function(BuildContext)? onTapBack;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final double? scrolledUnderElevation;
  final bool Function(ScrollNotification) notificationPredicate;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final ShapeBorder? shape;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final bool primary;
  final bool? centerTitle;
  final bool excludeHeaderSemantics;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  final double? toolbarHeight;
  final double? leadingWidth;
  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool forceMaterialTransparency;
  final Clip? clipBehavior;
  final Color? backbuttonColor;
  final SvgIcons? backIcon;

  const CommonAppBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.onTapBack,
    this.showDefaultBackButton = true,
    this.bottom,
    this.elevation,
    this.scrolledUnderElevation,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.toolbarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = true,
    this.clipBehavior,
    this.backbuttonColor,
    this.backIcon,
  });

  factory CommonAppBar.title(
    BuildContext context, {
    required String title,
    List<Widget>? actions,
    TextStyle? titleStyle,
    bool showBackButton = true,
    bool? centerTitle,
    Color? backgroundColor,
    Function(BuildContext)? onTapBack,
  }) {
    return CommonAppBar(
      title: Text(
        title,
        style: titleStyle ?? TextStyles.body1.semiBold.primaryColor(context),
      ),
      backgroundColor: backgroundColor,
      titleSpacing: showBackButton ? 0 : 16,
      onTapBack: onTapBack,
      showDefaultBackButton: showBackButton,
      centerTitle: centerTitle,
      actions: actions,
      titleTextStyle: titleStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showDefaultBackButton && leading == null
          ? Navigator.canPop(context)
              ? SvgIconButton.backButton(
                  onTap: (_) => _onTapBack(context),
                  color: backbuttonColor,
                  size: 24,
                  padding: const EdgeInsets.all(16),
                )
              : null
          : leading,
      automaticallyImplyLeading: false,
      title: title,
      actions: actions,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      elevation: elevation,
      shadowColor: shadowColor,
      shape: shape,
      // backgroundColor: backgroundColor,
      backgroundColor: backgroundColor ?? context.bgPrimary,
      foregroundColor: foregroundColor,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      primary: primary,
      centerTitle: centerTitle,
      excludeHeaderSemantics: excludeHeaderSemantics,
      titleSpacing: titleSpacing,
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
      toolbarHeight: toolbarHeight,
      leadingWidth: leadingWidth,
      toolbarTextStyle: toolbarTextStyle,
      titleTextStyle: titleTextStyle,
      systemOverlayStyle: systemOverlayStyle,
      clipBehavior: clipBehavior ?? Clip.none,
      forceMaterialTransparency: forceMaterialTransparency,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? kToolbarHeight);

  void _onTapBack(BuildContext context) {
    Navigator.of(context).maybePop();
    onTapBack?.call(context);
  }
}
