import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class BasePushData {
  static const fcmPushTypeKey = 'push_type';
  static const fcmPushTitleKey = 'title';
  static const fcmPushBodyKey = 'body';
  static const fcmPushImageKey = 'image';

  static const pushDataNameKey = 'name';
  static const pushDataPushTypeKey = 'pushType';
  static const pushDataExtraDataKey = 'extraData';

  static VoidCallback? onMovePage;
  final String? title;
  final String? body;
  final String? image;
  String? fcmTypeStr;

  BasePushData({
    this.title,
    this.body,
    this.image,
  });

  String toJson() {
    var result = jsonEncode(
      {
        pushDataNameKey: runtimeType.toString(),
        pushDataPushTypeKey: fcmTypeStr,
        pushDataExtraDataKey: getExtraData(),
      },
    );
    return result;
  }

  String getExtraData() => jsonEncode(toMap());

  Map<String, dynamic> toMap();

  void writeNotNull(Map<String, dynamic> val, String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }
}
