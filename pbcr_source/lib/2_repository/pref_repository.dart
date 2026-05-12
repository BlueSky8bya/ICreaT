import 'package:shared_preferences/shared_preferences.dart';

import 'package:icreat_dct/6_util/logger.dart';
import 'package:icreat_dct/6_util/url.dart';
import 'package:icreat_dct/8_extension/string_ext.dart';
import 'package:icreat_dct/build_config.dart';



class PrefRepository {
  final SharedPreferences _prefs;
  PrefRepository(this._prefs);

  static const _keyWeightDeviceId = 'PREF_KEY_WEIGHT_DEVICE_ID';
  static const _keyWeightDeviceLatestSeqNum = 'PREF_KEY_WEIGHT_DEVICE_LATEST_SEQ_NUM';
  static const _keyFcmToken = 'PREF_KEY_FCM_TOKEN';

  static const _keyProjectId = 'PREF_KEY_PROJECT_ID';
  static const _keySubjectId = 'PREF_KEY_SUBJECT_ID';
  static const _keyPid = 'PREF_KEY_PID';
  static const _keyOrganCode = 'PREF_KEY_ORGAN_CODE';
  static const _keyPatName = 'PREF_KEY_PAT_NAME';
  static const _keyIcfDocument = 'PREF_KEY_ICF_DOCUMENT';

  /// 애플 건강 권한 요청 여부
  /// true인 경우 이전에 1번이라도 요청한 것으로 간주
  static const _keyAppleHealthRequested = 'PREF_KEY_APPLE_HEALTH_REQUESTED';

  String? get weightDeviceID => _prefs.getString(_keyWeightDeviceId);
  Future<void> setWeightDeviceID(String? id) async {
    if (id == null) {
      await _prefs.remove(_keyWeightDeviceId);
    } else {
      await _prefs.setString(_keyWeightDeviceId, id);
    }
  }

  int get weightDeviceLatestSeqNum =>
      _prefs.getInt(_keyWeightDeviceLatestSeqNum) ?? 0;
  Future<void> setWeightDeviceLatestSeqNum(int seqNum) async =>
      await _prefs.setInt(_keyWeightDeviceLatestSeqNum, seqNum);

  bool get appleHealthRequested =>
      _prefs.getBool(_keyAppleHealthRequested) ?? false;
  Future<void> setAppleHealthRequested(bool value) async =>
      await _prefs.setBool(_keyAppleHealthRequested, value);

  // FCM
  String? get fcmToken => _prefs.getString(_keyFcmToken);
  Future<void> setFcmToken(String? token) async {
    if (token == null) {
      await _prefs.remove(_keyFcmToken);
    } else {
      await _prefs.setString(_keyFcmToken, token);
    }
  }

  String? get projectId => _prefs.getString(_keyProjectId);
  Future<void> setProjectId(String? projectId) async {
    if (projectId == null) {
      await _prefs.remove(_keyProjectId);
    } else {
      await _prefs.setString(_keyProjectId, projectId);
    }
  }

  String? get subjectId => _prefs.getString(_keySubjectId);
  Future<void> setSubjectId(String? subjectId) async {
    if (subjectId == null) {
      await _prefs.remove(_keySubjectId);
    } else {
      await _prefs.setString(_keySubjectId, subjectId);
    }
  }

  String? get pid => _prefs.getString(_keyPid);
  Future<void> setPid(String? pid) async {
    if (pid == null) {
      await _prefs.remove(_keyPid);
    } else {
      await _prefs.setString(_keyPid, pid);
    }
  }

  String? get organCode => _prefs.getString(_keyOrganCode);
  Future<void> setOrganCode(String? organCode) async {
    if (organCode == null) {
      await _prefs.remove(_keyOrganCode);
    } else {
      await _prefs.setString(_keyOrganCode, organCode);
    }
  }

  // 대상자 이름 이니셜(예: LSM)
  String? get patName => _prefs.getString(_keyPatName);
  Future<void> setPatName(String? patName) async {
    if (patName == null) {
      await _prefs.remove(_keyPatName);
    } else {
      await _prefs.setString(_keyPatName, patName);
    }
  }

  String? get icfDocument => _prefs.getString(_keyIcfDocument);
  Future<void> setIcfDocument(String? documentUrl) async {
    if (documentUrl.isNullOrEmpty) {
      await _prefs.remove(_keyIcfDocument);
    } else {
      var sanitizedUrl = documentUrl!;
      if (!sanitizedUrl.startsWith("http")) {
        sanitizedUrl = combineUrlPaths(BuildConfig.apiBaseUrl, sanitizedUrl);
        Logger.debug("sanitizedUrl=$sanitizedUrl");
      }
      await _prefs.setString(_keyIcfDocument, sanitizedUrl);
    }
  }
}
