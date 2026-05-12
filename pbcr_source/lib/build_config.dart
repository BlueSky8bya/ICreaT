import 'package:flutter/foundation.dart';

class BuildConfig {
  /// 0: release, 1: profile, 2: debug
  static int get _idx => kReleaseMode ? 0 : (kProfileMode ? 1 : 2);

  static const enableMocking = false; // to enable dio mocking when debug mode

  static const List<String> _buildVariant = [
    'dev',
    'test',
    'prod',
  ];

  static String get buildVariant => _buildVariant[_idx];

  static final List<String> _ApiAddr = [
    'https://icreatdct.btsd.io/invoke', // release
    'https://icreatdct.btsd.io/invoke',
    'https://icreatdct.btsd.io/invoke', // debug
  ];

  static String get apiBaseUrl => _ApiAddr[_idx];

  static final List<String> _esourceApiAddr = [
    'https://icreatdct.btsd.io/invoke', // release
    'https://icreatdct.btsd.io/invoke',
    'https://icreatdct.btsd.io/invoke', // debug
  ];

  static String get esourceApiBaseUrl => _esourceApiAddr[_idx];
}
