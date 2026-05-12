import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import 'package:icreat_dct/3_view/components/button/custom_inkwell.dart';
import 'package:icreat_dct/theme/extenstion/build_context_ext.dart';
import 'package:icreat_dct/theme/extenstion/text_styles_ext.dart';
import 'package:icreat_dct/theme/text_styles.dart';

import 'nav_bar_type.dart';
import 'nav_bar_view_model.dart';

class NavBarView extends GetView<NavBarViewModel> {
  final Widget child;

  const NavBarView({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: controller.pageStorageBucket,
        child: child,
      ),
      bottomNavigationBar: Material(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: kToolbarHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: context.borderPrimary, width: 1),
                  ),
                ),
                child: Row(
                  children: controller.tabList.map((tab) => Expanded(
                    child: NavBarItem(
                      type: tab,
                      isSelected: controller.curTab.value == tab,
                      onTap: () => controller.onTapNavigate(context, tab)),
                    ),
                  ).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final NavBarType type;
  final bool isSelected;
  final VoidCallback onTap;

  const NavBarItem({
    super.key,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  Color _tabColor(BuildContext context) {
    if (isSelected) {
      return context.textBrand;
    } else {
      return context.textTertiary;
    }
  }

  TextStyle _labelStyle(BuildContext context) =>
      TextStyles.caption2.medium.fromColor(_tabColor(context));

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      isCircle: true,
      onTap: () => onTap(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconTheme(
              data: IconThemeData(
                color: _tabColor(context),
              ),
              child: isSelected ? type.selectedIcon : type.unselectedIcon,
            ),
            const SizedBox(height: 4),
            Text(
              type.label,
              style: _labelStyle(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
