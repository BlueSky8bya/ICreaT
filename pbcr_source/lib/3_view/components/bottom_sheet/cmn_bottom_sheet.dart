
import 'package:flutter/material.dart';
import 'package:icreat_dct/3_view/components/bottom_sheet/base_cmn_bottom_sheet.dart';
import 'package:icreat_dct/3_view/components/bottom_sheet/base_cmn_bottom_sheet_button_item.dart';

class CMNBottomSheet {
  /// 바텀시트 여는 함수
  /// 바텀시트도 네비게이터 스택에 쌓이기 때문에
  /// [routeSettings]을 지정해주면 NavigatorObserver에서 확인 가능
  static Future<T?> showBottomSheet<T>(
    BuildContext context, {
    Widget? titleIcon,
    bool showTitle = true,
    required String title,
    List<BaseCMNBottomSheetButtonItem> buttonList = const [],
    TextStyle? titleStyle,
    TextStyle? subTextStyle,
    Widget? content,
    Axis? buttonDirection,
    bool isButtonDirectionAdaptable = false,
    String? subText,
    bool isDismissible = true,
    bool? enableDrag,
    bool? useSafeArea,
    bool? useRootNavigator,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? buttonPadding,
    bool showPaddingBetweenButton = true,
    Function? onExit,
    String? routeName,
    Map<String, dynamic>? routeArguments,
  }) {
    return showModalBottomSheet(
        context: context,
        builder: (context) => Padding(
              padding: EdgeInsets.only(
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: BaseCMNBottomSheet(
                titleIcon: titleIcon,
                showTitle: showTitle,
                title: title,
                subText: subText,
                buttonDirection: buttonDirection ?? Axis.horizontal,
                isButtonDirectionAdaptable: isButtonDirectionAdaptable,
                buttons: buttonList,
                content: content,
                titleStyle: titleStyle,
                subTextStyle: subTextStyle,
                contentPadding: contentPadding,
                buttonPadding: buttonPadding,
                showPaddingBetweenButton: showPaddingBetweenButton,
                onExit: onExit,
              ),
            ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        enableDrag: enableDrag ?? true,
        useSafeArea: useSafeArea ?? true,
        useRootNavigator: useRootNavigator ?? true,
        isDismissible: isDismissible,
        routeSettings: RouteSettings(
          name: routeName,
          arguments: routeArguments,
        ));
  }

  static Future<T?> showCommentBottomSheet<T>(
    BuildContext context, {
    required Widget Function(BuildContext) builder,
    String? routeName,
  }) {
    return showModalBottomSheet(
      context: context,
      useSafeArea: true,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: builder,
    );
  }
}
