import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icreat_dct/6_util/device_info.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({
    super.key,
    this.color,
  });
  final Color? color;

  static const loadingBackgroundColor = Color(0x1F000000);

  factory LoadingView.indicatorBright() =>
      const LoadingView(color: Colors.white);

  factory LoadingView.indicatorDark() =>
      const LoadingView(color: Color(0xFF3C3C44));

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Center(
      child: DeviceInfo.isIOS
          ? CupertinoActivityIndicator(
              radius: w * 0.05,
              color: color,
            )
          : CircularProgressIndicator(
              color: color,
            ),
    );
  }
}
