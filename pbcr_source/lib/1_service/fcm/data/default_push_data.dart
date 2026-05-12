import 'dart:convert';

import 'package:icreat_dct/1_service/fcm/base/base_push_data.dart';

class DefaultPushData extends BasePushData {
  DefaultPushData({
    super.title,
    super.body,
    this.uid,
  });

  String? uid;

  void setUid(String? uid) => this.uid = uid;

  @override
  String toString() => 'DefaultPushData(title: $title, body: $body, uid: $uid)';

  @override
  Map<String, dynamic> toMap() {
    final val = <String, dynamic>{};
    writeNotNull(val, 'title', title);
    writeNotNull(val, 'body', body);
    writeNotNull(val, 'user_uid', uid);
    return val;
  }

  factory DefaultPushData.fromMap(Map<String, dynamic> map) {
    return DefaultPushData(
      title: map['title'] as String?,
      body: map['body'] as String?,
      uid: map['user_uid'] as String?,
    );
  }

  factory DefaultPushData.fromJson(String source) {
    var map = jsonDecode(source);
    return DefaultPushData.fromMap(map);
  }
}
