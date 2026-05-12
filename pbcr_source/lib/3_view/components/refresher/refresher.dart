import 'package:flutter/material.dart';
import 'package:icreat_dct/6_util/device_info.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Refresher extends StatelessWidget {
  final RefreshController controller;
  final ScrollController? scrollController;
  final void Function() onRefresh;
  final Widget child;

  const Refresher({
    super.key,
    required this.controller,
    required this.onRefresh,
    required this.child,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller,
      scrollController: scrollController,
      onRefresh: onRefresh,
      physics: const BouncingScrollPhysics(),
      header: DeviceInfo.isIOS
          ? const ClassicHeader(
              idleText: '',
              releaseText: '',
              refreshingText: '',
              completeText: '',
              failedText: '',
              spacing: 0,
            )
          : MaterialClassicHeader(color: Theme.of(context).primaryColor),
      child: child,
    );
  }
}
