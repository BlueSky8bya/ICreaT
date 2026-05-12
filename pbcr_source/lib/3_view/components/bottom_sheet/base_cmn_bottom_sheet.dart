import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icreat_dct/3_view/components/bottom_sheet/base_cmn_bottom_sheet_button_item.dart';
import 'package:icreat_dct/3_view/components/button/base/button_color_set.dart';
import 'package:icreat_dct/3_view/components/button/opacity_widget_button.dart';
import 'package:icreat_dct/3_view/components/button/solid_button.dart';
import 'package:icreat_dct/3_view/components/constants/box_shadows.dart';
import 'package:icreat_dct/8_extension/list_ext.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

class BaseCMNBottomSheet extends StatefulWidget {
  const BaseCMNBottomSheet({
    super.key,
    this.showTitle = true,
    this.titleIcon,
    required this.title,
    required this.buttons,
    this.titleStyle,
    this.subTextStyle,
    this.content,
    this.subText,
    this.buttonDirection = Axis.horizontal,
    this.isButtonDirectionAdaptable = false,
    this.contentPadding,
    this.buttonPadding,
    this.onExit,
    this.borderRadius,
    this.showPaddingBetweenButton = true,
  });

  final bool showTitle;
  final Widget? titleIcon;
  final String title;
  final TextStyle? titleStyle;
  final String? subText;
  final TextStyle? subTextStyle;
  final List<BaseCMNBottomSheetButtonItem> buttons;
  final Axis buttonDirection;
  final bool isButtonDirectionAdaptable;
  final Widget? content;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? buttonPadding;
  final Function? onExit;
  final double? borderRadius;
  final bool showPaddingBetweenButton;

  @override
  State<BaseCMNBottomSheet> createState() => _BaseCMNBottomSheetState();
}

class _BaseCMNBottomSheetState extends State<BaseCMNBottomSheet> {
  static const EdgeInsets _defaultVertPadding =
      EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets _defaultHoriPadding =
      EdgeInsets.fromLTRB(16, 0, 16, 12);

  bool get _hasSubText => widget.subText != null && widget.subText!.isNotEmpty;

  Color _backgroundColor(BuildContext context) => context.bgPrimary;

  TextStyle _titleStyle(BuildContext context) =>
      widget.titleStyle ?? TextStyles.body1.semiBold.primaryColor(context);

  TextStyle _subTextStyle(BuildContext context) =>
      widget.subTextStyle ?? TextStyles.body2.tertiaryColor(context);

  @override
  void dispose() {
    widget.onExit?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Container(
        decoration: BoxDecoration(
          color: _backgroundColor(context),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16),
          ),
          boxShadow: BoxShadows.shadow16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            if (widget.showTitle) _buildTitleWidget(context),
            if (widget.content != null)
              Flexible(
                  child: Padding(
                padding: widget.contentPadding ?? _defaultVertPadding,
                child: widget.content!,
              )),
            if (widget.showPaddingBetweenButton) const SizedBox(height: 20),
            if (widget.isButtonDirectionAdaptable)
              _buildAdaptableButtons()
            else if (widget.buttonDirection == Axis.horizontal)
              _buildHorizontalButtons()
            else
              _buildVerticalButtons(),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleWidget(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    if (widget.titleIcon != null) ...[
                      widget.titleIcon!,
                      const SizedBox(width: 4),
                    ],
                    Text(
                      widget.title,
                      style: _titleStyle(context),
                    ),
                  ],
                ),
                if (_hasSubText)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      widget.subText!,
                      style: _subTextStyle(context),
                    ),
                  )
              ],
            ),
          ),
        ),
        OpacityWidgetButton(
          onTap: (context) => context.pop(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 16, 16, 16),
            child: Icon(
              Icons.close,
              size: 24,
              color: context.textPrimary,
            )
            // child: SvgIcons.block.iconBuilder(size: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(BaseCMNBottomSheetButtonItem item) {
    return SolidButton(
      padding: const EdgeInsets.symmetric(vertical: 13),
      text: item.text,
      onTap: item.onTap,
      leadingIcon: item.icon,
      isOutline: item.colorSet == ButtonColorSet.outline,
      textColor: item.colorSet.textColor(context),
      highlightColor: item.colorSet.highlightColor(context),
      color: item.colorSet.color(context),
      borderRadius: item.borderRadius,
    ).large;
  }

  Widget _buildAdaptableButtons() {
    bool isOdd = widget.buttons.length % 2 == 1;
    int buttonCnt = widget.buttons.length;
    return Padding(
      padding: widget.buttonPadding ?? _defaultHoriPadding,
      child: LayoutBuilder(
        builder: (ctx, box) {
          var maxW = box.maxWidth;
          var buttonW = (maxW - 12) / 2;
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: widget.buttons
                .mapIndexed((idx, item) => SizedBox(
                    width: (isOdd && (idx == buttonCnt - 1)) ? maxW : buttonW,
                    child: _buildButton(item)))
                .toList(),
          );
        },
      ),
    );
  }

  Widget _buildHorizontalButtons() {
    List<Widget> buttonWidgets = widget.buttons
        .map<Widget>((item) => Expanded(child: _buildButton(item)))
        .toList()
        .insertBetween(const SizedBox(width: 12));

    return Padding(
      padding: widget.buttonPadding ?? _defaultHoriPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: buttonWidgets,
      ),
    );
  }

  Widget _buildVerticalButtons() {
    List<Widget> buttonWidgets = widget.buttons
        .map<Widget>((item) => _buildButton(item))
        .toList()
        .insertBetween(const SizedBox(height: 8))
      ..add(const SizedBox(height: 12));

    return Padding(
      padding: widget.buttonPadding ?? _defaultVertPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttonWidgets,
      ),
    );
  }
}
